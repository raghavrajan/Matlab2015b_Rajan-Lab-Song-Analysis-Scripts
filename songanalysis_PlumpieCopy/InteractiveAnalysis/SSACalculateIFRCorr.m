function [Correlation, Temp] = SSACalculateIFRCorr(SpikeTrain, MedianMotif, PreSongStartDuration, PreSongEndDuration, Resolution, ContextString)

Time = -PreSongStartDuration:Resolution:(MedianMotif.Length - PreSongEndDuration);

IFR = zeros(length(SpikeTrain),length(Time));

for i = 1:length(SpikeTrain),
    STLen(i) = length(SpikeTrain{i});
end

Indices = find(STLen > 0);
Index = 1;
for i = Indices,
    if ((SpikeTrain{i}(1) ~= -PreSongStartDuration) && (SpikeTrain{i}(end) ~= (MedianMotif.Length - PreSongEndDuration)))
        SpikeTimes = [-PreSongStartDuration; [(SpikeTrain{i})]; (MedianMotif.Length- PreSongEndDuration)];
        SpikeTimeIndices = [0; round(([SpikeTrain{i}] + PreSongStartDuration)/Resolution); length(Time)];
    else
        if (SpikeTrain{i}(1) == -PreSongStartDuration)
            SpikeTimes = [[(SpikeTrain{i})]; (MedianMotif.Length- PreSongEndDuration)];
            SpikeTimeIndices = [round(([SpikeTrain{i}] + PreSongStartDuration)/Resolution); length(Time)];
        else
            if (SpikeTrain{i}(end) == (MedianMotif.Length - PreSongEndDuration))
                SpikeTimes = [-PreSongStartDuration; [(SpikeTrain{i})]];
                SpikeTimeIndices = [0; round(([SpikeTrain{i}] + PreSongStartDuration)/Resolution)];
            else
                SpikeTimes = [-PreSongStartDuration; [(SpikeTrain{i})]; (MedianMotif.Length- PreSongEndDuration)];
                SpikeTimeIndices = [0; round(([SpikeTrain{i}] + PreSongStartDuration)/Resolution); length(Time)];
            end
        end
    end
        
    for j = 2:length(SpikeTimeIndices),
        IFR(Index,((SpikeTimeIndices(j-1) + 1):SpikeTimeIndices(j))) = 1/(abs(SpikeTimes(j) - SpikeTimes(j-1)));
    end
    Index = Index + 1;
end

Correlation = 0;
for i = 1:size(IFR,1),
    for j = (i+1):size(IFR,1),
        Temp(i,j) = (((IFR(i,:) - mean(IFR(i,:))) * (IFR(j,:)' - mean(IFR(j,:))))/(norm(IFR(i,:) - mean(IFR(i,:))) * norm(IFR(j,:) - mean(IFR(j,:)))));
        Correlation = Correlation + (((IFR(i,:) - mean(IFR(i,:))) * (IFR(j,:)' - mean(IFR(j,:))))/(norm(IFR(i,:) - mean(IFR(i,:))) * norm(IFR(j,:) - mean(IFR(j,:)))));
    end
end

Correlation = (Correlation * 2)/(size(IFR,1) * (size(IFR,1) - 1));

disp([ContextString, ': Resolution is ', num2str(Resolution*1000), ' ms and the IFR Correlation = ',num2str(mean(Temp(find(Temp)))), ' +/- ', num2str(std(Temp(find(Temp))))]);