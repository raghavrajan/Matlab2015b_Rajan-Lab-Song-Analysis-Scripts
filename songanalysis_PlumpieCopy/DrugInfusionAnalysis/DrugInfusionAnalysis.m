function varargout = DrugInfusionAnalysis(varargin)
% DRUGINFUSIONANALYSIS M-file for DrugInfusionAnalysis.fig
%      DRUGINFUSIONANALYSIS, by itself, creates a new DRUGINFUSIONANALYSIS or raises the existing
%      singleton*.
%
%      H = DRUGINFUSIONANALYSIS returns the handle to a new DRUGINFUSIONANALYSIS or the handle to
%      the existing singleton*.
%
%      DRUGINFUSIONANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRUGINFUSIONANALYSIS.M with the given input arguments.
%
%      DRUGINFUSIONANALYSIS('Property','Value',...) creates a new DRUGINFUSIONANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DrugInfusionAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DrugInfusionAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DrugInfusionAnalysis

% Last Modified by GUIDE v2.5 25-Aug-2009 16:14:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DrugInfusionAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @DrugInfusionAnalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before DrugInfusionAnalysis is made visible.
function DrugInfusionAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DrugInfusionAnalysis (see VARARGIN)

% Choose default command line output for DrugInfusionAnalysis
handles.output = hObject;

%==========================================================================
% All the variables are defined and included in handles using GUIDATA -
% Raghav 08.24.09

DIAData.BirdName = get(handles.BirdName, 'String');
DIAData.ExpDate = get(handles.ExpDate, 'String');
DIAData.FileTypes = get(handles.FileType, 'String');
DIAData.CurrentFileType = get(handles.FileType, 'Value');
DIAData.ExpStartTime = get(handles.ExpStartTime, 'String');
DIAData.ExpEndTime = get(handles.ExpEndTime, 'String');

DIAData.SpikeChannelNo = str2double(get(handles.SpikeChanNo,'String'));
DIAData.SpikeSortMethodNames = get(handles.SpikeSortMethod, 'String');
DIAData.CurrentSpikeSortMethod = get(handles.SpikeSortMethod, 'Value');
DIAData.Threshold1 = str2double(get(handles.Threshold1, 'String'));
DIAData.Threshold2 = str2double(get(handles.Threshold2, 'String'));
DIAData.TimeWindowBetweenThresholds = str2double(get(handles.TimeWindowBetweenThresholds, 'String'));

DIAData.UnitClusterNos = [];
TempUnitClusterNos = get(handles.ClusterNos, 'String');
for i = 1:length(TempUnitClusterNos),
    if (~isnan(str2double(TempUnitClusterNos(i))))
        DIAData.UnitClusterNos = [DIAData.UnitClusterNos str2double(TempUnitClusterNos(i))];
    end
end
DIAData.MaxClusters = str2double(get(handles.TotalClusterNos, 'String'));
DIAData.OutlierInclude = get(handles.OutlierInclude, 'String');
DIAData.EnergyThreshold = str2double(get(handles.EnergyThreshold, 'String'));

DIAData.SongChannelNo = str2double(get(handles.SongChanNo, 'String'));
DIAData.SongAnalysisMethods = get(handles.SongAnalysisMethods, 'String');
DIAData.CurrentSongAnalysisMethod = get(handles.SongAnalysisMethods, 'Value');
DIAData.Motif = get(handles.Motif, 'String');

DIAData.DrugName = get(handles.DrugName, 'String');
DIAData.DrugConc = get(handles.DrugConc, 'String');
DIAData.DrugStartTime = get(handles.DrugStartTime, 'String');
DIAData.DrugEndTime = get(handles.DrugEndTime, 'String');

handles.DIAData = DIAData;
%==========================================================================
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DrugInfusionAnalysis wait for user response (see UIRESUME)
% uiwait(handles.DIAMainWindow);

% --- Outputs from this function are returned to the command line.
function varargout = DrugInfusionAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function SpikeChanNo_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeChanNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SpikeChanNo as text
%        str2double(get(hObject,'String')) returns contents of SpikeChanNo as a double

handles.DIAData.SpikeChannelNo = str2double(get(hObject,'String'));
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function SpikeChanNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpikeChanNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Threshold.
function Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i = 1:length(handles.DIAData.DataFiles),
    DirectoryName = handles.DIAData.DataDirectoryName;
    FileName = handles.DIAData.DataFiles(i,:);
    ChanNo = handles.DIAData.SpikeChannelNo;
    [Data, Fs] = ReadOKrankData(DirectoryName, FileName, ChanNo);
    Data = Data * 100;
    
    WindowSize = round(handles.DIAData.TimeWindowBetweenThresholds * Fs/ 1000);
    
    switch (handles.DIAData.CurrentSpikeSortMethod)
        case 1
            msgbox('You have not selected a spike sort method');
            break;
        case 2
            [TempSpikes, TempSpikeWaveforms] = FindSpikes(Data, handles.DIAData.Threshold1, handles.DIAData.Threshold2, WindowSize, 32, 0, Fs);
        case 3
            [TempSpikes, TempSpikeWaveforms] = FindSpikesNegativeFirst(Data, handles.DIAData.Threshold1, handles.DIAData.Threshold2, WindowSize, 32, 0, Fs);
    end
    FileTime = str2double(FileName((end - 5):(end - 4))) + str2double(FileName((end - 3):(end - 2)))/60 + str2double(FileName((end - 1):end))/3600;
    
    handles.DIAData.Spikes{i} = TempSpikes;
    handles.DIAData.Waveforms{i} = TempSpikeWaveforms;
    handles.DIAData.FileTime{i} = FileTime;
    handles.DIAData.FiringRate{i} = length(TempSpikes)/(length(Data)/Fs);
end
guidata(hObject, handles);
    
% --- Executes on selection change in SpikeSortMethod.
function SpikeSortMethod_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeSortMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SpikeSortMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SpikeSortMethod
handles.DIAData.CurrentSpikeSortMethod = get(hObject, 'Value');
disp(['Switched to spikesort method : ', [handles.DIAData.SpikeSortMethodNames{handles.DIAData.CurrentSpikeSortMethod}]]);
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function SpikeSortMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpikeSortMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Threshold1_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Threshold1 as text
%        str2double(get(hObject,'String')) returns contents of Threshold1 as a double

handles.DIAData.Threshold1 = str2double(get(hObject, 'String'));
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function Threshold1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshold1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Threshold2_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Threshold2 as text
%        str2double(get(hObject,'String')) returns contents of Threshold2 as a double

handles.DIAData.Threshold2 = str2double(get(hObject, 'String'));
guidata(handles.DIAMainWindow, handles);


% --- Executes during object creation, after setting all properties.
function Threshold2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshold2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ClusterNos_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterNos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ClusterNos as text
%        str2double(get(hObject,'String')) returns contents of ClusterNos as a double

handles.DIAData.UnitClusterNos = [];
TempUnitClusterNos = get(handles.ClusterNos, 'String');
for i = 1:length(TempUnitClusterNos),
    if (~isnan(str2double(TempUnitClusterNos(i))))
        handles.DIAData.UnitClusterNos = [handles.DIAData.UnitClusterNos str2double(TempUnitClusterNos(i))];
    end
end

guidata(handles.DIAMainWindow, handles);


% --- Executes during object creation, after setting all properties.
function ClusterNos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterNos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OutlierInclude_Callback(hObject, eventdata, handles)
% hObject    handle to OutlierInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutlierInclude as text
%        str2double(get(hObject,'String')) returns contents of OutlierInclude as a double
handles.DIAData.OutlierInclude = get(hObject, 'String');
guidata(handles.DIAMainWindow, handles);


% --- Executes during object creation, after setting all properties.
function OutlierInclude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutlierInclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EnergyThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to EnergyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EnergyThreshold as text
%        str2double(get(hObject,'String')) returns contents of EnergyThreshold as a double

handles.DIAData.EnergyThreshold = str2double(get(hObject, 'String'));
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function EnergyThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EnergyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadSpikeTimeFile.
function LoadSpikeTimeFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSpikeTimeFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function BirdName_Callback(hObject, eventdata, handles)
% hObject    handle to BirdName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BirdName as text
%        str2double(get(hObject,'String')) returns contents of BirdName as a double

handles.DIAData.BirdName = get(handles.BirdName, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function BirdName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BirdName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ExpDate_Callback(hObject, eventdata, handles)
% hObject    handle to ExpDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ExpDate as text
%        str2double(get(hObject,'String')) returns contents of ExpDate as a double

handles.DIAData.ExpDate = get(handles.ExpDate, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function ExpDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExpDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ChooseDirectory.
function ChooseDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurrentDirectory = pwd;
handles.DIAData.DataDirectoryName = uigetdir('','Choose the data directory');
DirectoryLabel = findobj('Tag', 'DataDirectoryLabel');
set(DirectoryLabel,'String',handles.DIAData.DataDirectoryName);
cd(handles.DIAData.DataDirectoryName);
guidata(hObject, handles);

% --- Executes on selection change in FileType.
function FileType_Callback(hObject, eventdata, handles)
% hObject    handle to FileType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FileType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileType
handles.DIAData.CurrentFileType = get(handles.FileType, 'Value');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function FileType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TotalClusterNos_Callback(hObject, eventdata, handles)
% hObject    handle to TotalClusterNos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotalClusterNos as text
%        str2double(get(hObject,'String')) returns contents of TotalClusterNos as a double

handles.DIAData.MaxClusters = str2double(get(handles.TotalClusterNos, 'String'));
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function TotalClusterNos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotalClusterNos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotEnergy.
function PlotEnergy_Callback(hObject, eventdata, handles)
% hObject    handle to PlotEnergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlotRawData.
function PlotRawData_Callback(hObject, eventdata, handles)
% hObject    handle to PlotRawData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DIAData = handles.DIAData;
DIAPlotRawSpikeData(DIAData);

% --- Executes on button press in PlotSpikes.
function PlotSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DoTemplateMatch.
function DoTemplateMatch_Callback(hObject, eventdata, handles)
% hObject    handle to DoTemplateMatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadTemplate.
function LoadTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ChooseDirUndir.
function ChooseDirUndir_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseDirUndir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Motif_Callback(hObject, eventdata, handles)
% hObject    handle to Motif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Motif as text
%        str2double(get(hObject,'String')) returns contents of Motif as a double

handles.DIAData.Motif = get(handles.Motif, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function Motif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Motif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SongAnalysisMethods.
function SongAnalysisMethods_Callback(hObject, eventdata, handles)
% hObject    handle to SongAnalysisMethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SongAnalysisMethods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SongAnalysisMethods

handles.DIAData.CurrentSongAnalysisMethod = get(handles.SongAnalysisMethods, 'Value');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function SongAnalysisMethods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SongAnalysisMethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadNotesFiles.
function LoadNotesFiles_Callback(hObject, eventdata, handles)
% hObject    handle to LoadNotesFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function SongChanNo_Callback(hObject, eventdata, handles)
% hObject    handle to SongChanNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SongChanNo as text
%        str2double(get(hObject,'String')) returns contents of SongChanNo as a double

handles.DIAData.SongChannelNo = str2double(get(handles.SongChanNo, 'String'));
guidata(handles.DIAMainWindow, handles);


% --- Executes during object creation, after setting all properties.
function SongChanNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SongChanNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in QuitDIA.
function QuitDIA_Callback(hObject, eventdata, handles)
% hObject    handle to QuitDIA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FigureTag = findobj('Tag','DIAMainWindow');
close(FigureTag);



function DrugConc_Callback(hObject, eventdata, handles)
% hObject    handle to DrugConc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DrugConc as text
%        str2double(get(hObject,'String')) returns contents of DrugConc as
%        a double

handles.DIAData.DrugConc = [get(handles.DrugConc, 'String')];
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function DrugConc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DrugConc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DrugName_Callback(hObject, eventdata, handles)
% hObject    handle to DrugName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DrugName as text
%        str2double(get(hObject,'String')) returns contents of DrugName as a double

handles.DIAData.DrugName = get(handles.DrugName, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function DrugName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DrugName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ExpEndTime_Callback(hObject, eventdata, handles)
% hObject    handle to ExpEndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ExpEndTime as text
%        str2double(get(hObject,'String')) returns contents of ExpEndTime as a double

handles.DIAData.ExpEndTime = get(handles.ExpEndTime, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function ExpEndTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExpEndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ExpStartTime_Callback(hObject, eventdata, handles)
% hObject    handle to ExpStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ExpStartTime as text
%        str2double(get(hObject,'String')) returns contents of ExpStartTime as a double

handles.DIAData.ExpStartTime = get(handles.ExpStartTime, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function ExpStartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExpStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DrugEndTime_Callback(hObject, eventdata, handles)
% hObject    handle to DrugEndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DrugEndTime as text
%        str2double(get(hObject,'String')) returns contents of DrugEndTime as a double

handles.DIAData.DrugEndTime = get(handles.DrugEndTime, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function DrugEndTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DrugEndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DrugStartTime_Callback(hObject, eventdata, handles)
% hObject    handle to DrugStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DrugStartTime as text
%        str2double(get(hObject,'String')) returns contents of DrugStartTime as a double

handles.DIAData.DrugStartTime = get(handles.DrugStartTime, 'String');
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function DrugStartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DrugStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearData.
function ClearData_Callback(hObject, eventdata, handles)
% hObject    handle to ClearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DIAData.BirdName = '';
set(handles.BirdName, 'String', '');

DIAData.ExpDate = '';
set(handles.ExpDate, 'String', '');

DIAData.FileTypes = get(handles.FileType, 'String');
DIAData.CurrentFileType = 1;
set(handles.FileType, 'Value', 1);

DIAData.ExpStartTime = '';
set(handles.ExpStartTime, 'String', '');

DIAData.ExpEndTime = '';
set(handles.ExpEndTime, 'String', '');

DIAData.SpikeChannelNo = 0;
set(handles.SpikeChanNo,'String', '0');

DIAData.SpikeSortMethodNames = get(handles.SpikeSortMethod, 'String');
DIAData.CurrentSpikeSortMethod = 1;
set(handles.SpikeSortMethod, 'Value', 1);

DIAData.Threshold1 = str2double(get(handles.Threshold1, 'String'));
DIAData.Threshold2 = str2double(get(handles.Threshold2, 'String'));
DIAData.TimeWindowBetweenThresholds = str2double(get(handles.TimeWindowBetweenThresholds, 'String'));
DIAData.UnitClusterNos = [];
TempUnitClusterNos = get(handles.ClusterNos, 'String');
for i = 1:length(TempUnitClusterNos),
    if (~isnan(str2double(TempUnitClusterNos(i))))
        DIAData.UnitClusterNos = [DIAData.UnitClusterNos str2double(TempUnitClusterNos(i))];
    end
end
DIAData.MaxClusters = str2double(get(handles.TotalClusterNos, 'String'));
DIAData.OutlierInclude = get(handles.OutlierInclude, 'String');
DIAData.EnergyThreshold = str2double(get(handles.EnergyThreshold, 'String'));


DIAData.SongChannelNo = 0;
set(handles.SongChanNo, 'String', '0');

DIAData.SongAnalysisMethods = get(handles.SongAnalysisMethods, 'String');
DIAData.CurrentSongAnalysisMethod = 1;
set(handles.SongAnalysisMethods, 'Value', 1);

DIAData.Motif = get(handles.Motif, 'String');

DIAData.DrugName = '';
set(handles.DrugName, 'String', '');

DIAData.DrugConc = '';
set(handles.DrugConc, 'String', '');

DIAData.DrugStartTime = '';
set(handles.DrugStartTime, 'String', '');
DIAData.DrugEndTime = '';
set(handles.DrugEndTime, 'String', '');

handles.DIAData = DIAData;

guidata(hObject, handles);

function TimeWindowBetweenThresholds_Callback(hObject, eventdata, handles)
% hObject    handle to TimeWindowBetweenThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeWindowBetweenThresholds as text
%        str2double(get(hObject,'String')) returns contents of TimeWindowBetweenThresholds as a double

handles.DIAData.TimeWindowBetweenThresholds = str2double(get(handles.TimeWindowBetweenThresholds, 'String'));
guidata(handles.DIAMainWindow, handles);

% --- Executes during object creation, after setting all properties.
function TimeWindowBetweenThresholds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeWindowBetweenThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotActivityOverTime.
function PlotActivityOverTime_Callback(hObject, eventdata, handles)
% hObject    handle to PlotActivityOverTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DIAData = handles.DIAData;
ActivityOverTimeFigure = findobj('Tag', 'ActivityOverTimePlot');
if (length(ActivityOverTimeFigure) > 0)
    figure(ActivityOverTimeFigure);
else
    ActivityOverTimeFigure = figure;
    set(ActivityOverTimeFigure, 'Color', 'w');
end

for i = 1:length(DIAData.FileTime),
    FiringRates(i,1) = [DIAData.FileTime{i}];
    FiringRates(i,2) = [DIAData.FiringRate{i}];
end
plot(FiringRates(:,1), FiringRates(:,2), 'ks-');
hold on;
axis tight;
AxisLimits = axis;

DrugONHour = floor(str2double(DIAData.DrugStartTime)/10000);
DrugONMin = floor(str2double(DIAData.DrugStartTime)/100) - DrugONHour * 100;
DrugONSec = str2double(DIAData.DrugStartTime) - (DrugONHour * 10000 + DrugONMin * 100);
DrugONTime = DrugONHour + DrugONMin/60 + DrugONSec/3600;

DrugOFFHour = floor(str2double(DIAData.DrugEndTime)/10000);
DrugOFFMin = floor(str2double(DIAData.DrugEndTime)/100) - DrugOFFHour * 100;
DrugOFFSec = str2double(DIAData.DrugEndTime) - (DrugOFFHour * 10000 + DrugOFFMin * 100);
DrugOFFTime = DrugOFFHour + DrugOFFMin/60 + DrugOFFSec/3600;

plot([DrugONTime DrugONTime], [AxisLimits(3) AxisLimits(4)], 'r');
plot([DrugOFFTime DrugOFFTime], [AxisLimits(3) AxisLimits(4)], 'r');

title([DIAData.BirdName, ' ', DIAData.ExpDate, ' ', DIAData.DrugName, ' ', DIAData.DrugConc], 'FontSize', 14, 'FontWeight', 'bold');

% --- Executes on button press in PlotSingngRelatedActivity.
function PlotSingngRelatedActivity_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSingngRelatedActivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlotLumpedISIs.
function PlotLumpedISIs_Callback(hObject, eventdata, handles)
% hObject    handle to PlotLumpedISIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function TimeWindowSizeforFineISIAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to TimeWindowSizeforFineISIAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeWindowSizeforFineISIAnalysis as text
%        str2double(get(hObject,'String')) returns contents of TimeWindowSizeforFineISIAnalysis as a double


% --- Executes during object creation, after setting all properties.
function TimeWindowSizeforFineISIAnalysis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeWindowSizeforFineISIAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotSongStatistics.
function PlotSongStatistics_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSongStatistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadFiles.
function LoadFiles_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DIAData = handles.DIAData;
DataFiles = DIALoadFiles(DIAData);
handles.DIAData.DataFiles = DataFiles;
guidata(handles.DIAMainWindow, handles);

