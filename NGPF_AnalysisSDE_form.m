function varargout = NGPF_AnalysisSDE_form(varargin)
% NGPF_ANALYSISSDE_FORM MATLAB code for NGPF_AnalysisSDE_form.fig
%      NGPF_ANALYSISSDE_FORM, by itself, creates a new NGPF_ANALYSISSDE_FORM or raises the existing
%      singleton*.
%
%      H = NGPF_ANALYSISSDE_FORM returns the handle to a new NGPF_ANALYSISSDE_FORM or the handle to
%      the existing singleton*.
%
%      NGPF_ANALYSISSDE_FORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NGPF_ANALYSISSDE_FORM.M with the given input arguments.
%
%      NGPF_ANALYSISSDE_FORM('Property','Value',...) creates a new NGPF_ANALYSISSDE_FORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NGPF_AnalysisSDE_form_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NGPF_AnalysisSDE_form_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NGPF_AnalysisSDE_form

% Last Modified by GUIDE v2.5 27-Apr-2016 16:50:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NGPF_AnalysisSDE_form_OpeningFcn, ...
                   'gui_OutputFcn',  @NGPF_AnalysisSDE_form_OutputFcn, ...
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


% --- Executes just before NGPF_AnalysisSDE_form is made visible.
function NGPF_AnalysisSDE_form_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NGPF_AnalysisSDE_form (see VARARGIN)

% Choose default command line output for NGPF_AnalysisSDE_form
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NGPF_AnalysisSDE_form wait for user response (see UIRESUME)
% uiwait(handles.AnalysisSDEForm);
assignin('base', 'BackTestFlag', 1);
assignin('base', 'ForecastFlag', 1);
assignin('base', 'HistogramFlag', 0);
assignin('base', 'NSteps', 12);


% --- Outputs from this function are returned to the command line.
function varargout = NGPF_AnalysisSDE_form_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chkBackTest.
function chkBackTest_Callback(hObject, eventdata, handles)
% hObject    handle to chkBackTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBackTest

if get(handles.chkBackTest, 'Value')
    assignin('base', 'BackTestFlag', 1);
else
    assignin('base', 'BackTestFlag', 0);
end



% --- Executes on button press in chkForecast.
function chkForecast_Callback(hObject, eventdata, handles)
% hObject    handle to chkForecast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkForecast

if get(handles.chkForecast, 'Value')
    assignin('base', 'ForecastFlag', 1);
    set(handles.edNStep, 'Enable', 'on')
    set(handles.chkHistogram, 'Enable', 'on')
    assignin('base', 'NSteps', str2num(get(handles.edNStep, 'String')));
    if get(handles.chkHistogram, 'Value')
        assignin('base', 'HistogramFlag', 1);
    end
else
    assignin('base', 'ForecastFlag', 0);
    set(handles.edNStep, 'Enable', 'off')
    set(handles.chkHistogram, 'Enable', 'off')
    assignin('base', 'HistogramFlag', 0);
end


function edNStep_Callback(hObject, eventdata, handles)
% hObject    handle to edNStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edNStep as text
%        str2double(get(hObject,'String')) returns contents of edNStep as a double

assignin('base', 'NSteps', str2num(get(handles.edNStep, 'String')));


% --- Executes during object creation, after setting all properties.
function edNStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edNStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.AnalysisSDEForm);


% --- Executes on button press in chkHistogram.
function chkHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to chkHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkHistogram

if get(handles.chkHistogram, 'Value')
    assignin('base', 'HistogramFlag', 1);
else
    assignin('base', 'HistogramFlag', 0);
end
