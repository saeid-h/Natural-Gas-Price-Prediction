function varargout = NGPF_GUI(varargin)
% NGPF_GUI MATLAB code for NGPF_GUI.fig
%      NGPF_GUI, by itself, creates a new NGPF_GUI or raises the existing
%      singleton*.
%
%      H = NGPF_GUI returns the handle to a new NGPF_GUI or the handle to
%      the existing singleton*.
%
%      NGPF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NGPF_GUI.M with the given input arguments.
%
%      NGPF_GUI('Property','Value',...) creates a new NGPF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NGPF_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NGPF_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NGPF_GUI

% Last Modified by GUIDE v2.5 27-Apr-2016 16:14:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NGPF_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NGPF_GUI_OutputFcn, ...
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


% --- Executes just before NGPF_GUI is made visible.
function NGPF_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NGPF_GUI (see VARARGIN)

clc

% Choose default command line output for NGPF_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NGPF_GUI wait for user response (see UIRESUME)
% uiwait(handles.MainForm);

NGPF_LoadData;

evalin('base', 'clear all');
load Variables;
dates_str = datestr(Dates);
ret_NGHH = price2ret(HHSPm);
plot(Dates, HHSPm)
datetick
xlabel('Date, years')
ylabel('Natural Gas Price, $/MMBtu')
title ('Natural Gas Price History (Henry Hub)')

assignin ('base', 'ActiveModel', 'SDE');


% --- Outputs from this function are returned to the command line.
function varargout = NGPF_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in rdbSDE.
function rdbSDE_Callback(hObject, eventdata, handles)
% hObject    handle to rdbSDE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbSDE

assignin ('base', 'ActiveModel', 'SDE');
set(handles.pbAnalyze, 'Enable', 'off');



% --- Executes on button press in rdbARIMA.
function rdbARIMA_Callback(hObject, eventdata, handles)
% hObject    handle to rdbARIMA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbARIMA

assignin ('base', 'ActiveModel', 'ARIMA');
set(handles.pbAnalyze, 'Enable', 'off');



% --- Executes on button press in radbVARIMAX.
function radbVARIMAX_Callback(hObject, eventdata, handles)
% hObject    handle to radbVARIMAX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radbVARIMAX


% --- Executes on button press in rdbANN.
function rdbANN_Callback(hObject, eventdata, handles)
% hObject    handle to rdbANN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbANN

assignin ('base', 'ActiveModel', 'ANN');
set(handles.pbAnalyze, 'Enable', 'off');



% --- Executes on button press in pbAnalyze.
function pbAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to pbAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.rdbSDE, 'value')
    uiwait(NGPF_AnalysisSDE_form);
    NGPF_STOCHASTIC;
elseif get(handles.rdbARIMA, 'value')
    uiwait(NGPF_AnalysisARIMA_form);
    NGPF_ARIMA;
elseif get(handles.rdbANN, 'value')
    if strcmp(evalin('base', 'ANN_Model'), 'NAR')
        uiwait(NGPF_AnalysisNAR_form);
        NGPF_NAR;
    else
        uiwait(NGPF_AnalysisNAR_form);
        NGPF_NARX;
    end

end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function MainForm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainForm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('northeast')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ActiveModel = [];
ActiveModel = evalin('base', 'ActiveModel');

if strcmp(ActiveModel, 'SDE')
    NewForms(1) = NGPF_SDE_form;
elseif strcmp(ActiveModel, 'ARIMA')
    NewForms(2) = NGPF_ARIMA_form;
elseif strcmp(ActiveModel, 'ANN')
    NewForms(3) = NGPF_ANN_form;
end

set(handles.pbAnalyze, 'Enable', 'on');


% --- Executes on button press in pbExit.
function pbExit_Callback(hObject, eventdata, handles)
% hObject    handle to pbExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base', 'clear all');
% evalin('base', 'close all');
delete(handles.MainForm);
