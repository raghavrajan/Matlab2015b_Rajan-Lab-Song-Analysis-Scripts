function [Sounds] = AutoSegmentSongFiles(BatchFileName,FileType,TemplateTime,Template)

fid = fopen(BatchFileName,'r');

FileIndex = 1;

SoundIndex = 0;
Threshold = 0;

figure;

while (~(feof(fid)))
    try
        % First read in the song file from the batch file
        SongFileName = fgetl(fid);
        if (strfind(FileType,'wav'))
            [SongAmplitude, Fs] = wavread(SongFileName);
        else
            if (strfind(FileType,'obs'))
                DirectoryName = pwd;
                DirectoryName(end + 1) = '/';
                [SongAmplitude, Fs] = soundin_copy(DirectoryName,SongFileName,FileType);
            end
        end

        FiltSongAmplitude = bandpass(SongAmplitude,Fs,300,10000);
        clear SongAmplitude;
        
        SquaredSongAmplitude = FiltSongAmplitude.^2;
        clear FiltSongAmplitude;
        
        SmoothingWindowLength = round(5/1000 * Fs);
        SmoothingWindow = ones(1,SmoothingWindowLength)/SmoothingWindowLength;

        SmoothSongAmplitude = conv(SmoothingWindow,SquaredSongAmplitude);
        Offset = round((length(SmoothSongAmplitude) - length(SquaredSongAmplitude))/2);% Get rid of convolution induced offset
        SmoothSongAmplitude = SmoothSongAmplitude((1 + Offset):(length(SquaredSongAmplitude) + Offset));
        clear SquaredSongAmplitude;
        
        WindowStep = 44*5;
        WindowLength = length(Template);
        
        TotalNoofWindows = floor(length(SmoothSongAmplitude)/length(Template)) - 1;        
        
        WindowIndices = 1:WindowStep:(TotalNoofWindows*WindowLength);
        WindowIndexLength = size(WindowIndices,1);
        
        while (WindowIndexLength < length(Template))
            WindowIndices = [WindowIndices; (WindowIndices + WindowIndexLength)];
            WindowIndexLength = size(WindowIndices,1);            
        end
        
        WindowIndices((length(Template) + 1):end,:) = [];
        
        Multiplier = repmat(Template,1,size(WindowIndices,2));
        Window = SmoothSongAmplitude(WindowIndices);
        SongTime = 0:1/Fs:(length(SmoothSongAmplitude)/Fs);
        SongTime(end) = [];
        Temp = Window - Multiplier;
        hold off;
        plot(SongTime,SmoothSongAmplitude);
        hold on;
        plot(SongTime(WindowIndices(1,:)),((sum(Temp).*sum(Temp))/(max(sum(Temp).*sum(Temp))) * max(SmoothSongAmplitude)),'r');
        disp('Finished');
    catch
        disp(['Could not analyse file ',SongFileName]);
    end
    
    disp(['Finished analysing file # ',num2str(FileIndex)]);
    FileIndex = FileIndex + 1;
end

figure
plot([Sounds.Duration],[Sounds.Area],'k+');
figure;
plot([Sounds.Duration],[Sounds.MeanAmplitude],'k+');
fclose(fid);
    
    