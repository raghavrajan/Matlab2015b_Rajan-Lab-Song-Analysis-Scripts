function [Edges, DirUWSpikeTrain, DirWSpikeTrain, DirSpikeRaster, DirSongSpikeWaveforms, DirPST, UnDirUWSpikeTrain, UnDirWSpikeTrain, UnDirSpikeRaster, UnDirSongSpikeWaveforms, UnDirPST] = SSAWarpSpikes(DirFileInfo, UnDirFileInfo, PreSongStartDuration, PreSongEndDuration, MedianMotif, BinSize)

PreSongStartDuration = PreSongStartDuration/1000;
PreSongEndDuration = PreSongEndDuration/1000;
BinSize = BinSize/1000;

Edges = -PreSongStartDuration:BinSize:(MedianMotif.Length - PreSongEndDuration);

TrialIndex = 1;

DirUWSpikeTrain = [];
DirWSpikeTrain = [];
DirSpikeRaster = [];
DirSongSpikeWaveforms = [];
DirPST = [];

if (~isempty(DirFileInfo))
    for i = 1:size(DirFileInfo.Syllables.Start,1),
        clear SpikeTimeIndices SpikeTimes SpikeAmplitudes;
        SpikeTimeIndices = find((DirFileInfo.SpikeData.Times{DirFileInfo.Syllables.Index(i)} >= (DirFileInfo.Syllables.Start(i,1) - PreSongStartDuration)) & (DirFileInfo.SpikeData.Times{DirFileInfo.Syllables.Index(i)} <= (DirFileInfo.Syllables.End(i, end) - PreSongEndDuration)));
        SpikeTimes = DirFileInfo.SpikeData.Times{DirFileInfo.Syllables.Index(i)}(SpikeTimeIndices);
        SpikeAmplitudes = DirFileInfo.SpikeData.Amplitudes{DirFileInfo.Syllables.Index(i)}(SpikeTimeIndices);
        DirSongSpikeWaveforms = [DirSongSpikeWaveforms; DirFileInfo.SpikeData.Waveforms{DirFileInfo.Syllables.Index(i)}(SpikeTimeIndices,:)];
        DirUWSpikeTrain{i} = SpikeTimes - DirFileInfo.Syllables.Start(i,1);
        clear Indices;
        WSpikeTrain = [];
        Indices = find(SpikeTimes <= DirFileInfo.Syllables.Start(i,1));
        WSpikeTrain(((end + 1):(end + length(Indices))),:) = SpikeTimes(Indices) - DirFileInfo.Syllables.Start(i,1);
        for j = 1:size(DirFileInfo.Syllables.Start, 2),
            clear Indices;
            Indices = find((SpikeTimes > DirFileInfo.Syllables.Start(i,j)) & (SpikeTimes <= DirFileInfo.Syllables.End(i,j)));
            if (~isempty(Indices));
                WSpikeTrain(((end + 1):(end + length(Indices))),:) = MedianMotif.SyllableStartings(j) + ((SpikeTimes(Indices) - DirFileInfo.Syllables.Start(i,j))) * (MedianMotif.SyllableLengths(j)/DirFileInfo.Syllables.Length(i,j));
            end
            
            if (j ~= size(DirFileInfo.Syllables.Start, 2))
                clear Indices;
                Indices = find((SpikeTimes > DirFileInfo.Gaps.Start(i,j)) & (SpikeTimes <= DirFileInfo.Gaps.End(i,j)));
                if (~isempty(Indices))
                    WSpikeTrain(((end + 1):(end + length(Indices))),:) = MedianMotif.GapStartings(j) + ((SpikeTimes(Indices) - DirFileInfo.Gaps.Start(i,j))) * (MedianMotif.GapLengths(j)/DirFileInfo.Gaps.Length(i,j));
                end
            end
        end
        if (PreSongEndDuration < 0)
            Indices = find(SpikeTimes > DirFileInfo.Syllables.End(i,end));
            WSpikeTrain(((end + 1):(end + length(Indices))),:) = SpikeTimes(Indices) - DirFileInfo.Syllables.Start(i,1);
        end
        DirWSpikeTrain{i} = WSpikeTrain;
        DirSpikeRaster = [DirSpikeRaster; [WSpikeTrain (ones(length(WSpikeTrain),1) * TrialIndex) SpikeAmplitudes]];
        if (~isempty(DirWSpikeTrain{i}))
            DirPST(i,:) = histc(DirWSpikeTrain{i}, Edges);
        else
            DirPST(i,:) = zeros(1, length(Edges));
        end
        TrialIndex = TrialIndex + 1;
    end
   
end
DirPST = DirPST/BinSize;

        
UnDirUWSpikeTrain = [];
UnDirWSpikeTrain = [];
UnDirSpikeRaster = [];
UnDirSongSpikeWaveforms = [];
UnDirPST = [];

TrialIndex = 1;
if (~isempty(UnDirFileInfo))
    for i = 1:size(UnDirFileInfo.Syllables.Start,1),
        clear SpikeTimeIndices SpikeTimes SpikeAmplitudes;
        SpikeTimeIndices = find((UnDirFileInfo.SpikeData.Times{UnDirFileInfo.Syllables.Index(i)} >= (UnDirFileInfo.Syllables.Start(i,1) - PreSongStartDuration)) & (UnDirFileInfo.SpikeData.Times{UnDirFileInfo.Syllables.Index(i)} <= (UnDirFileInfo.Syllables.End(i, end) - PreSongEndDuration)));
        SpikeTimes = UnDirFileInfo.SpikeData.Times{UnDirFileInfo.Syllables.Index(i)}(SpikeTimeIndices);
        SpikeAmplitudes = UnDirFileInfo.SpikeData.Amplitudes{UnDirFileInfo.Syllables.Index(i)}(SpikeTimeIndices);
        UnDirSongSpikeWaveforms = [UnDirSongSpikeWaveforms; UnDirFileInfo.SpikeData.Waveforms{UnDirFileInfo.Syllables.Index(i)}(SpikeTimeIndices,:)];
        UnDirUWSpikeTrain{i} = SpikeTimes - UnDirFileInfo.Syllables.Start(i,1);
        
        clear Indices;
        WSpikeTrain = [];
        Indices = find(SpikeTimes <= UnDirFileInfo.Syllables.Start(i,1));
        WSpikeTrain(((end + 1):(end + length(Indices))),:) = SpikeTimes(Indices) - UnDirFileInfo.Syllables.Start(i,1);
        for j = 1:size(UnDirFileInfo.Syllables.Start, 2),
            clear Indices;
            Indices = find((SpikeTimes > UnDirFileInfo.Syllables.Start(i,j)) & (SpikeTimes <= UnDirFileInfo.Syllables.End(i,j)));
            if (~isempty(Indices))
                WSpikeTrain(((end + 1):(end + length(Indices))),:) = MedianMotif.SyllableStartings(j) + ((SpikeTimes(Indices) - UnDirFileInfo.Syllables.Start(i,j))) * (MedianMotif.SyllableLengths(j)/UnDirFileInfo.Syllables.Length(i,j));
            end
            
            if (j ~= size(UnDirFileInfo.Syllables.Start, 2))
                clear Indices;
                Indices = find((SpikeTimes > UnDirFileInfo.Gaps.Start(i,j)) & (SpikeTimes <= UnDirFileInfo.Gaps.End(i,j)));
                if (~isempty(Indices))
                    WSpikeTrain(((end + 1):(end + length(Indices))),:) = MedianMotif.GapStartings(j) + ((SpikeTimes(Indices) - UnDirFileInfo.Gaps.Start(i,j))) * (MedianMotif.GapLengths(j)/UnDirFileInfo.Gaps.Length(i,j));
                end
            end
        end
        if (PreSongEndDuration < 0)
            Indices = find(SpikeTimes > UnDirFileInfo.Syllables.End(i,end));
            if (~isempty(Indices))
                WSpikeTrain(((end + 1):(end + length(Indices))),:) = SpikeTimes(Indices) - UnDirFileInfo.Syllables.Start(i,1);
            end
        end
        
        UnDirWSpikeTrain{i} = WSpikeTrain;
        UnDirSpikeRaster = [UnDirSpikeRaster; [WSpikeTrain (ones(length(WSpikeTrain),1) * TrialIndex) SpikeAmplitudes]];
        if (~isempty(UnDirWSpikeTrain{i}))
            UnDirPST(i,:) = histc(UnDirWSpikeTrain{i}, Edges);
        else
            UnDirPST(i,:) = zeros(1, length(Edges));
        end
        TrialIndex = TrialIndex + 1;
    end
end        
UnDirPST = UnDirPST/BinSize;
disp('Warped spikes to the median motif');
