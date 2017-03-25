function varargout = NGPF_ARIMA_form(varargin)
% NGPF_ARIMA_FORM MATLAB code for NGPF_ARIMA_form.fig
%      NGPF_ARIMA_FORM, by itself, creates a new NGPF_ARIMA_FORM or raises the existing
%      singleton*.
%
%      H = NGPF_ARIMA_FORM returns the handle to a new NGPF_ARIMA_FORM or the handle to
%      the existing singleton*.
%
%      NGPF_ARIMA_FORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NGPF_ARIMA_FORM.M with the given input arguments.
%
%      NGPF_ARIMA_FORM('Property','Value',...) creates a new NGPF_ARIMA_FORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NGPF_ARIMA_form_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NGPF_ARIMA_form_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NGPF_ARIMA_form

% Last Modified by GUIDE v2.5 26-Apr-2016 22:21:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NGPF_ARIMA_form_OpeningFcn, ...
                   'gui_OutputFcn',  @NGPF_ARIMA_form_OutputFcn, ...
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


% --- Executes just before NGPF_ARIMA_form is made visible.
function NGPF_ARIMA_form_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NGPF_ARIMA_form (see VARARGIN)

% Choose default command line output for NGPF_ARIMA_form
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NGPF_ARIMA_form wait for user response (see UIRESUME)
% uiwait(handles.ARIMAForm);


% --- Outputs from this function are returned to the command line.
function varargout = NGPF_ARIMA_form_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


AR = str2num(get(handles.edAR, 'String'));
MA = str2num(get(handles.edMA, 'String'));
D = str2num(get(handles.edD, 'String'));

if get(handles.chkLags, 'Value')
    AR = 1:AR;
    MA = 1:MA;
end

if get(handles.chkGARCH, 'Value')
    IsGARCH = 1;
    P = str2num(get(handles.edARCH, 'String'));
    Q = str2num(get(handles.edGARCH, 'String'));
else
    IsGARCH = 0;
    P = [];
    Q = [];
end

assignin ('base', 'ARLags', AR);
assignin ('base', 'MALags', MA);
assignin ('base', 'D', D);
assignin ('base', 'IsGARCH', IsGARCH);
assignin ('base', 'P', P);
assignin ('base', 'Q', Q);


delete(handles.ARIMAForm);



function edAR_Callback(hObject, eventdata, handles)
% hObject    handle to edAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edAR as text
%        str2double(get(hObject,'String')) returns contents of edAR as a double


% --- Executes during object creation, after setting all properties.
function edAR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edD_Callback(hObject, eventdata, handles)
% hObject    handle to edD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edD as text
%        str2double(get(hObject,'String')) returns contents of edD as a double


% --- Executes during object creation, after setting all properties.
function edD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edMA_Callback(hObject, eventdata, handles)
% hObject    handle to edMA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edMA as text
%        str2double(get(hObject,'String')) returns contents of edMA as a double


% --- Executes during object creation, after setting all properties.
function edMA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkLags.
function chkLags_Callback(hObject, eventdata, handles)
% hObject    handle to chkLags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkLags


% --- Executes on button press in chkGARCH.
function chkGARCH_Callback(hObject, eventdata, handles)
% hObject    handle to chkGARCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkGARCH

if get(handles.chkGARCH, 'Value')
    set(handles.edARCH, 'Enable', 'on');
    set(handles.edGARCH, 'Enable', 'on');
else
    set(handles.edARCH, 'Enable', 'off');
    set(handles.edGARCH, 'Enable', 'off');
end



function edARCH_Callback(hObject, eventdata, handles)
% hObject    handle to edARCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edARCH as text
%        str2double(get(hObject,'String')) returns contents of edARCH as a double


% --- Executes during object creation, after setting all properties.
function edARCH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edARCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGARCH_Callback(hObject, eventdata, handles)
% hObject    handle to edGARCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGARCH as text
%        str2double(get(hObject,'String')) returns contents of edGARCH as a double


% --- Executes during object creation, after setting all properties.
function edGARCH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGARCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
