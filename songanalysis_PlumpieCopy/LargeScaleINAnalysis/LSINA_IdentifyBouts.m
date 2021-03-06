function [Bouts, BoutIndices, AllOnsets, AllOffsets, AllLabels] = LSINA_IdentifyBouts(BirdParameters)

% Now based on whether the data is continuous or not, identify bouts of
% song
if (BirdParameters.Continuousdata == 0)
    AllOffsets = [];
    AllOnsets = [];
    AllLabels = [];
    FileTime = 0;
    for j = 1:length(BirdParameters.NoteInfo),
        Bouts(j) = 0;
        BoutIndices{j} = [];

        Gaps = BirdParameters.NoteInfo{j}.onsets(2:end) - BirdParameters.NoteInfo{j}.offsets(1:end-1);
        LongGaps = find(Gaps >= BirdParameters.Interboutinterval);
        if (isempty(LongGaps))
            if (~isempty(strfind(BirdParameters.NoteInfo{j}.labels, BirdParameters.CommonMotifs{1})))
                if ((BirdParameters.NoteInfo{j}.onsets(1) >= BirdParameters.Interboutinterval) && (BirdParameters.NoteInfo{j}.offsets(end) <= (BirdParameters.FileLen(j) - BirdParameters.Interboutinterval)))
                    Bouts(j) = 1;
                    BoutIndices{j}(end+1,:) = [1 length(BirdParameters.NoteInfo{j}.onsets)];
                    
                    AllLabels = [AllLabels BirdParameters.NoteInfo{j}.labels(BoutIndices{j}(end,1):BoutIndices{j}(end,2))];
                    AllOnsets = [AllOnsets; (FileTime + BirdParameters.NoteInfo{j}.onsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];
                    AllOffsets = [AllOffsets; (FileTime + BirdParameters.NoteInfo{j}.offsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];
                end
            end
        else
            for k = 1:length(LongGaps),
                if (k == 1)
                    if (~isempty(strfind(BirdParameters.NoteInfo{j}.labels(1:LongGaps(k)), BirdParameters.CommonMotifs{1})))
                        if (BirdParameters.NoteInfo{j}.onsets(1) >= BirdParameters.Interboutinterval)
                            Bouts(j) = 1;
                            BoutIndices{j}(end+1,:) = [1 LongGaps(k)];
                            AllLabels = [AllLabels BirdParameters.NoteInfo{j}.labels(BoutIndices{j}(end,1):BoutIndices{j}(end,2))];
                            AllOnsets = [AllOnsets; (FileTime + BirdParameters.NoteInfo{j}.onsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];
                            AllOffsets = [AllOffsets; (FileTime + BirdParameters.NoteInfo{j}.offsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];                        
                        end
                    end
                else
                    if (~isempty(strfind(BirdParameters.NoteInfo{j}.labels(LongGaps(k-1)+1:LongGaps(k)), BirdParameters.CommonMotifs{1})))
                        Bouts(j) = 1;
                        BoutIndices{j}(end+1,:) = [(LongGaps(k-1)+1) LongGaps(k)];
    
                        AllLabels = [AllLabels BirdParameters.NoteInfo{j}.labels(BoutIndices{j}(end,1):BoutIndices{j}(end,2))];
                        AllOnsets = [AllOnsets; (FileTime + BirdParameters.NoteInfo{j}.onsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];
                        AllOffsets = [AllOffsets; (FileTime + BirdParameters.NoteInfo{j}.offsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];                        
                    end
                end
            end
            if (~isempty(strfind(BirdParameters.NoteInfo{j}.labels(LongGaps(end)+1:length(BirdParameters.NoteInfo{j}.onsets)), BirdParameters.CommonMotifs{1})))
                if (BirdParameters.NoteInfo{j}.offsets(end) <= (BirdParameters.FileLen(j) - BirdParameters.Interboutinterval))
                    Bouts(j) = 1;
                    BoutIndices{j}(end+1,:) = [(LongGaps(end)+1) length(BirdParameters.NoteInfo{j}.onsets)];
                    
                    AllLabels = [AllLabels BirdParameters.NoteInfo{j}.labels(BoutIndices{j}(end,1):BoutIndices{j}(end,2))];
                    AllOnsets = [AllOnsets; (FileTime + BirdParameters.NoteInfo{j}.onsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];
                    AllOffsets = [AllOffsets; (FileTime + BirdParameters.NoteInfo{j}.offsets(BoutIndices{j}(end,1):BoutIndices{j}(end,2)))];                    
                end
            end
        end
        FileTime = FileTime + BirdParameters.FileLen(j);
    end
else
    [AllLabels, AllOnsets, AllOffsets] = CombineContinuousDataNoteFiles(BirdParameters.DataDirectory, BirdParameters.SongFileNames, fullfile(BirdParameters.DataDirectory, 'ASSLNoteFiles'), BirdParameters.FileType);
    Gaps = AllOnsets(2:end) - AllOffsets(1:end-1);
    LongGaps = find(Gaps >= BirdParameters.Interboutinterval);
    Bouts = 0;
    BoutIndices = [];

    if (isempty(LongGaps))
        if (~isempty(strfind(AllLabels, BirdParameters.CommonMotifs{1})))
            if ((AllOnsets(1) >= BirdParameters.Interboutinterval) && (AllOffsets(end) <= (sum(BirdParameters.FileLen) - BirdParameters.Interboutinterval)))
                Bouts = 1;
                BoutIndices(end+1,:) = [1 length(AllOnsets)];
            end
        end
    else
        for k = 1:length(LongGaps),
            if (k == 1)
                if (isempty(strfind(AllLabels(1:LongGaps(k)), BirdParameters.CommonMotifs{1})))
                    continue;
                end

                if (AllOnsets(1) >= BirdParameters.Interboutinterval)
                    Bouts = 1;
                    BoutIndices(end+1,:) = [1 LongGaps(k)];
                end
            else
                if (isempty(strfind(AllLabels((LongGaps(k-1) + 1):LongGaps(k)), BirdParameters.CommonMotifs{1})))
                    continue;
                end
                Bouts = 1;
                BoutIndices(end+1,:) = [(LongGaps(k-1)+1) LongGaps(k)];
            end
        end
        if (~isempty(strfind(AllLabels((LongGaps(end) + 1):end), BirdParameters.CommonMotifs{1})))
            if (AllOffsets(end) <= (sum(BirdParameters.FileLen) - BirdParameters.Interboutinterval))
                Bouts = 1;
                BoutIndices(end+1,:) = [(LongGaps(end)+1) length(AllLabels)];
            end
        end
    end
end
