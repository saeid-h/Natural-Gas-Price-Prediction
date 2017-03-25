function varargout = NGPF_SDE_form(varargin)
% NGPF_SDE_FORM MATLAB code for NGPF_SDE_form.fig
%      NGPF_SDE_FORM, by itself, creates a new NGPF_SDE_FORM or raises the existing
%      singleton*.
%
%      H = NGPF_SDE_FORM returns the handle to a new NGPF_SDE_FORM or the handle to
%      the existing singleton*.
%
%      NGPF_SDE_FORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NGPF_SDE_FORM.M with the given input arguments.
%
%      NGPF_SDE_FORM('Property','Value',...) creates a new NGPF_SDE_FORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NGPF_SDE_form_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NGPF_SDE_form_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NGPF_SDE_form

% Last Modified by GUIDE v2.5 26-Apr-2016 22:04:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NGPF_SDE_form_OpeningFcn, ...
                   'gui_OutputFcn',  @NGPF_SDE_form_OutputFcn, ...
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


% --- Executes just before NGPF_SDE_form is made visible.
function NGPF_SDE_form_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NGPF_SDE_form (see VARARGIN)

% Choose default command line output for NGPF_SDE_form
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
assignin('base', 'IsDynamic', 1);
assignin('base', 'ModelSel', 'GBM');
assignin('base', 'Alpha', 0.5);



% UIWAIT makes NGPF_SDE_form wait for user response (see UIRESUME)
% uiwait(handles.SDEForm);


% --- Outputs from this function are returned to the command line.
function varargout = NGPF_SDE_form_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtSDEformAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to txtSDEformAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSDEformAlpha as text
%        str2double(get(hObject,'String')) returns contents of txtSDEformAlpha as a double
a = str2num(get(handles.txtSDEformAlpha, 'String')); 
assignin('base', 'Alpha', a);



% --- Executes during object creation, after setting all properties.
function txtSDEformAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSDEformAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbSDEformOK.
function pbSDEformOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbSDEformOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.rdbSDEformGBM, 'value') 
    assignin('base', 'ModelSel', 'GBM');
elseif get(handles.rdbSDEformCEV, 'value') 
    assignin('base', 'ModelSel', 'CEV');
elseif get(handles.rdbSDEfromSDELD, 'value') 
    assignin('base', 'ModelSel', 'SDELD');
end

if get(handles.rdbSDEformDynYes, 'value') 
    assignin('base', 'IsDynamic', 1);
elseif get(handles.rdbSDEformDynNo, 'value') 
    assignin('base', 'IsDynamic', 0);
end

a = str2num(get(handles.txtSDEformAlpha, 'String')); 
assignin('base', 'Alpha', a);

delete(handles.SDEForm);


% --- Executes on button press in rdbSDEformGBM.
function rdbSDEformGBM_Callback(hObject, eventdata, handles)
% hObject    handle to rdbSDEformGBM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbSDEformGBM
assignin('base', 'ModelSel', 'GBM');
set(handles.txtSDEformAlpha, 'Visible', 'off')
set(handles.stSDEformAlpha, 'Visible', 'off')


% --- Executes on button press in rdbSDEformCEV.
function rdbSDEformCEV_Callback(hObject, eventdata, handles)
% hObject    handle to rdbSDEformCEV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbSDEformCEV
assignin('base', 'ModelSel', 'CEV');
set(handles.txtSDEformAlpha, 'Visible', 'on')
set(handles.stSDEformAlpha, 'Visible', 'on')



% --- Executes on button press in rdbSDEfromSDELD.
function rdbSDEfromSDELD_Callback(hObject, eventdata, handles)
% hObject    handle to rdbSDEfromSDELD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbSDEfromSDELD
assignin('base', 'ModelSel', 'SDELD');
set(handles.txtSDEformAlpha, 'Visible', 'on')
set(handles.stSDEformAlpha, 'Visible', 'on')


% --- Executes on button press in rdbSDEformDynYes.
function rdbSDEformDynYes_Callback(hObject, eventdata, handles)
% hObject    handle to rdbSDEformDynYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbSDEformDynYes
assignin('base', 'IsDynamic', 1);


% --- Executes on button press in rdbSDEformDynNo.
function rdbSDEformDynNo_Callback(hObject, eventdata, handles)
% hObject    handle to rdbSDEformDynNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbSDEformDynNo

assignin('base', 'IsDynamic', 0);
