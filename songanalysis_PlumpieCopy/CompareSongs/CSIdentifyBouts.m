function [Bouts, BoutLens, AllOnsets, AllOffsets, AllLabels, AllFeats, RemovalIndices] = CSIdentifyBouts(ASSLData, BoutDefinition, InterBoutInterval)

if (strfind(BoutDefinition, 'Each new file is a bout'))
    RemovalIndices = [];
    AllOnsets = [];
    AllOffsets = [];
    AllLabels = [];
    AllFeats = [];
    
    for i = 1:length(ASSLData.SyllOnsets),
        if (~isempty(ASSLData.SyllOnsets{i}))
            Bouts{i} = [1 length(ASSLData.SyllOnsets{i})]; 
            BoutLens{i} = ASSLData.SyllOffsets{i}(Bouts{i}(end,2)) - ASSLData.SyllOnsets{i}(Bouts{i}(1,1));
            AllLabels = [AllLabels '<Q' ASSLData.SyllLabels{i} 'q>'];
            AllOnsets = [AllOnsets; 0; ASSLData.SyllOnsets{i}(1); ASSLData.SyllOnsets{i}(:); ASSLData.SyllOffsets{i}(end); ASSLData.FileDur{i}*1000];
            AllOffsets = [AllOffsets; 0; ASSLData.SyllOnsets{i}(1); ASSLData.SyllOffsets{i}(:); ASSLData.SyllOffsets{i}(end); ASSLData.FileDur{i}*1000];
            TempFeats = [];
            for j = 1:length(ASSLData.ToBeUsedFeatures),
                eval(['TempFeats = [TempFeats ASSLData.', ASSLData.ToBeUsedFeatures{j}, '{', num2str(i), '}(:)];']);
            end
            AllFeats = [AllFeats; zeros(2, size(TempFeats,2)); TempFeats; zeros(2, size(TempFeats,2))];
        else
            Bouts{i} = [];
            BoutLens{i} = 0;
        end
    end
else
    if (strfind(BoutDefinition, 'Inter-bout interval'))
        RemovalIndices = [];
        for i = 1:length(ASSLData.SyllOnsets),
            Onsets = ASSLData.SyllOnsets{i};
            Onsets = ASSLData.SyllOffsets{i};
            
            AllLabels = [AllLabels 'Q' ASSLData.SyllLabels{i} 'q'];
            AllOnsets = [AllOnsets; ASSLData.SyllOnsets{i}(1); ASSLData.SyllOnsets{i}(:); ASSLData.SyllOffsets{i}(end)];
            AllOffsets = [AllOffsets; ASSLData.SyllOnsets{i}(1); ASSLData.SyllOffsets{i}(:); ASSLData.SyllOffsets{i}(end)];

            Onsets = Onsets(:);
            Offsets = Offsets(:);
            GapDurs = Onsets(2:end) - Offsets(1:end-1);
            
            LongGaps = find(GapDurs >= InterBoutInterval);

            if (~isempty(LongGaps))
                Bouts{i} = [Onsets(1) Onsets(LongGaps + 1)'; Offsets(LongGaps)' Offsets(end)]';
                Bouts{i} = [Bouts{i} [1:1:size(Bouts{i},1)]' ones(size(Bouts{i},1),1)*Index];
            else
                Bouts{i} = [-100 -100 1 Index];
            end
        end
    else
        if (strfind(BoutDefinition, 'Continuous'))
            Onsets = [];
            Offsets = [];
            Labels = [];
            Feats = [];
            CumFileDur = 0;
            for i = 1:length(ASSLData.SyllOnsets),
                CumFileDur = CumFileDur + ASSLData.FileDur{i};
                CumPrevFileDur = CumFileDur - ASSLData.FileDur{i};
                
                if (~isempty(ASSLData.SyllOnsets{i}))
                    TempFeats = [];
                    for j = 1:length(ASSLData.ToBeUsedFeatures),
                        eval(['TempFeats = [TempFeats ASSLData.', ASSLData.ToBeUsedFeatures{j}, '{', num2str(i), '}(:)];']);
                    end
                    if (i == 1)
                        Labels = [Labels '<' ASSLData.SyllLabels{i}];
                        Onsets = [Onsets; 0; ASSLData.SyllOnsets{i}(:)];
                        Offsets = [Offsets; 0; ASSLData.SyllOffsets{i}(:)];
                        Feats = [Feats; zeros(1, size(TempFeats,2)); TempFeats];
                    else
                        if (i == length(ASSLData.SyllOnsets))
                            Labels = [Labels ASSLData.SyllLabels{i} '>'];
                            Onsets = [Onsets; (ASSLData.SyllOnsets{i}(:) + CumPrevFileDur*1000); CumFileDur*1000];
                            Offsets = [Offsets; (ASSLData.SyllOffsets{i}(:) + CumPrevFileDur*1000); CumFileDur*1000];
                            Feats = [Feats; TempFeats; zeros(1, size(TempFeats,2))];
                        else
                            Labels = [Labels ASSLData.SyllLabels{i}];
                            Onsets = [Onsets; (ASSLData.SyllOnsets{i}(:) + CumPrevFileDur*1000)];
                            Offsets = [Offsets; (ASSLData.SyllOffsets{i}(:) + CumPrevFileDur*1000)];
                            Feats = [Feats; TempFeats];
                        end
                    end
                end
            end
            
            % Now convert the double caps symbols to one small letter -
            % since the two double caps are syllables that are spread over
            % two files
            
            DoubleCaps = regexp(Labels, '[A-P R-Z]');
            UniqueDoubleCaps = [1 (find(diff(DoubleCaps) > 1) + 1)];
            RemovalIndices = [];
            for i = 1:length(UniqueDoubleCaps),
                if (length(DoubleCaps) > UniqueDoubleCaps(i))
                    if (Labels(DoubleCaps(UniqueDoubleCaps(i))) == Labels(DoubleCaps(UniqueDoubleCaps(i) + 1)))
                        if ((DoubleCaps(UniqueDoubleCaps(i)) + 1) == DoubleCaps(UniqueDoubleCaps(i) + 1))
                            RemovalIndices = [RemovalIndices; DoubleCaps(UniqueDoubleCaps(i) + 1)];
                        end
                    end
                end
            end
            Labels(RemovalIndices - 1) = lower(Labels(RemovalIndices - 1));
            Labels(RemovalIndices) = [];
            Feats(RemovalIndices,:) = [];
            Onsets(RemovalIndices) = [];
            Offsets(RemovalIndices - 1) = [];
            
            Onsets = Onsets(:);
            Offsets = Offsets(:);
            GapDurs = Onsets(2:end) - Offsets(1:end-1);
            
            LongGaps = find(GapDurs >= InterBoutInterval);

            if (~isempty(LongGaps))
                Bouts = [1 (LongGaps + 1)'; LongGaps' length(Offsets)]';
            else
                Bouts = [-100 -100];
            end
            BoutLens = Offsets(Bouts(:,2)) - Onsets(Bouts(:,1));
            
            AllLabels = [];
            AllOnsets = [];
            AllOffsets = [];
            AllFeats = [];
            
            for i = 1:size(Bouts,1),
                if ((BoutLens(i) == 0) && ((Labels(Bouts(i,1)) == '<') || (Labels(Bouts(i,1)) == '>')))
                    AllLabels = [AllLabels Labels(Bouts(i,1):Bouts(i,2))];
                    AllOnsets = [AllOnsets; Onsets(Bouts(i,1):Bouts(i,2))];
                    AllOffsets = [AllOffsets; Offsets(Bouts(i,1):Bouts(i,2))];
                    AllFeats = [AllFeats; Feats(Bouts(i,1):Bouts(i,2), :)];
                else
                    if ((Labels(Bouts(i,1)) == '<') && (Labels(Bouts(i,2)) == '>'))
                        AllLabels = [AllLabels Labels(Bouts(i,1)) 'Q' Labels((Bouts(i,1)+1):(Bouts(i,2)-1)) 'q' Labels(Bouts(i,2))];
                        AllOnsets = [AllOnsets; Onsets(Bouts(i,1)); Onsets(Bouts(i,1) + 1); Onsets((Bouts(i,1)+1):(Bouts(i,2)-1)); Offsets(Bouts(i,2) - 1); Onsets(Bouts(i,2))];
                        AllOffsets = [AllOffsets; Offsets(Bouts(i,1)); Onsets(Bouts(i,1) + 1); Offsets((Bouts(i,1)+1):(Bouts(i,2)-1)); Offsets(Bouts(i,2) - 1); Offsets(Bouts(i,2))];
                        AllFeats = [AllFeats; Feats(Bouts(i,1),:); Feats(Bouts(i,1) + 1,:); Feats((Bouts(i,1)+1):(Bouts(i,2)-1),:); Feats(Bouts(i,2) - 1,:); Feats(Bouts(i,2),:)];
                    else
                        if (Labels(Bouts(i,1)) == '<')
                            AllLabels = [AllLabels Labels(Bouts(i,1)) 'Q' Labels((Bouts(i,1)+1):(Bouts(i,2))) 'q'];
                            AllOnsets = [AllOnsets; Onsets(Bouts(i,1)); Onsets(Bouts(i,1) + 1); Onsets((Bouts(i,1)+1):(Bouts(i,2))); Offsets(Bouts(i,2))];
                            AllOffsets = [AllOffsets; Offsets(Bouts(i,1)); Onsets(Bouts(i,1) + 1); Offsets((Bouts(i,1)+1):(Bouts(i,2))); Offsets(Bouts(i,2))];
                            AllFeats = [AllFeats; Feats(Bouts(i,1),:); Feats(Bouts(i,1) + 1,:); Feats((Bouts(i,1)+1):(Bouts(i,2)),:); Feats(Bouts(i,2),:)];
                        else
                            if (Labels(Bouts(i,2)) == '>')
                                AllLabels = [AllLabels 'Q' Labels((Bouts(i,1)):(Bouts(i,2)-1)) 'q' Labels(Bouts(i,2))];
                                AllOnsets = [AllOnsets; Onsets(Bouts(i,1)); Onsets((Bouts(i,1)):(Bouts(i,2)-1)); Offsets(Bouts(i,2) - 1); Onsets(Bouts(i,2))];
                                AllOffsets = [AllOffsets; Onsets(Bouts(i,1)); Offsets((Bouts(i,1)):(Bouts(i,2)-1)); Offsets(Bouts(i,2) - 1); Offsets(Bouts(i,2))];
                                AllFeats = [AllFeats; Feats(Bouts(i,1),:); Feats((Bouts(i,1)):(Bouts(i,2)-1),:); Feats(Bouts(i,2) - 1,:); Feats(Bouts(i,2),:)];
                            else
                                AllLabels = [AllLabels 'Q' Labels(Bouts(i,1):Bouts(i,2)) 'q'];
                                AllOnsets = [AllOnsets; Onsets(Bouts(i,1)); Onsets(Bouts(i,1):Bouts(i,2)); Offsets(Bouts(i,2))];
                                AllOffsets = [AllOffsets; Onsets(Bouts(i,1)); Offsets(Bouts(i,1):Bouts(i,2)); Offsets(Bouts(i,2))];
                                AllFeats = [AllFeats; Feats(Bouts(i,1),:); Feats(Bouts(i,1):Bouts(i,2),:); Feats(Bouts(i,2),:)];
                            end
                        end
                    end
                end
            end
        end
    end
end
disp('Finished identifying bouts');
