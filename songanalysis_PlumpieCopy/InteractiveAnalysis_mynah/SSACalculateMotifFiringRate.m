function [MotifFiringRate, BurstFraction] = SSACalculateMotifFiringRate(FileInfo, PreSongStartDuration, PreSongEndDuration, ContextString)

MotifFiringRate = [];
BurstFraction = [];
BurstISICriterion1 = 0.01;
BurstISICriterion2 = 0.005;

if (~isempty(FileInfo.UWSpikeTrain))
    for i = 1:length(FileInfo.UWSpikeTrain),
        MotifNoofSpikes(i) = length([FileInfo.UWSpikeTrain{i}])/(FileInfo.SongLengths(i) + PreSongStartDuration - PreSongEndDuration);
        SpikeTimes = FileInfo.UWSpikeTrain{i};
        ISIs = diff(SpikeTimes);
        
        BF1(i,1) = 0;
        for j = 1:length(SpikeTimes),
            if ((j > 1) & (j < length(SpikeTimes)))
                if ((ISIs(j-1) <= BurstISICriterion1) || (ISIs(j) <= BurstISICriterion1))
                    BF1(i,1) = BF1(i,1) + 1;
                end
            else
                if (j == 1)
                    if (ISIs(j) <= BurstISICriterion1)
                        BF1(i,1) = BF1(i,1) + 1;
                    end
                else
                    if (j == length(SpikeTimes))
                        if (ISIs(j-1) <= BurstISICriterion1)
                            BF1(i,1) = BF1(i,1) + 1;
                        end
                    end
                end
            end
        end
        BF1(i,2) = length(SpikeTimes);
        
        BF2(i,1) = 0;
        for j = 1:length(SpikeTimes),
            if ((j > 1) & (j < length(SpikeTimes)))
                if ((ISIs(j-1) <= BurstISICriterion2) || (ISIs(j) <= BurstISICriterion2))
                    BF2(i,1) = BF2(i,1) + 1;
                end
            else
                if (j == 1)
                    if (ISIs(j) <= BurstISICriterion2)
                        BF2(i,1) = BF2(i,1) + 1;
                    end
                else
                    if (j == length(SpikeTimes))
                        if (ISIs(j-1) <= BurstISICriterion2)
                            BF2(i,1) = BF2(i,1) + 1;
                        end
                    end
                end
            end
        end
        BF2(i,2) = length(SpikeTimes);
        
    end
    MotifFiringRate(1) = mean(MotifNoofSpikes);
    MotifFiringRate(2) = std(MotifNoofSpikes);
    MotifFiringRate(3) = std(MotifNoofSpikes)/sqrt(i);
end

BurstFraction(1) = BurstISICriterion1;
BurstFraction(2) = sum(BF1(:,1))/sum(BF1(:,2));
BurstFraction(3) = BurstISICriterion2;
BurstFraction(4) = sum(BF2(:,1))/sum(BF2(:,2));
disp([ContextString, ': Mean firing rate is ', num2str(MotifFiringRate(1)), ' Hz and the standard deviation is ', num2str(MotifFiringRate(2)), ' Hz and the standard error is ', num2str(MotifFiringRate(3)), ' Hz']);
disp([ContextString, ': The ISI below which two spikes are said to be in a burst is ', num2str(BurstFraction(1)), ' and fraction of spikes occuring in a burst is ', num2str(BurstFraction(2))]);
disp([ContextString, ': The ISI below which two spikes are said to be in a burst is ', num2str(BurstFraction(3)), ' and fraction of spikes occuring in a burst is ', num2str(BurstFraction(4))]);