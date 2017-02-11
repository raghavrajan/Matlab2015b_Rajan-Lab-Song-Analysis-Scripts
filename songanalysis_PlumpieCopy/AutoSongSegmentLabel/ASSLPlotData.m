function [SpecAxisLimits, AmpAxisLimits] = ASSLPlotData(DirectoryName, FileName, FileType, Time, LogAmplitude, SpecAxis, AmpAxis, varargin)

if (nargin > 7)
    if (~isempty(varargin{1}))
        Threshold = varargin{1};
    end
    if (nargin > 8)
        if (~isempty(varargin{2}))
            Onsets = varargin{2}/1000;
            Offsets = varargin{3}/1000;
        end
    end
    if (nargin > 10)
        if (~isempty(varargin{4}))
            Labels = varargin{4};
        end
    end
    if (nargin > 11)
        if (~isempty(varargin{5}))
            TimeRange = varargin{5};
        end
    end
end

cla(SpecAxis);
if (exist('TimeRange', 'var'))
    PlotSpectrogramInAxis(DirectoryName, FileName, FileType, SpecAxis, TimeRange);
    StartIndex = find(Time <= TimeRange(1), 1, 'last');
    EndIndex = find(Time <= TimeRange(2), 1, 'last');
    Time = Time(StartIndex:EndIndex);
    LogAmplitude = LogAmplitude(StartIndex:EndIndex);
else
    PlotSpectrogramInAxis(DirectoryName, FileName, FileType, SpecAxis);
end
hold on;
if (exist('Onsets', 'var'))
    for i = 1:length(Onsets),
        plot([Onsets(i) Onsets(i) Offsets(i) Offsets(i)], [300 7000 7000 300], 'b');
    end
end

if (exist('Labels', 'var'))
    for i = 1:length(Labels),
        text(Onsets(i), 7500, Labels(i), 'Color', 'b');
    end
end
SpecAxisLimits = [Time(1) Time(end) 300 8000];
axis(SpecAxisLimits);

cla(AmpAxis);
axes(AmpAxis);
plot(Time, LogAmplitude, 'k');
hold on;
if (exist('Threshold', 'var'))
    for i = 1:length(Threshold),
        plot([Time(1) Time(end)], [Threshold(i) Threshold(i)], 'r--');
    end
end

set(gca, 'FontSize', 10);
xlabel('Time (sec)', 'FontSize', 12);
ylabel('Amplitude (V)', 'FontSize', 12);

AmpAxisLimits = [Time(1) Time(end) min(LogAmplitude) max(LogAmplitude)];
axis(AmpAxisLimits);

if (exist('Onsets', 'var'))
    for i = 1:length(Onsets),
        plot([Onsets(i) Onsets(i) Offsets(i) Offsets(i)], [AmpAxisLimits(3) AmpAxisLimits(4) AmpAxisLimits(4) AmpAxisLimits(3)], 'b');
    end
end
