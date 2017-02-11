function [Bout] = BoutSyllableDurations4(DirectoryName, FileList, FileType, PlotOption, ChooseBouts, min_int, min_dur, GetRidNoise, MultFactor, sm_win)

%sm_win = 0.003;

FFTWinSize = sm_win; % in sec
FFTWinOverlap = 0.9;

if (DirectoryName(end) ~= '/')
    DirectoryName(end + 1) = '/';
end

DiscardedBouts = 0;

BoutIndex = 1;

Fid = fopen(FileList, 'r');
SongFile = fgetl(Fid);

cd(DirectoryName);

while (ischar(SongFile(1)))
    Slash = find((SongFile == '\') | (SongFile == '/'));
    
    if (~isempty(Slash))
        SongFile = SongFile(Slash(end)+1:end);
    end
    disp(SongFile);
    try
        if (strfind(FileType, 'okrank'))
            [Song, Fs] = ReadOKrankData(DirectoryName, SongFile, 1);
        else
            if (strfind(FileType, 'wav'))
                [Song, Fs] = wavread(SongFile);
            else
                if (strfind(FileType, 'obs'))
                    channel_string = strcat('obs',num2str(0),'r');
                    [Song, Fs] = soundin_copy(DirectoryName, SongFile, channel_string);
    
                    % Convert to uV - 5V on the data acquisition is 32768
                    Song = Song * 5/32768;
                end
            end
        end
    catch
        continue;
    end
    if (isempty(Song))
        continue;
    end
    try
        [m_spec_deriv , m_AM, m_FM ,m_Entropy , m_amplitude , m_Freq, m_PitchGoodness , m_Pitch , Pitch_chose , Pitch_weight ]=deriv(Song, Fs);
        EntropyThreshold = gmdistribution.fit(m_Entropy, 2);
        Song = resample(Song, 44100, Fs);
        Fs = 44100;
        SongTime = (1:1:length(Song))/Fs;
        
        FFTWinSize = sm_win; % in sec
        FFTWinOverlap = 0.9;

        WinSize = round(FFTWinSize * Fs);
        WinOverlap = round(FFTWinOverlap * WinSize);

        [S, F, T, P] = spectrogram(Song, hamming(WinSize), WinOverlap, WinSize, Fs);

        Freq1 = find((F >= 860) & (F <= 8600));
        Power = log10(sum(S(Freq1,:).*conj(S(Freq1,:))));
        
        WinSize = round(sm_win/2 * Fs);
        FiltPower = filtfilt(ones(1, WinSize)/WinSize, 1, (Power));
        FiltPower = reshape(FiltPower, length(FiltPower), 1);
        Obj = gmdistribution.fit(FiltPower, 2, 'Start', 'randSample', 'Replicates', 10);
        [SoundMSD(1), Index] = max(Obj.mu);
        SoundMSD(2) = Obj.Sigma(Index);
        [NoiseMSD(1), Index] = min(Obj.mu);
        NoiseMSD(2) = Obj.Sigma(Index);

        Threshold = SoundMSD(1) - MultFactor*SoundMSD(2);
      
        FiltPower = spline(T, FiltPower, SongTime);
        [onsets, offsets] = segment_song_for_labelling(FiltPower, Fs, min_int*1000, min_dur*1000, Threshold, NoiseMSD);
        onsets = onsets/1000;
        offsets = offsets/1000;

        if (size(onsets,1) < size(onsets, 2))
            onsets = onsets';
        end
        if (size(offsets,1) < size(offsets, 2))
            offsets = offsets';
        end

        if (strfind(GetRidNoise, 'yes'))

            NoiseFreq = find(F < 500);
            NoisePower = log10(sum(S(NoiseFreq,:).*conj(S(NoiseFreq,:))));
            FiltNoisePower = filtfilt(ones(1, WinSize)/WinSize, 1, (NoisePower));
            Width = 0.02;
            XGauss = 1:1:(1 + round(2 * 4 * Width * (1/(T(2) - T(1)))));
            XGauss = XGauss - (length(XGauss) + 1)/2;
            GaussWin = (1/((Width * (1/(T(2) - T(1)))) * sqrt(2 * pi))) * exp(-(XGauss.*XGauss)/(2 * (Width * (1/(T(2) - T(1)))) * (Width * (1/(T(2) - T(1))))));
            NTC = FiltNoisePower > 0.75;
            Temp = zeros(size(NTC));
            Temp(find(NTC > 0)) = 1;
            Noise = conv(Temp, GaussWin, 'same');
            Temp2 = zeros(size(Noise));
            Temp2(find(Noise > 0)) = 1;
            Trans = conv(Temp2, [1 -1]);
            NoiseOnsets = T(find(Trans > 0));
            NoiseOffsets = T(find(Trans < 0));

            RemIndices = [];
            for NoiseNo = 1:length(NoiseOnsets),
                RemIndices = [RemIndices; find((onsets >= NoiseOnsets(NoiseNo)) & (onsets <= NoiseOffsets(NoiseNo)))];
                RemIndices = [RemIndices; find((offsets >= NoiseOnsets(NoiseNo)) & (offsets <= NoiseOffsets(NoiseNo)))];
                for (OnsetNo = 1:length(onsets)),
                    if ((onsets(OnsetNo) <= NoiseOnsets(NoiseNo)) && (offsets(OnsetNo) >= NoiseOnsets(NoiseNo)))
                        RemIndices = [RemIndices; OnsetNo];
                    end
                end
            end

            RemIndices = unique(RemIndices);
            onsets(RemIndices) = [];
            offsets(RemIndices) = [];

            disp(['Removed ', num2str(length(RemIndices)), ' syllables that were noise']);
        end
        
        Time = linspace(T(1), T(end), length(m_AM));
        NonEntropicSylls = [];
        for NoteIndex = 1:length(onsets),
            [minval, StartI] = min(abs(Time - onsets(NoteIndex)));
            [minval, EndI] = min(abs(Time - offsets(NoteIndex)));
            if ((EndI - StartI) <= 0)
                continue;
            end
            if (length(find(m_Entropy(StartI:EndI) <= (mean(EntropyThreshold.mu)))) < (EndI - StartI)/5)
                NonEntropicSylls = [NonEntropicSylls NoteIndex];
            end
        end
        if (~isempty(NonEntropicSylls))
            onsets(NonEntropicSylls) = [];
            offsets(NonEntropicSylls) = [];
        end
        
        if (strfind(ChooseBouts, 'no'))

            Temp = (onsets(2:end) - offsets(1:end-1));
            if (onsets(1) > 0.5)
                BoutOnsets = [onsets(1); onsets(find(Temp > 1) + 1)];
                if (offsets(end) > (T(end) - 0.5))
                    BoutOffsets = [offsets(find(Temp > 1)); (offsets(end) - 0.5)];
                else
                    BoutOffsets = [offsets(find(Temp > 1)); offsets(end)];
                end
            else
                BoutOnsets = [(onsets(1) + 0.5); onsets(find(Temp > 1) + 1)];
                if (offsets(end) > (T(end) - 0.5))
                    BoutOffsets = [offsets(find(Temp > 1)); (offsets(end) - 0.5)];
                else
                    BoutOffsets = [offsets(find(Temp > 1)); offsets(end)];
                end
            end
            BoutOnsets = BoutOnsets - 0.5;
            BoutOffsets = BoutOffsets + 0.5;

            Bouts = [BoutOnsets BoutOffsets];
            if (length(Bouts) > 0)
                DiscardedBouts = DiscardedBouts + length(find((Bouts(:,2) - Bouts(:,1)) <= 2));
                Bouts = Bouts(find((Bouts(:,2) - Bouts(:,1)) > 2),:);

                Time = linspace(T(1), T(end), length(m_AM));
                for BoutNo = 1:size(Bouts,1),
                    fprintf('B%i> ', BoutNo);
                    OnsetIndices = find((onsets >= Bouts(BoutNo, 1)) & (onsets <= Bouts(BoutNo, 2)));
                    Time = linspace(T(1), T(end), length(m_AM));

                    for NoteIndex = 1:length(OnsetIndices),
                        [minval, StartI] = min(abs(Time - onsets(OnsetIndices(NoteIndex))));
                        [minval, EndI] = min(abs(Time - offsets(OnsetIndices(NoteIndex))));
                        Bout.FileName{BoutIndex}{NoteIndex} = SongFile;
                        Bout.AM{BoutIndex}{NoteIndex} = mean(m_AM(StartI:EndI));
                        Bout.FM{BoutIndex}{NoteIndex} = mean(m_FM(StartI:EndI));
                        Bout.Entropy{BoutIndex}{NoteIndex} = mean(m_Entropy(StartI:EndI));
                        Bout.Amp{BoutIndex}{NoteIndex} = mean(m_amplitude(StartI:EndI));
                        Bout.Freq{BoutIndex}{NoteIndex} = mean(m_Freq(StartI:EndI));
                        Bout.PG{BoutIndex}{NoteIndex} = mean(m_PitchGoodness(StartI:EndI));
                        Bout.Pitch{BoutIndex}{NoteIndex} = mean(Pitch_chose(StartI:EndI));
                        Bout.Duration{BoutIndex}{NoteIndex} = Time(EndI) - Time(StartI);
                    end
                    Bout.SyllDurations{BoutIndex} = offsets(OnsetIndices) - onsets(OnsetIndices);
                    Bout.GapDurations{BoutIndex} = onsets(OnsetIndices(2:end)) - offsets(OnsetIndices(1:end-1));
                    Bout.BoutLength{BoutIndex} = Bouts(BoutNo,2) - Bouts(BoutNo, 1);
                    Bout.Onsets{BoutIndex} = onsets(OnsetIndices);
                    Bout.Offsets{BoutIndex} = offsets(OnsetIndices);
                    BoutIndex = BoutIndex + 1;
                    fprintf('\t');
                end
            end
        else
            PlotSpectrogram(DirectoryName, SongFile, FileType);
            zoom xon;
            Flag = 1;
            Bouts = [];
            while(Flag)
                TempMsgBox = msgbox('Zoom into the desired region and then close this box when ready');
                waitfor(TempMsgBox);
                disp('Choose bout onset and offset');
                [x1, y1, button] = ginput(2);
                Bouts(end+1,:) = [x1(1) x1(2)];
                YesNo = inputdlg('Do you want to choose more bouts? (y for yes and n for no)');
                if (isempty(strfind(YesNo{1}, 'y')))
                    Flag = 0;
                end
            end

            Time = linspace(T(1), T(end), length(m_AM));
            for BoutNo = 1:size(Bouts,1),
                fprintf('B%i ', BoutNo);
                OnsetIndices = find((onsets >= Bouts(BoutNo, 1)) & (onsets <= Bouts(BoutNo, 2)));
                Time = linspace(T(1), T(end), length(m_AM));

                for NoteIndex = 1:length(OnsetIndices),
                    [minval, StartI] = min(abs(Time - onsets(OnsetIndices(NoteIndex))));
                    [minval, EndI] = min(abs(Time - offsets(OnsetIndices(NoteIndex))));
                    Bout.FileName{BoutIndex}{NoteIndex} = SongFile;
                    Bout.AM{BoutIndex}{NoteIndex} = mean(m_AM(StartI:EndI));
                    Bout.FM{BoutIndex}{NoteIndex} = mean(m_FM(StartI:EndI));
                    Bout.Entropy{BoutIndex}{NoteIndex} = mean(m_Entropy(StartI:EndI));
                    Bout.Amp{BoutIndex}{NoteIndex} = mean(m_amplitude(StartI:EndI));
                    Bout.Freq{BoutIndex}{NoteIndex} = mean(m_Freq(StartI:EndI));
                    Bout.PG{BoutIndex}{NoteIndex} = mean(m_PitchGoodness(StartI:EndI));
                    Bout.Pitch{BoutIndex}{NoteIndex} = mean(Pitch_chose(StartI:EndI));
                    Bout.Duration{BoutIndex}{NoteIndex} = Time(EndI) - Time(StartI);
                end
                Bout.SyllDurations{BoutIndex} = offsets(OnsetIndices) - onsets(OnsetIndices);
                Bout.GapDurations{BoutIndex} = onsets(OnsetIndices(2:end)) - offsets(OnsetIndices(1:end-1));
                Bout.BoutLength{BoutIndex} = Bouts(BoutNo,2) - Bouts(BoutNo, 1);
                BoutIndex = BoutIndex + 1;
                fprintf('\t');
            end
        end
        if (strfind(PlotOption, 'on'))
            PlotSpectrogram(DirectoryName, SongFile, FileType);
            hold on;
            %plot(SongTime, (Power + (abs(NoiseMSD(1))))*1500);
            for j = 1:length(onsets),
                plot([onsets(j) onsets(j) offsets(j) offsets(j)], [0 8000 8000 0],'r');
            end
            if (~isempty(Bouts))
                for j = 1:size(Bouts,1),
                    plot([Bouts(j,1) Bouts(j,2)], [7500 7500],'b', 'LineWidth', 2);
                end
            end
    %        plot([T(1) T(end)], [((NoiseMSD(1) + ThreshMultiplier*NoiseMSD(2)) + (abs(NoiseMSD(1))))*1500 ((NoiseMSD(1) + ThreshMultiplier*NoiseMSD(2)) + (abs(NoiseMSD(1))))*1500], 'g', 'LineWidth', 2);
            %plot([T(1) T(end)], [(Threshold + (abs(NoiseMSD(1))))*1500 (Threshold + (abs(NoiseMSD(1))))*1500], 'c', 'LineWidth', 2);        
            zoom xon;
            uiwait(gcf);
        else
            fprintf('\n');
        end
    catch
        disp(['Could not analyse ', SongFile]);
    end
    clear onsets offsets Bouts BoutOnsets BoutOffsets Temp;
    SongFile = fgetl(Fid);
end
disp(['Discarded ', num2str(DiscardedBouts), ' bouts out of a total of ', num2str(BoutIndex - 1), ' bouts']);
fclose(Fid);
