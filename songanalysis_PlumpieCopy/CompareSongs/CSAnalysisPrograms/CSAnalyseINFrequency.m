function [] = CSAnalyseINFrequency(CSData)

% Algorithm
% For each day and for each bout, first get the first motif syllable. The
% syllables before this first motif syllable can be counted as Total
% Syllables before first motif syllable. In addition, the number of INs in
% these syllables can be counted for #of INs.

MotifSyllArray = cellstr(char(ones(length(CSData.AllLabels), 1)*double(CSData.MotifSyllLabels)));
INArray = cellstr(char(ones(length(CSData.AllLabels), 1)*double(CSData.INLabels)));
MotifInitiationSyllArray = cellstr(char(ones(length(CSData.AllLabels), 1)*double(CSData.MotifInitiationSyllLabels)));
    
% using cellfun so that i iterate over each element of the cell array.
% To use cellfun, all of the other inputs also have to be in the form
% of cell arrays of the same length - so the previous three lines
% convert file type, data dir and output dir - common parameters for
% all of the files into cell arrays
    
[INs, Motifs, Bouts] = cellfun(@CSIdentifyINs, CSData.AllLabels', MotifSyllArray, INArray, 'UniformOutput', 0);

figure;

AllBeginningINs = [];
AllBeginningINGroups = [];

AllWithinINs = [];
AllWithinINGroups = [];
for i = 1:length(INs),
    AllBeginningINs = [AllBeginningINs; INs{i}.NumINs(Motifs{i}.BoutBeginningMotifs)'];
    AllBeginningINGroups = [AllBeginningINGroups; ones(length(Motifs{i}.BoutBeginningMotifs), 1)*i];
    
    AllWithinINs = [AllWithinINs; INs{i}.NumINs(Motifs{i}.WithinBoutMotifs)'];
    AllWithinINGroups = [AllWithinINGroups; ones(length(Motifs{i}.WithinBoutMotifs), 1)*i];
    
    MeanNumINs(1,i) = mean(INs{i}.NumINs(Motifs{i}.BoutBeginningMotifs));
    STDNumINs(1,i) = std(INs{i}.NumINs(Motifs{i}.BoutBeginningMotifs));
    disp(['Day #', num2str(i), ': Bout beginning: Mean - ', num2str(MeanNumINs(1,i)), '; STD - ', num2str(STDNumINs(1,i))]);
    
    MeanNumINs(2,i) = mean(INs{i}.NumINs(Motifs{i}.WithinBoutMotifs));
    STDNumINs(2,i) = std(INs{i}.NumINs(Motifs{i}.WithinBoutMotifs));
    disp(['Day #', num2str(i), ': Within bouts: Mean - ', num2str(MeanNumINs(2,i)), '; STD - ', num2str(STDNumINs(2,i))]);
end

BarPlotHandle = bar(MeanNumINs);
hold on;
colormap('gray');
for j = 1:size(MeanNumINs, 2),
    XVal = get(get(BarPlotHandle(j), 'children'), 'xData');
    errorbar(mean(XVal,1), MeanNumINs(:,j), STDNumINs(:,j), 'k.', 'MarkerSize', 2);
end
axis tight;
Temp = axis;
axis([(Temp(1) - 0.1) (Temp(2) + 0.1) 0 1.1*Temp(4)]);
set(gca, 'XTick', [1 2], 'XTickLabel', [{'Bout Beginning'}; {'Within Bouts'}], 'FontSize', 16);
title('Number of INs', 'FontSize', 16);
ylabel('Number of INs', 'FontSize', 16);

[p, table, stats] = anova1(AllBeginningINs, AllBeginningINGroups, 'off');
disp(['Bout beginning INs : p-value = ', num2str(p)]);
if (max(AllBeginningINGroups) > 2)
    if (p < 0.05)
        figure;
        multcompare(stats);
        title('Post-hoc comparison of bout beginning IN data');
    end
end

[p, table, stats] = anova1(AllWithinINs, AllWithinINGroups, 'off');
disp(['Within bout INs : p-value = ', num2str(p)]);
if (max(AllWithinINGroups) > 2)
    if (p < 0.05)
        figure;
        multcompare(stats);
        title('Post-hoc comparison of within bout IN data');
    end
end
disp('Finished plotting IN frequencies');
