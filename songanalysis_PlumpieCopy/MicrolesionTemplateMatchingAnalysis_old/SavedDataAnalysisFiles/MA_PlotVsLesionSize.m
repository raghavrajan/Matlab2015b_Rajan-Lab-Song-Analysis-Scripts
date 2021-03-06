function [Dir_r, Dir_p, UnDir_r, UnDir_p] = MA_PlotVsLesionSize(PercentTotalHVCremaining, DirMedians, UnDirMedians, YLabelString, OutputDir, LegendLocationString, FileNameString, TitleString, varargin)

if (nargin > 8)
    PlotYesNo = varargin{1};
else
    PlotYesNo = 1;
end

if (PlotYesNo == 1)
    RatioFigure = figure;
    set(gcf, 'Color', 'w');
    plot([PercentTotalHVCremaining], DirMedians(:,2)./DirMedians(:,1), 'ro', 'MarkerSize', 7, 'MarkerFaceColor', 'r');

    hold on;
    plot([PercentTotalHVCremaining], UnDirMedians(:,2)./UnDirMedians(:,1), 'bo', 'MarkerSize', 7, 'MarkerFaceColor', 'b');
end

[Dir_r, Dir_p] = corrcoef([PercentTotalHVCremaining], DirMedians(:,2)./DirMedians(:,1));
[UnDir_r, UnDir_p] = corrcoef([PercentTotalHVCremaining], UnDirMedians(:,2)./UnDirMedians(:,1));

if (PlotYesNo == 1)
    PlotAxis = [0 (1.05*max([PercentTotalHVCremaining])) (0.9*min([(DirMedians(:,2)./DirMedians(:,1)); (UnDirMedians(:,2)./UnDirMedians(:,1))])) (1.15*max([(DirMedians(:,2)./DirMedians(:,1)); (UnDirMedians(:,2)./UnDirMedians(:,1))]))];

    SetLabelsForFigure(RatioFigure, 'YLabel', YLabelString, 'XLabel', 'Percent HVC remaining', 'LineX', '1', 'Legend', 'Directed Undirected', LegendLocationString, 'Axis', num2str(PlotAxis));
    SetLabelsForFigure(RatioFigure, 'Text', ['Dir: r=', num2str(Dir_r(1,2)), '; p=', num2str(Dir_p(1,2))], [num2str(PlotAxis(2)/2), ' ', num2str(0.95*PlotAxis(4))], 'Text', ['Undir: r=', num2str(UnDir_r(1,2)), '; p=', num2str(UnDir_p(1,2))], [num2str(PlotAxis(2)/2), ' ', num2str(0.85*PlotAxis(4))]);
    saveas(RatioFigure, [OutputDir, TitleString, '.', FileNameString, '.PostPreRatios.png'], 'png');
end