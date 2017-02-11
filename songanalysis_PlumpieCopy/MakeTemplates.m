function [] = MakeTemplates(DirectoryName, BatchFile, FFTBinSize, FileType, ChanNo)

if (DirectoryName(end) ~= '/')
    DirectoryName(end + 1) = '/';
end

cd(DirectoryName);

NoteInfo = [];
fid = fopen(BatchFile,'r');

FileNo = 0;
NoteNo = 0;

while (~feof(fid))
    NoteFileName = fscanf(fid,'%s',1);
    FileNo = FileNo + 1;
    
    Notes = load(NoteFileName);
    
    for i = 1:length(Notes.labels),
        NoteNo = NoteNo + 1;
        NoteInfo{NoteNo, 1} = Notes.labels(i);
        NoteInfo{NoteNo, 2} = Notes.onsets(i);
        NoteInfo{NoteNo, 3} = Notes.offsets(i);
        NoteInfo{NoteNo, 4} = NoteFileName;
    end
end
fclose(fid);

disp(['Loaded ',num2str(NoteNo), ' notes from ',num2str(FileNo),' files']);

Template = [];
NoteLabels = unique([NoteInfo{:,1}]);
for i = 1:length(NoteLabels),
    Matches = find([NoteInfo{:,1}] == NoteLabels(i));
    AverageDuration = mean([NoteInfo{Matches,3}] - [NoteInfo{Matches,2}]);
    MinDuration = min([NoteInfo{Matches,3}] - [NoteInfo{Matches,2}]);
    for j = min([5, length(Matches)]),
        FileName = [NoteInfo{Matches(j),4}];
        FileName = FileName(1:(end - 8));
        BirdName = FileName(1:(find((FileName == '_') | (FileName == '-'))));
        if (strfind(FileType, 'okrank'))
            [RawData, Fs] = ReadOKrankData(DirectoryName, FileName, ChanNo);
        else
            if (strfind(FileType, 'obs'))
                [RawData, Fs] = soundin_copy(DirectoryName, FileName, 'obs0r');    
            end
        end
        Onset = round([NoteInfo{Matches(j),2}] * Fs/1000);
        Offset = round([NoteInfo{Matches(j),3}] * Fs/1000);
        RawData = RawData(Onset:Offset);
        for k = 1:floor(MinDuration/FFTBinSize);
            TempData = RawData((round((k-1)*FFTBinSize*Fs/1000) + 1):(round((k)*FFTBinSize*Fs/1000)));
            TempFFT = abs(fft(TempData));
            TempFFT(1) = 0;
            % TempFFT = TempFFT(1:(length(TempFFT)/2+1))/sum(TempFFT(1:(length(TempFFT)/2+1)));
            TempFFT = TempFFT(1:(length(TempFFT)/2+1));
            TempFFT = (TempFFT - mean(TempFFT))/std(TempFFT);
            Template{i,j,k} = TempFFT;
        end
    end
end

for i = 1:length(NoteLabels),
    for j = 1:size(Template,3),
        Temp = [];
        for k = 1:size(Template,2),
            if (length([Template{i,k,j}]) > 0)
                Temp((end+1),:) = [Template{i,k,j}];
            end
        end
        if (length(Temp) > 0)
            %MeanTemplate = mean(Temp);
            MeanTemplate = Temp;
            TemplateFileName = [BirdName,'_template','_',NoteLabels(i),'_',num2str(j),'.txt'];
            fid = fopen(TemplateFileName,'w');
            for DataPoints = 1:length(Temp),
                fprintf(fid,'%g\n',MeanTemplate(DataPoints));
            end
            fclose(fid);
        end
    end
end
disp('Finished');