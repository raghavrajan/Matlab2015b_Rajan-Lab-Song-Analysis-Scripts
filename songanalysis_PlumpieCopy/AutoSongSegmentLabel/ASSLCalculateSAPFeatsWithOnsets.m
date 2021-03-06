function [Feats, RawFeats, FeatsFs] = ASSLCalculateSAPFeatsWithOnsets(Song, Time, Fs, Onsets, Offsets)

if (~isempty(Onsets))
    
    [m_spec_deriv , m_AM, m_FM ,m_Entropy , m_amplitude ,m_Freq, m_PitchGoodness , m_Pitch , Pitch_chose , Pitch_weight] = deriv(Song, Fs);
    Temp = load('/home/raghav/repositories/Matlab2015b_Rajan-Lab-Song-Analysis-Scripts/songanalysis_PlumpieCopy/SoundAnalysisMatlab/parameters.mat');
    % T = linspace(Time(1), Time(end), length(m_Entropy));
    T = Time(1):Temp.param.winstep/Fs:(Time(end) + 2);
    T = T(1:length(m_amplitude));
    FeatsFs.SAPFeats_Fs = 1/(T(2) - T(1));

    % Parameters P for calculating FF for yin
    % sr for sample rate
    % maxf0 for max ff
    % minf0 for min ff
    P.sr = Fs;
    P.minf0 = 350; % min ff set to 350 Hz
    
    % A dirty fix for some error I was getting - am not sure why the error
    % was coming so used a try catch routine to bypass this error for the n
    try
        FF = yin(Song, P);
        FF_T = linspace(1/Fs, length(Song)/Fs, length(FF.f0));
        FF = 2.^FF.f0 * 440;
        FeatsFs.FF_Fs = 1/(FF_T(2) - FF_T(1));
    catch
        FF = NaN;
        FeatsFs.FF_Fs = NaN;
    end
end

if (isempty(Onsets))
    Feats.Duration = []; % Duration 
    Feats.LogAmplitude = []; % Amplitude
    Feats.Entropy = []; % Entropy 
    Feats.MeanFrequency = [];
    Feats.AmplitudeModulation = [];
    Feats.PitchGoodness = [];
    Feats.FrequencyModulation = [];
    Feats.EntropyVariance = [];
    Feats.FundamentalFrequency = [];
    
    Feats.STDLogAmplitude = [];
    Feats.STDEntropy = [];
    Feats.STDMeanFrequency = [];
    Feats.STDAmplitudeModulation = [];
    Feats.STDPitchGoodness = [];
    Feats.STDFrequencyModulation = [];
    
    FeatsFs.SAPFeats_Fs = [];
    FeatsFs.FF_Fs = [];
    
    RawFeats.LogAmplitude = []; % Amplitude
    RawFeats.Entropy = []; % Entropy 
    RawFeats.MeanFrequency = [];
    RawFeats.AmplitudeModulation = [];
    RawFeats.PitchGoodness = [];
    RawFeats.FrequencyModulation = [];
    RawFeats.FundamentalFrequency = [];
    
end

for i = 1:length(Onsets),
    SyllNo = i;
    StartIndex = find(T <= Onsets(i), 1, 'last');
    if (isempty(StartIndex))
        StartIndex = 1;
    end
    
    EndIndex = find(T >= Offsets(i), 1, 'first');
    if (isempty(EndIndex))
        EndIndex = length(T);
    end
    
    Feats.Duration(SyllNo) = Offsets(i) - Onsets(i); % Duration 
    Feats.LogAmplitude(SyllNo) = mean(m_amplitude(StartIndex:EndIndex)); % Amplitude
    Feats.Entropy(SyllNo) = mean(m_Entropy(StartIndex:EndIndex)); % Entropy 
    Feats.MeanFrequency(SyllNo) = mean(m_Freq(StartIndex:EndIndex));
    Feats.AmplitudeModulation(SyllNo) = mean(m_AM(StartIndex:EndIndex));
    Feats.PitchGoodness(SyllNo) = mean(m_PitchGoodness(StartIndex:EndIndex));
    Feats.FrequencyModulation(SyllNo) = mean(m_FM(StartIndex:EndIndex));
    Feats.EntropyVariance(SyllNo) = var(m_Entropy(StartIndex:EndIndex));
    
    Feats.STDLogAmplitude(SyllNo) = std(m_amplitude(StartIndex:EndIndex)); % Amplitude
    Feats.STDEntropy(SyllNo) = std(m_Entropy(StartIndex:EndIndex)); % Entropy 
    Feats.STDMeanFrequency(SyllNo) = std(m_Freq(StartIndex:EndIndex));
    Feats.STDAmplitudeModulation(SyllNo) = std(m_AM(StartIndex:EndIndex));
    Feats.STDPitchGoodness(SyllNo) = std(m_PitchGoodness(StartIndex:EndIndex));
    Feats.STDFrequencyModulation(SyllNo) = std(m_FM(StartIndex:EndIndex));
    
    RawFeats.LogAmplitude{SyllNo} = (m_amplitude(StartIndex:EndIndex)); % Amplitude
    RawFeats.Entropy{SyllNo} = (m_Entropy(StartIndex:EndIndex)); % Entropy 
    RawFeats.MeanFrequency{SyllNo} = (m_Freq(StartIndex:EndIndex));
    RawFeats.AmplitudeModulation{SyllNo} = (m_AM(StartIndex:EndIndex));
    RawFeats.PitchGoodness{SyllNo} = (m_PitchGoodness(StartIndex:EndIndex));
    RawFeats.FrequencyModulation{SyllNo} = (m_FM(StartIndex:EndIndex));
    
    if (~isnan(FF))
        
        StartIndex = find(FF_T <= Onsets(i), 1, 'last');
        if (isempty(StartIndex))
            StartIndex = 1;
        end

        EndIndex = find(FF_T >= Offsets(i), 1, 'first');
        if (isempty(EndIndex))
            EndIndex = length(FF_T);
        end

        Feats.FundamentalFrequency(SyllNo) = mean(FF(StartIndex:EndIndex));

        RawFeats.FundamentalFrequency{SyllNo} = (FF(StartIndex:EndIndex)); % fundamental frequency
    else
        Feats.FundamentalFrequency(SyllNo) = NaN;
        RawFeats.FundamentalFrequency{SyllNo} = NaN;
    end
end        
