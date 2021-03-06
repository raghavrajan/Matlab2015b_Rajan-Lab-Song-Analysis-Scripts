function [Bout] = MA_Efficient_TemplateMatch_WithBoutLens(DataDir, SongFile, FileType, MotifTemplates, Labels, ShufflePercentages, OutputDir, TemplateType, BoutOnsets, BoutOffsets, FileIndex)

PresentDir =pwd;
NumRepetitions = 25;

TimeNow = datestr(now, 'mmddyyHHMMSS');

FileSep = filesep;

if (DataDir(end) ~= FileSep)
    DataDir(end+1) = FileSep;
end

FFTWinSize = MotifTemplates{1}{1}.MotifTemplate(1).FFTWinSize;
FFTWinOverlap = MotifTemplates{1}{1}.MotifTemplate(1).FFTWinOverlap;
Normalization = MotifTemplates{1}{1}.MotifTemplate(1).Normalization;

% Check to see if analyzed files already exist: if it does then go to
% next file
% Otherwise, even if one doesn't exist, then I'll have to load up the data
% and do the matching

Flag = zeros(size(Labels));
for i = 1:length(Labels),
    OutputFileName = [SongFile, '.', Labels{i}, '.TempMatch.mat'];
    cd([OutputDir, Labels{i}]);
    if (exist(OutputFileName, 'file'))
        Flag(i) = 1;
    end
end

if (sum(Flag) == length(Labels)) % Means all the template files exist
    return; 
end

[ActualSong, Fs] = MA_ReadSongFile(DataDir, SongFile, FileType);

if (isempty(ActualSong))
    return;
end

if (isempty(BoutOnsets))
    return;
end
try
    SongTime = (1:1:length(ActualSong))/Fs;

    for BoutNo = 1:length(BoutOnsets),
        Song = ActualSong(round(BoutOnsets(BoutNo) * Fs/1000):round(BoutOffsets(BoutNo) * Fs/1000));
        
        if (strfind(TemplateType, 'Spectrogram'))

            [P, F, S1, T] = CalculateMultiTaperSpectrogram(Song, Fs, FFTWinSize, FFTWinOverlap, 1.5);

            Freq1 = find((F >= 860) & (F <= 8600));
            S = log10(abs(S1(Freq1,:)));
        else
            [m_spec_deriv , m_AM, m_FM ,m_Entropy , m_amplitude ,m_Freq, m_PitchGoodness , m_Pitch , Pitch_chose , Pitch_weight] = deriv(Song, Fs);

            SAPFeatures(1,:) = m_AM(:)';
            SAPFeatures(2,:) = m_FM(:)';
            SAPFeatures(3,:) = m_Entropy(:)';
            SAPFeatures(4,:) = m_amplitude(:)';
            SAPFeatures(5,:) = m_Freq(:)';
            SAPFeatures(6,:) = m_PitchGoodness(:)';

            S = SAPFeatures;
            T = linspace(SongTime(1), SongTime(end), size(S, 2));
        end

        for TemplateIndex = 1:length(MotifTemplates),
            MotifTemplate = MotifTemplates{TemplateIndex}{min([3, length(MotifTemplates{TemplateIndex})])};
            for i = 1:length(MotifTemplate.MotifTemplate),
                WMotif = MotifTemplate.MotifTemplate(i).MotifTemplate;
                if (Normalization == 1)
                    WinMean = zeros((size(S,2) - size(WMotif,2) + 1), 1);
                    WinSTD = zeros((size(S,2) - size(WMotif,2) + 1), 1);

                    TempMeanSTD = CalculateMeanSTDforSpectralMatch(S(1:size(S,1)*size(S,2)), size(WMotif,1)*size(WMotif,2), (size(S,2) - size(WMotif,2) + 1), size(WMotif,1));

                    WinMean = TempMeanSTD(1:length(TempMeanSTD)/2);
                    WinSTD = TempMeanSTD((length(TempMeanSTD)/2 + 1):end);
                    [Match] = CalTemplateMatch(WMotif, S, WinMean, WinSTD);
                else
                    if (Normalization == 2)
                        WinMedian = zeros((size(S,2) - size(WMotif,2) + 1), 1);
                        WinMAD = zeros((size(S,2) - size(WMotif,2) + 1), 1);

                        for ColNo = 1:(size(S,2) - size(WMotif, 2) + 1),
                            StartIndex = ((ColNo - 1)*size(WMotif,1)) + 1;
                            WinIndices = StartIndex:1:(StartIndex + size(WMotif,1)*size(WMotif,2) - 1);
                            WinMedian(ColNo) = median(S(WinIndices));
                            WinMAD(ColNo) = mad(S(WinIndices));
                        end
        %                TempMedianMAD = CalculateMedianMADforSpectralMatch(S(1:size(S,1)*size(S,2)), size(WMotif,1)*size(WMotif,2), (size(S,2) - size(WMotif,2) + 1), size(WMotif,1));

        %                WinMedian = TempMedianMAD(1:length(TempMedianMAD)/2);
        %                WinMAD = TempMedianMAD((length(TempMedianMAD)/2 + 1):end);
                        [Match] = CalTemplateMatch(WMotif, S, WinMedian, WinMAD);
                    else
                        [Match] = CalTemplateMatchWithoutNormalization(WMotif, S);
                    end
                end

                Match = Match*size(WMotif,1)*size(WMotif,2);
                Bout{TemplateIndex}{BoutNo}.BoutSeqMatch{i} = Match;
            end
            Bout{TemplateIndex}{BoutNo}.T = T;

            clear Match;
            for MatchNo = 1:length(Bout{TemplateIndex}{BoutNo}.BoutSeqMatch),
                Match(MatchNo,:) = Bout{TemplateIndex}{BoutNo}.BoutSeqMatch{MatchNo}(1:length(Bout{TemplateIndex}{BoutNo}.BoutSeqMatch{end}));
            end
            Bout{TemplateIndex}{BoutNo}.MeanBoutSeqMatch = mean(Match,1);
            Bout{TemplateIndex}{BoutNo}.MedianBoutSeqMatch = median(Match,1);
            Bout{TemplateIndex}{BoutNo}.MinBoutSeqMatch = min(Match,[], 1);
            
            Match2 = max(Match, [], 1) - mean(Match); % Trying to maximise the difference between noise and syllable matches
            Match = max(Match, [], 1);
            Bout{TemplateIndex}{BoutNo}.MaxBoutSeqMatch = Match;
            Bout{TemplateIndex}{BoutNo}.MaxBoutSeqMatchMeanSubtracted = Match2;
            
            clear Match;
            [MaxVal, MaxInd] = max(Bout{TemplateIndex}{BoutNo}.MaxBoutSeqMatch);
            Bout{TemplateIndex}{BoutNo}.MaxBoutSeqMatchVal = [Bout{TemplateIndex}{BoutNo}.T(MaxInd) MaxVal];
            Bout{TemplateIndex}{BoutNo}.FileName = SongFile;
            Bout{TemplateIndex}{BoutNo}.FileLength = (BoutOffsets(BoutNo) - BoutOnsets(BoutNo))/1000;
            Bout{TemplateIndex}{BoutNo}.BoutOnset = BoutOnsets(BoutNo);
            Bout{TemplateIndex}{BoutNo}.BoutOffset = BoutOffsets(BoutNo);
            Bout{TemplateIndex}{BoutNo}.BoutSeqMatch = [];
            
            % Now to do the shuffle matches (actually won't do it now, will
            % think about it for later
            
        end
        
        % Now do the shuffled matching
        if ((BoutNo == 1) && (FileIndex <= 40))
            for ShufflePercentageIndex = 1:length(ShufflePercentages),
                ShufflePercentage = ShufflePercentages(ShufflePercentageIndex);
                for Repetition = 1:NumRepetitions,
                    TempS = zeros(size(S));
                    RandomColIndices = randperm(size(S,2));
                    for j = 1:length(RandomColIndices),
                        if (j <= round(ShufflePercentage*length(RandomColIndices)/100))
                            RandomIndices = randperm(size(S,1));
                            TempS(:,RandomColIndices(j)) = S(RandomIndices,RandomColIndices(j));
                        else
                            TempS(:,RandomColIndices(j)) = S(:,RandomColIndices(j));
                        end
                    end

                    for TemplateIndex = 1:length(MotifTemplates),
                        MotifTemplate = MotifTemplates{TemplateIndex}{min([3, length(MotifTemplates{TemplateIndex})])};
                        for i = 1:length(MotifTemplate.MotifTemplate),
                            WMotif1 = MotifTemplate.MotifTemplate(i).MotifTemplate;
                            if (Normalization == 1)
                                TempMeanSTD = CalculateMeanSTDforSpectralMatch(TempS(1:size(S,1)*size(S,2)), size(WMotif1,1)*size(WMotif1,2), (size(S,2) - size(WMotif1,2) + 1), size(WMotif1,1));

                                WinMean = TempMeanSTD(1:length(TempMeanSTD)/2);
                                WinSTD = TempMeanSTD((length(TempMeanSTD)/2 + 1):end);

                                [Match] = CalTemplateMatch(WMotif1, TempS, WinMean, WinSTD);
                            else
                                if (Normalization == 2)
                                    WinMedian = zeros((size(S,2) - size(WMotif,2) + 1), 1);
                                    WinMAD = zeros((size(S,2) - size(WMotif,2) + 1), 1);

                                    for ColNo = 1:(size(S,2) - size(WMotif, 2) + 1),
                                        StartIndex = ((ColNo - 1)*size(WMotif,1)) + 1;
                                        WinIndices = StartIndex:1:(StartIndex + size(WMotif,1)*size(WMotif,2) - 1);
                                        WinMedian(ColNo) = median(S(WinIndices));
                                        WinMAD(ColNo) = std(S(WinIndices));
                                    end
                                    [Match] = CalTemplateMatch(WMotif, S, WinMedian, WinMAD);
                                else
                                    [Match] = CalTemplateMatchWithoutNormalization(WMotif1, TempS);
                                end
                            end
                            Match = Match*size(WMotif1,1)*size(WMotif1,2);
                            ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.BoutSeqMatch{i} = Match;
                        end
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.T = T;

                        clear Match;
                        for MatchNo = 1:length(ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.BoutSeqMatch),
                            Match(MatchNo,:) = ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.BoutSeqMatch{MatchNo}(1:length(ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.BoutSeqMatch{end}));
                        end
                        Match = max(Match);
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.MaxBoutSeqMatch = Match;
                        clear Match;
                        [MaxVal, MaxInd] = max(ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.MaxBoutSeqMatch);
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.MaxBoutSeqMatchVal = [ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.T(MaxInd) MaxVal];
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.FileName = SongFile;
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.FileLength = (BoutOffsets(1) - BoutOnsets(1))/1000;
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.BoutOnset = BoutOnsets(1);
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.BoutOffset = BoutOffsets(1);
                        ShuffleBout{ShufflePercentageIndex}{Repetition}{TemplateIndex}{BoutNo}.BoutSeqMatch = [];

                    end
                end
            end
        end
    end
catch
   disp(['Could not analyse ', SongFile]);
end

% Now I'm going to compare all syllable matches and subtract the mean of
% all OTHER syllable matches from each individual match - to try and maximise the
% differences between files. 

for BoutNo = 1:length(BoutOnsets),
    clear MinLen;
    for i = 1:length(MotifTemplates),
        MinLen(i) = length(Bout{i}{BoutNo}.MaxBoutSeqMatch);
    end
    MinLen = min(MinLen);
    
    clear Match;
    for i = 1:length(MotifTemplates),
        Match(i,:) = Bout{i}{BoutNo}.MaxBoutSeqMatch(1:MinLen);
    end
    
    for i = 1:length(MotifTemplates),
        Bout{i}{BoutNo}.MaxBoutSeqMatchAcrossSyll = Bout{i}{BoutNo}.MaxBoutSeqMatch(1:MinLen) - mean(Match(setdiff((1:1:size(Match,1)), i),:),1);
    end
end

TempBout = Bout;

for i = 1:length(Labels),
    OutputFileName = [SongFile, '.', Labels{i}, '.TempMatch.mat'];
    cd([OutputDir, Labels{i}]);
    Bout = TempBout{i};
    save(OutputFileName, 'Bout');
    
    for j = 1:length(ShufflePercentages),
        for k = 1:NumRepetitions,
            Bout = ShuffleBout{j}{k}{i};
            cd(fullfile(OutputDir, 'ShuffledSongComparisons'));
            OutputFileName = [SongFile, '.', Labels{i}, '.', num2str(ShufflePercentages(j)), '%.', num2str(k), '.TempMatch.mat'];
            save(OutputFileName, 'Bout');
        end
    end
end

cd(PresentDir);
