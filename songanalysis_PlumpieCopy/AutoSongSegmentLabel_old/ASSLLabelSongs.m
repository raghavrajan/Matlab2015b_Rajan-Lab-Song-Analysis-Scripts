function varargout = ASSLLabelSongs(varargin)
%ASSLLABELSONGS M-file for ASSLLabelSongs.fig
%      ASSLLABELSONGS, by itself, creates a new ASSLLABELSONGS or raises the existing
%      singleton*.
%
%      H = ASSLLABELSONGS returns the handle to a new ASSLLABELSONGS or the handle to
%      the existing singleton*.
%
%      ASSLLABELSONGS('Property','Value',...) creates a new ASSLLABELSONGS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ASSLLabelSongs_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ASSLLABELSONGS('CALLBACK') and ASSLLABELSONGS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ASSLLABELSONGS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ASSLLabelSongs

% Last Modified by GUIDE v2.5 04-Jan-2014 13:32:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ASSLLabelSongs_OpeningFcn, ...
                   'gui_OutputFcn',  @ASSLLabelSongs_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ASSLLabelSongs is made visible.
function ASSLLabelSongs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for ASSLLabelSongs
handles.output = hObject;

% Initialise some variables using either default values or values that have
% been passed while calling the function (RR 03 Jan 2014)

if (nargin >= 1)
    handles.ASSLLabelSongs = varargin{1};
 
    handles.ASSLLabelSongs.FileIndex = 1;
    set(handles.SongFileNameTextLabel, 'String', ['Song File Name : ', handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, ' : #', num2str(handles.ASSLLabelSongs.FileIndex), ' of ', num2str(length(handles.ASSLLabelSongs.FileName)), ' files']);
    
    [RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);

    Time = (1:1:length(RawData))/Fs;

    [LogAmplitude] = ASSLCalculateLogAmplitudeAronovFee(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

    %    set(handles.SongFileNameText, 'String', ['Song File Name : ', handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}]);

    if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
        if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
        else
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
        end
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
    end

end

handles.ASSLLabelSongs.ZoomSpecAxisLimits = handles.ASSLLabelSongs.SpecAxisLimits;
handles.ASSLLabelSongs.ZoomAmpAxisLimits = handles.ASSLLabelSongs.AmpAxisLimits;
handles.ASSLLabelSongs.ZoomLabelAxisLimits = handles.ASSLLabelSongs.LabelAxisLimits;

handles.ASSLLabelSongs.TimeStep = str2double(get(handles.TimeStepEdit, 'String'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ASSLLabelSongs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ASSLLabelSongs_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DeleteSyllButton.
function DeleteSyllButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteSyllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.InstructionsTextLabel, 'String', 'Instructions: Click within the syllable that needs to be deleted');

SyllableChanged = 0;

axes(handles.ReviewSpecAxis);
[x, y, button] = ginput(1);
x(1) = x(1) * 1000;

SyllableStart = find(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= x(1), 1, 'last');
if (x(1) > handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart))
    msgbox('Click within a syllable');
else
    handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(SyllableStart) = [];
    handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart) = [];
    handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart) = [];
    SyllableChanged = 1;
end

if (SyllableChanged == 1)
    [RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
    Time = (1:1:length(RawData))/Fs;
    [LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

    if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
        if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
        else
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
        end
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
    end
    
    axes(handles.ReviewSpecAxis);
    axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

    axes(handles.ReviewLabelAxis);
    axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);
    
    axes(handles.ReviewAmplitudeAxis);
    axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);
end

set(handles.InstructionsTextLabel, 'String', 'Instructions:');
guidata(hObject, handles);

% --- Executes on button press in AddSyllButton.
function AddSyllButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddSyllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.InstructionsTextLabel, 'String', 'Instructions: Click within the syllable that needs to be added and type a label for the new syllable');

SyllableChanged = 0;

axes(handles.ReviewSpecAxis);
[x, y, button] = ginput(2);
x(1) = x(1) * 1000;

SyllableStart = find(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= x(1), 1, 'last');
if (x(1) <= handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart))
    msgbox('Click outside a syllable');
else
    NewThreshold = inputdlg('Enter the amplitude threshold for segmenting new syllable', 'Syllable threshold');
    NewThreshold = str2double(NewThreshold{1});
    SyllableChanged = 1;
end

if (SyllableChanged == 1)
    [RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
    Time = (1:1:length(RawData))/Fs;
    [LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);
    
    NewThresholdCrossings = Time(find(LogAmplitude < NewThreshold))*1000;
    NewSyllableStart = NewThresholdCrossings(find(NewThresholdCrossings < x(1), 1, 'last'));
    NewSyllableEnd = NewThresholdCrossings(find(NewThresholdCrossings > x(1), 1, 'first'));
    
    if (isempty(handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}))
        handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex} = char(button(2));
    else
        handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(end + 1) = char(button(2));
    end

    handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(end + 1) = NewSyllableStart;
    handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(end + 1) = NewSyllableEnd;
    
    [SortedVals, SortedIndices] = sort(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex});
    handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} = handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(SortedIndices);
    handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex} = handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SortedIndices);
    handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex} = handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(SortedIndices);
    
    if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
        if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
        else
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
        end
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
    end
    
    axes(handles.ReviewSpecAxis);
    axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

    axes(handles.ReviewLabelAxis);
    axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);
    
    axes(handles.ReviewAmplitudeAxis);
    axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);
end

set(handles.InstructionsTextLabel, 'String', 'Instructions:');
guidata(hObject, handles);

% --- Executes on button press in MergeSyllButton.
function MergeSyllButton_Callback(hObject, eventdata, handles)
% hObject    handle to MergeSyllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.InstructionsTextLabel, 'String', 'Instructions: First click on the two extreme syllables that need to be merged and then type the new syllable label');

SyllableChanged = 0;

axes(handles.ReviewSpecAxis);
[x, y, button] = ginput(3);
x(1) = x(1) * 1000;
x(2) = x(2) * 1000;

FirstSyllable = find(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= x(1), 1, 'last');
LastSyllable = find(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= x(2), 1, 'last');

if (x(1) > handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(FirstSyllable))
    msgbox('Click within a syllable');
else
    if (x(2) > handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(LastSyllable))
        msgbox('Click within a syllable');
    else
        handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(FirstSyllable) = char(button(3));
        handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(FirstSyllable) = handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(LastSyllable);
        
        handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(LastSyllable) = [];
        handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(LastSyllable) = [];
        handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(LastSyllable) = [];
        SyllableChanged = 1;
    end
end

if (SyllableChanged == 1)
    [RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
    Time = (1:1:length(RawData))/Fs;
    [LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

    if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
        if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
        else
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
        end
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
    end
    
    axes(handles.ReviewSpecAxis);
    axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

    axes(handles.ReviewLabelAxis);
    axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);
    
    axes(handles.ReviewAmplitudeAxis);
    axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);
end

set(handles.InstructionsTextLabel, 'String', 'Instructions:');
guidata(hObject, handles);

% --- Executes on button press in SplitSyllButton.
function SplitSyllButton_Callback(hObject, eventdata, handles)
% hObject    handle to SplitSyllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in EditSyllLabelButton.
function EditSyllLabelButton_Callback(hObject, eventdata, handles)
% hObject    handle to EditSyllLabelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.InstructionsTextLabel, 'String', 'Instructions: Enter the syllable labels one at a time. The syllable currently being labelled will be shown in red. If you want to go back to a different syllable, left click within the boundaries of that syllable. Type q when you have finished entering labels');

button = 1;
CurrentSyllable = find((handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} >= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(1)*1000)) & (handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(2)*1000)));
while isempty(CurrentSyllable)
    if (handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) <= 0.5)
        NextTimeButton_Callback(hObject, eventdata, handles);
    else
        PrevTimeButton_Callback(hObject, eventdata, handles);
    end
    handles = guidata(hObject);
    CurrentSyllable = find((handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} >= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(1)*1000)) & (handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(2)*1000)));
end
CurrentSyllable = CurrentSyllable(1);
ASSLReviewPlotLabels(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}, handles.ReviewLabelAxis, handles.ASSLLabelSongs.ZoomLabelAxisLimits, CurrentSyllable);

while (button ~= 113)
    if (ismac)
        [x, y, button] = ginputax(1, handles.ReviewLabelAxis);
    else
        [x, y, button] = ginput(1);
    end
        
    if (button ~= 113)
        if (button <= 3)
            x(1) = x(1) * 1000;
            SyllablesInView = find((handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} >= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(1)*1000)) & (handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(2)*1000)));
            [Val, CurrentSyllable] = min(abs(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(SyllablesInView) - x(1))); 
        	CurrentSyllable = SyllablesInView(CurrentSyllable)
            ASSLReviewPlotLabels(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}, handles.ReviewLabelAxis, handles.ASSLLabelSongs.ZoomLabelAxisLimits, CurrentSyllable);
        else
            handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(CurrentSyllable) = char(button);
            CurrentSyllable = CurrentSyllable + 1;
            SyllablesInView = find((handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} >= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(1)*1000)) & (handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= (handles.ASSLLabelSongs.ZoomSpecAxisLimits(2)*1000)));
            if (CurrentSyllable > length(handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}));
                CurrentSyllable = CurrentSyllable - 1;
            else
                if (CurrentSyllable >= SyllablesInView)
                    if (CurrentSyllable ~= length(handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}))
                        NextTimeButton_Callback(hObject, eventdata, handles);
                        handles = guidata(hObject);
                    end
                end
            end
            ASSLReviewPlotLabels(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}, handles.ReviewLabelAxis, handles.ASSLLabelSongs.ZoomLabelAxisLimits, CurrentSyllable);
        end
    end
end

ASSLReviewPlotLabels(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}, handles.ReviewLabelAxis, handles.ASSLLabelSongs.ZoomLabelAxisLimits, -1);
set(handles.InstructionsTextLabel, 'String', 'Instructions:');
guidata(hObject, handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in NextFileButton.
function NextFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ASSLLabelSongs.FileIndex = handles.ASSLLabelSongs.FileIndex + 1;
if (handles.ASSLLabelSongs.FileIndex < 1)
    handles.ASSLLabelSongs.FileIndex = 1;
end

if (handles.ASSLLabelSongs.FileIndex > length(handles.ASSLLabelSongs.FileName))
    handles.ASSLLabelSongs.FileIndex = length(handles.ASSLLabelSongs.FileName);
end

set(handles.SongFileNameTextLabel, 'String', ['Song File Name : ', handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, ' : #', num2str(handles.ASSLLabelSongs.FileIndex), ' of ', num2str(length(handles.ASSLLabelSongs.FileName)), ' files']);
[RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
Time = (1:1:length(RawData))/Fs;
[LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
    if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
    end
else
    [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
end

handles.ASSLLabelSongs.ZoomSpecAxisLimits = handles.ASSLLabelSongs.SpecAxisLimits;
handles.ASSLLabelSongs.ZoomAmpAxisLimits = handles.ASSLLabelSongs.AmpAxisLimits;
handles.ASSLLabelSongs.ZoomLabelAxisLimits = handles.ASSLLabelSongs.LabelAxisLimits;

guidata(hObject, handles);

% --- Executes on button press in PrevFileButton.
function PrevFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to PrevFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ASSLLabelSongs.FileIndex = handles.ASSLLabelSongs.FileIndex - 1;
if (handles.ASSLLabelSongs.FileIndex < 1)
    handles.ASSLLabelSongs.FileIndex = 1;
end

if (handles.ASSLLabelSongs.FileIndex > length(handles.ASSLLabelSongs.FileName))
    handles.ASSLLabelSongs.FileIndex = length(handles.ASSLLabelSongs.FileName);
end

set(handles.SongFileNameTextLabel, 'String', ['Song File Name : ', handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, ' : #', num2str(handles.ASSLLabelSongs.FileIndex), ' of ', num2str(length(handles.ASSLLabelSongs.FileName)), ' files']);
[RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
Time = (1:1:length(RawData))/Fs;
[LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
    if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
    end
else
    [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
end

handles.ASSLLabelSongs.ZoomSpecAxisLimits = handles.ASSLLabelSongs.SpecAxisLimits;
handles.ASSLLabelSongs.ZoomAmpAxisLimits = handles.ASSLLabelSongs.AmpAxisLimits;
handles.ASSLLabelSongs.ZoomLabelAxisLimits = handles.ASSLLabelSongs.LabelAxisLimits;

guidata(hObject, handles);


% --- Executes on button press in NextTimeButton.
function NextTimeButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextTimeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ((handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) - handles.ASSLLabelSongs.ZoomSpecAxisLimits(1)) > 1.1*handles.ASSLLabelSongs.TimeStep)
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.SpecAxisLimits(1) + handles.ASSLLabelSongs.TimeStep;
else
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) + 0.9*handles.ASSLLabelSongs.TimeStep;
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) + handles.ASSLLabelSongs.TimeStep;
end

if (handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) < 0)
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) = 0;
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) + handles.ASSLLabelSongs.TimeStep;
end

if (handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) > handles.ASSLLabelSongs.SpecAxisLimits(2))
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.SpecAxisLimits(2) + handles.ASSLLabelSongs.TimeStep*0.1;
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) - handles.ASSLLabelSongs.TimeStep;
end

handles.ASSLLabelSongs.ZoomAmpAxisLimits(1:2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1:2);
handles.ASSLLabelSongs.ZoomLabelAxisLimits(1:2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1:2);

axes(handles.ReviewSpecAxis);
axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

axes(handles.ReviewLabelAxis);
axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);

axes(handles.ReviewAmplitudeAxis);
axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);

guidata(hObject, handles);

% --- Executes on button press in PrevTimeButton.
function PrevTimeButton_Callback(hObject, eventdata, handles)
% hObject    handle to PrevTimeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ((handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) - handles.ASSLLabelSongs.ZoomSpecAxisLimits(1)) > 1.1*handles.ASSLLabelSongs.TimeStep)
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.SpecAxisLimits(1) + handles.ASSLLabelSongs.TimeStep;
else
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) - 0.9*handles.ASSLLabelSongs.TimeStep;
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) + handles.ASSLLabelSongs.TimeStep;
end

if (handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) < 0)
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) = 0;
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) + handles.ASSLLabelSongs.TimeStep;
end

if (handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) > handles.ASSLLabelSongs.SpecAxisLimits(2))
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) = handles.ASSLLabelSongs.SpecAxisLimits(2) + handles.ASSLLabelSongs.TimeStep*0.1;
    handles.ASSLLabelSongs.ZoomSpecAxisLimits(1) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(2) - handles.ASSLLabelSongs.TimeStep;
end


handles.ASSLLabelSongs.ZoomAmpAxisLimits(1:2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1:2);
handles.ASSLLabelSongs.ZoomLabelAxisLimits(1:2) = handles.ASSLLabelSongs.ZoomSpecAxisLimits(1:2);

axes(handles.ReviewSpecAxis);
axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

axes(handles.ReviewLabelAxis);
axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);

axes(handles.ReviewAmplitudeAxis);
axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);

guidata(hObject, handles);


function TimeStepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TimeStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeStepEdit as text
%        str2double(get(hObject,'String')) returns contents of TimeStepEdit as a double

handles.ASSLLabelSongs.TimeStep = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes on button press in DeleteMultipleSyllButton.
function DeleteMultipleSyllButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteMultipleSyllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.InstructionsTextLabel, 'String', 'Instructions: Left click within syllables that needs to be deleted and right click when done deleting');

Flag = 1;

while (Flag == 1)
    SyllableChanged = 0;
    
    axes(handles.ReviewSpecAxis);
    [x, y, button] = ginput(1);
    
    if (button == 3)
        Flag = 0;
        break;
    end
    
    x(1) = x(1) * 1000;

    SyllableStart = find(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= x(1), 1, 'last');
    if (x(1) > handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart))
        disp('Click within a syllable');
    else
        handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(SyllableStart) = [];
        handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart) = [];
        handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart) = [];
        SyllableChanged = 1;
    end

    if (SyllableChanged == 1)
        [RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
        Time = (1:1:length(RawData))/Fs;
        [LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

        if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
            if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
                [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
            else
                [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
            end
        else
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
        end

        axes(handles.ReviewSpecAxis);
        axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

        axes(handles.ReviewLabelAxis);
        axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);

        axes(handles.ReviewAmplitudeAxis);
        axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);
        guidata(hObject, handles);
    end
end

set(handles.InstructionsTextLabel, 'String', 'Instructions:');
guidata(hObject, handles);

% --- Executes on button press in AddMultipleSyllablesButton.
function AddMultipleSyllablesButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddMultipleSyllablesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Flag = 1;

set(handles.InstructionsTextLabel, 'String', 'Instructions: First click within the axes and then type a common label for all new syllables');
axes(handles.ReviewSpecAxis);
[x, y, NewLabel] = ginput(2);

NewLabel = NewLabel(2);

NewThreshold = inputdlg('Enter the amplitude threshold for segmenting new syllable', 'Syllable threshold');
NewThreshold = str2double(NewThreshold{1});

while (Flag == 1)
    set(handles.InstructionsTextLabel, 'String', 'Instructions: Left click within individual syllables that need to be added; right click when done');

    SyllableChanged = 0;

    axes(handles.ReviewSpecAxis);
    [x, y, button] = ginput(1);
    
    if (button == 3)
        Flag = 0;
        break;
    end
    
    x(1) = x(1) * 1000;

    SyllableStart = find(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= x(1), 1, 'last');
    if (x(1) <= handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SyllableStart))
        msgbox('Click outside a syllable');
    else
        SyllableChanged = 1;
    end

    if (SyllableChanged == 1)
        [RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
        Time = (1:1:length(RawData))/Fs;
        [LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

        NewThresholdCrossings = Time(find(LogAmplitude < NewThreshold))*1000;
        NewSyllableStart = NewThresholdCrossings(find(NewThresholdCrossings < x(1), 1, 'last'));
        NewSyllableEnd = NewThresholdCrossings(find(NewThresholdCrossings > x(1), 1, 'first'));

        if (isempty(handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}))
            handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex} = char(NewLabel);
        else
            handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(end + 1) = char(NewLabel);
        end

        handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(end + 1) = NewSyllableStart;
        handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(end + 1) = NewSyllableEnd;

        [SortedVals, SortedIndices] = sort(handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex});
        handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} = handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(SortedIndices);
        handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex} = handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SortedIndices);
        handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex} = handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(SortedIndices);

        if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
            if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
                [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
            else
                [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
            end
        else
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
        end

        axes(handles.ReviewSpecAxis);
        axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

        axes(handles.ReviewLabelAxis);
        axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);

        axes(handles.ReviewAmplitudeAxis);
        axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);
    end
end
    
set(handles.InstructionsTextLabel, 'String', 'Instructions:');
guidata(hObject, handles);


% --- Executes on button press in JumpFileButton.
function JumpFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to JumpFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NewFileIndex = inputdlg('Enter the file # to jump to', 'File #');
NewFileIndex = str2double(NewFileIndex{1});

handles.ASSLLabelSongs.FileIndex = NewFileIndex;
if (handles.ASSLLabelSongs.FileIndex < 1)
    handles.ASSLLabelSongs.FileIndex = 1;
end

if (handles.ASSLLabelSongs.FileIndex > length(handles.ASSLLabelSongs.FileName))
    handles.ASSLLabelSongs.FileIndex = length(handles.ASSLLabelSongs.FileName);
end

set(handles.SongFileNameTextLabel, 'String', ['Song File Name : ', handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, ' : #', num2str(handles.ASSLLabelSongs.FileIndex), ' of ', num2str(length(handles.ASSLLabelSongs.FileName)), ' files']);
[RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
Time = (1:1:length(RawData))/Fs;
[LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
    if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
    end
else
    [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
end

handles.ASSLLabelSongs.ZoomSpecAxisLimits = handles.ASSLLabelSongs.SpecAxisLimits;
handles.ASSLLabelSongs.ZoomAmpAxisLimits = handles.ASSLLabelSongs.AmpAxisLimits;
handles.ASSLLabelSongs.ZoomLabelAxisLimits = handles.ASSLLabelSongs.LabelAxisLimits;

guidata(hObject, handles);

% --- Executes on button press in MakeAllSyllTemplatesButton
function MakeAllSyllTemplatesButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteSyllsWithinLimitsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Writing note file ...');

onsets = handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex};
offsets = handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex};
labels = handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex};
threshold = handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex};
sm_win = handles.ASSLLabelSongs.FFTWinSizeSegmenting;
min_int = handles.ASSLLabelSongs.MinInt;
min_dur = handles.ASSLLabelSongs.MinDur;
save([handles.ASSLLabelSongs.NoteFileDirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, '.not.mat'], 'onsets', 'offsets', 'labels', 'threshold', 'sm_win', 'min_dur', 'min_int');
clear onsets offsets labels threshold sm_win min_int min_dur;

OutputDir = uigetdir(pwd, 'Choose the directory for the template file');

TimeStretch = [-6:2:10];
FreqStretch = 0;
Exclusions = [];

disp('Writing templates ...');

MakeAllSyllableTemplatesFromFile(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, OutputDir, 0, TimeStretch, FreqStretch, Exclusions, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});

TemplateFigure = figure;
set(gcf, 'Color', 'w', 'Position', [300 500 325 150], 'PaperPositionMode', 'auto', 'InvertHardcopy', 'off');

[RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
Time = (1:1:length(RawData))/Fs;

UniqueSyllLabels = unique(handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});

TemplateRawData = [];
for i = 1:length(UniqueSyllLabels),
    Indices = find(handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex} == UniqueSyllLabels(i));
    Onset = handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(Indices(min([3 length(Indices)]))) - 15;
    Offset = handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(Indices(min([3 length(Indices)]))) + 15;
    TempRawData = RawData(round(Onset*Fs/1000):round(Offset*Fs/1000));
    LabelTimes(i) = length(TempRawData)/5 + length(TemplateRawData);
    OnsetOffsetTimes(i,:) = [(length(TemplateRawData)/Fs + 0.015) ((length(TemplateRawData) + length(TempRawData))/Fs - 0.015)];
    TemplateRawData = [TemplateRawData; TempRawData(:)];
end

TemplateTime = (1:1:length(TemplateRawData))/Fs;

PlotSpectrogramInAxis_SongVar(TemplateRawData, TemplateTime, Fs, gca);
hold on;
text(LabelTimes/Fs, ones(size(LabelTimes))*7500, mat2cell(UniqueSyllLabels, 1, ones(1, length(UniqueSyllLabels))), 'Color', 'b', 'FontSize', 16, 'FontWeight', 'bold');
plot([OnsetOffsetTimes(:,1) OnsetOffsetTimes(:,1) OnsetOffsetTimes(:,2) OnsetOffsetTimes(:,2)]', [repmat([0 7900 7900 0], i, 1)]', 'b', 'LineWidth', 2);
set(gca, 'Visible', 'off');
set(gca, 'XTick', []);
set(gca, 'FontSize', 12);
set(gca, 'YTick', []);
set(gca, 'Position', [0.01 0.01 0.98 0.98]);
FileSep = filesep;

print(TemplateFigure, '-dpng', [OutputDir, FileSep, 'SyllableTemplates.png']);
guidata(hObject, handles);

% --- Executes on button press in DeleteSyllsWithinLimitsButton.
function DeleteSyllsWithinLimitsButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteSyllsWithinLimitsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.InstructionsTextLabel, 'String', 'Instructions: Left click to specify the left limit; right click to specify the right limit and then hit enter. Type q to quit at any time without deleting');
Flag = 1;
temp = axis;
LeftLimit = temp(1)*1000;
RightLimit = temp(2)*1000;

hold on;
LeftLimitLine = plot([LeftLimit LeftLimit], [temp(3) temp(4)], 'r--');
RightLimitLine = plot([RightLimit RightLimit], [temp(3) temp(4)], 'g--');

DeleteSylls = 0;

while (Flag == 1)
    
    axes(handles.ReviewSpecAxis);
    [x, y, button] = ginput(1);
    
    if (button == 1)
        LeftLimit = x(1) * 1000;
    end
    
    if (button == 3)
        RightLimit = x(1) * 1000;
    end

    delete(LeftLimitLine);
    delete(RightLimitLine);
    LeftLimitLine = plot([LeftLimit LeftLimit], [temp(3) temp(4)], 'r--');
    RightLimitLine = plot([RightLimit RightLimit], [temp(3) temp(4)], 'g--');
    
    if (isempty(button))
        DeleteSylls = 1;
        break;
    end
    
    if (button == 113)
        Flag = 0;
        break;
    end
end

delete(LeftLimitLine);
delete(RightLimitLine);

if (DeleteSylls == 1)

    SyllableStarts = find((handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} >= LeftLimit) & (handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex} <= RightLimit));

    handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex}(SyllableStarts) = [];
    handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}(SyllableStarts) = [];
    handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}(SyllableStarts) = [];
    SyllableChanged = 1;
end

if (SyllableChanged == 1)
    [RawData, Fs] = ASSLGetRawData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, handles.ASSLLabelSongs.SongChanNo);
    Time = (1:1:length(RawData))/Fs;
    [LogAmplitude] = ASSLCalculateLogAmplitude(RawData, Fs, Time, handles.ASSLLabelSongs.FFTWinSizeSegmenting, handles.ASSLLabelSongs.FFTWinOverlapSegmenting);

    if (isfield(handles.ASSLLabelSongs, 'SyllOnsets'))
        if (isfield(handles.ASSLLabelSongs, 'SyllLabels'))
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllLabels{handles.ASSLLabelSongs.FileIndex});
        else
            [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis, handles.ASSLLabelSongs.Threshold{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOnsets{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.SyllOffsets{handles.ASSLLabelSongs.FileIndex});
        end
    else
        [handles.ASSLLabelSongs.SpecAxisLimits, handles.ASSLLabelSongs.LabelAxisLimits, handles.ASSLLabelSongs.AmpAxisLimits] = ASSLReviewPlotData(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, Time, LogAmplitude, handles.ReviewSpecAxis, handles.ReviewAmplitudeAxis, handles.ReviewLabelAxis);
    end

    axes(handles.ReviewSpecAxis);
    axis(handles.ASSLLabelSongs.ZoomSpecAxisLimits);

    axes(handles.ReviewLabelAxis);
    axis(handles.ASSLLabelSongs.ZoomLabelAxisLimits);

    axes(handles.ReviewAmplitudeAxis);
    axis(handles.ASSLLabelSongs.ZoomAmpAxisLimits);
    guidata(hObject, handles);
end

set(handles.InstructionsTextLabel, 'String', 'Instructions:');
guidata(hObject, handles);


% --- Executes on button press in MakeSpecificSeqTemplatesButton.
function MakeSpecificSeqTemplatesButton_Callback(hObject, eventdata, handles)
% hObject    handle to MakeSpecificSeqTemplatesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OutputDir = uigetdir(pwd, 'Choose the directory for the template file');
Sequence = inputdlg('Type the sequence for which templates need to be made', 'Sequence selection');

TimeStretch = [-6:2:10];
FreqStretch = 0;

disp('Writing templates ...');

MakeSpecificSyllableTemplatesFromFile(handles.ASSLLabelSongs.DirName, handles.ASSLLabelSongs.NoteFileDirName, handles.ASSLLabelSongs.FileName{handles.ASSLLabelSongs.FileIndex}, handles.ASSLLabelSongs.FileType, OutputDir, 0, Sequence{1}, TimeStretch, FreqStretch);
guidata(hObject, handles);
