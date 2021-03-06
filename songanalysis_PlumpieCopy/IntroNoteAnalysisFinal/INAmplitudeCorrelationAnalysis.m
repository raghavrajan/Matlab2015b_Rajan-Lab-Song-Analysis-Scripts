function [] = INAmplitudeCorrelationAnalysis(RawDataDir, RecFileDir, INR, FileType, AlignmentPoint, Colour)

PresentDir = pwd;

BoutIndices = find((INR.FirstSyll == 'i') & (INR.SyllBeforeMotifs == 'i'));
NoofINs = INR.NoofINs(BoutIndices);
[SortedINs, SortedIndices] = sort(NoofINs);

AmplitudeIndex = 0;
for i = [SortedIndices],
    SongFile = INR.BoutDetails(BoutIndices(i)).SongFile;
    if (strfind(FileType, 'okrank'))
        [Song, Fs] = SSAReadOKrankData(RawDataDir, RecFileDir, SongFile, 1);
    else
        if (strfind(FileType, 'wav'))
            cd(RawDataDir);
            [Song, Fs] = wavread(SongFile);
            cd(PresentDir);
        else
            if (strfind(FileType, 'obs'))
                channel_string = strcat('obs',num2str(0),'r');
                [Song, Fs] = SSASoundIn([RawDataDir, '/'], RecFileDir, SongFile, channel_string);

                % Convert to V - 5V on the data acquisition is 32768
                Song = Song * 5/32768;
            end
        end
    end
    
    Time = (1:1:length(Song))/Fs;

    F_High = 1000; % high pass filter cut-off
    F_Low = 7000; % low pass filter cut-off
    
    FilterForSong = fir1(80, [F_High*2/Fs F_Low*2/Fs], 'bandpass');
    FiltSong = filtfilt(FilterForSong, 1, Song);
    SmoothWinSize = 0.008;
    
    Window = ones(round(SmoothWinSize*Fs), 1);
    Window = Window/sum(Window);
    smooth = 10*log10(conv(FiltSong.*FiltSong, Window, 'same'));
    smooth = smooth + abs(min(smooth));
    
    
    if (AlignmentPoint == -1000)
        AlignmentTime = INR.BoutDetails(BoutIndices(i)).onsets(INR.INs{BoutIndices(i)}(1));
    else
        if (AlignmentPoint > INR.NoofINs(BoutIndices(i)))
            continue;
        else
            AlignmentTime = INR.BoutDetails(BoutIndices(i)).onsets(INR.INs{BoutIndices(i)}(end) + 1 - AlignmentPoint);
        end
    end
    AlignmentTimeIndex = find(Time <= AlignmentTime, 1, 'last');
    StartIndex = AlignmentTimeIndex - round(Fs*1);
    EndIndex = AlignmentTimeIndex + round(Fs*1);
    AmplitudeIndex = AmplitudeIndex + 1;
    Amplitudes(AmplitudeIndex,:) = smooth(StartIndex:EndIndex);
end
figure(1);
hold on;
plot([1:1:size(Amplitudes,2)]/Fs - 1, std(Amplitudes)./mean(Amplitudes), Colour);
axis tight;

figure(2);
hold on;
errorbar([1:1:size(Amplitudes,2)]/Fs - 1, mean(Amplitudes), std(Amplitudes)/sqrt(size(Amplitudes,1)), Colour);

figure(7);
for i = 1:size(Amplitudes,1),
    plot([1:1:size(Amplitudes,2)]/Fs, Amplitudes(i,:), Colour);
    hold on;
end
axis([0.98 1.08 0 60]);
for i = 1:size(Amplitudes,1),
    ST1 = Amplitudes(i,round(0.98*Fs):round(1.06*Fs));
    for j = i+1:size(Amplitudes,1),
        ST2 = Amplitudes(j,round(0.98*Fs):round(1.06*Fs));
        Temp(i,j) = ((ST1 - mean(ST1)) * (ST2 - mean(ST2))')/(norm(ST1 - mean(ST1)) * norm(ST2 - mean(ST2)));
    end
end
disp(['Correlation is ', num2str(mean(Temp(find(Temp))))]);
figure;
subplot(2,1,1);
imagesc([1:1:size(Amplitudes,2)]/Fs - 1, [1:1:size(Amplitudes,1)], imcomplement(Amplitudes/max(max(Amplitudes))));
colormap('hot');
subplot(2,1,2);
plot([1:1:size(Amplitudes,2)]/Fs - 1, std(Amplitudes)./mean(Amplitudes), 'k');
axis tight;



disp('Finished Analysis');