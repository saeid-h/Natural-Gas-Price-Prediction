function varargout = NGPF_ANN_form(varargin)
% NGPF_ANN_FORM MATLAB code for NGPF_ANN_form.fig
%      NGPF_ANN_FORM, by itself, creates a new NGPF_ANN_FORM or raises the existing
%      singleton*.
%
%      H = NGPF_ANN_FORM returns the handle to a new NGPF_ANN_FORM or the handle to
%      the existing singleton*.
%
%      NGPF_ANN_FORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NGPF_ANN_FORM.M with the given input arguments.
%
%      NGPF_ANN_FORM('Property','Value',...) creates a new NGPF_ANN_FORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NGPF_ANN_form_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NGPF_ANN_form_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NGPF_ANN_form

% Last Modified by GUIDE v2.5 27-Apr-2016 00:57:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NGPF_ANN_form_OpeningFcn, ...
                   'gui_OutputFcn',  @NGPF_ANN_form_OutputFcn, ...
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


% --- Executes just before NGPF_ANN_form is made visible.
function NGPF_ANN_form_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NGPF_ANN_form (see VARARGIN)

% Choose default command line output for NGPF_ANN_form
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

setappdata(0, 'liststring2', []);


% UIWAIT makes NGPF_ANN_form wait for user response (see UIRESUME)
% uiwait(handles.ANNForm);


% --- Outputs from this function are returned to the command line.
function varargout = NGPF_ANN_form_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edLags_Callback(hObject, eventdata, handles)
% hObject    handle to edLags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edLags as text
%        str2double(get(hObject,'String')) returns contents of edLags as a double


% --- Executes during object creation, after setting all properties.
function edLags_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edLags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lstExVar1.
function lstExVar1_Callback(hObject, eventdata, handles)
% hObject    handle to lstExVar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lstExVar1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstExVar1


% --- Executes during object creation, after setting all properties.
function lstExVar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstExVar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Lags = str2num(get(handles.edLags, 'String'));
Nodes = str2num(get(handles.edNodes, 'String'));
if get(handles.rdbNAR, 'Value')
    ANN_Model = 'NAR';
else
    ANN_Model = 'NARX';
end

VariableList = get(handles.lstExVar2, 'String');
ExVar = [];
load Variables;
while ~isempty(VariableList)
    if strcmp(VariableList(1),'Total Natural Gas Production')
            ExVar = [ExVar; ProdTot];
    elseif strcmp(VariableList(1),'Total Natural Gas Consumption')
            ExVar = [ExVar; ConsTot];
    elseif strcmp(VariableList(1),'Storag Capacity')
            ExVar = [ExVar; StrgCap];
    elseif strcmp(VariableList(1),'Storage Volume')
            ExVar = [ExVar; StrgVol];
    elseif strcmp(VariableList(1), 'Storage Injection')
            ExVar = [ExVar; StorInj];
    elseif strcmp(VariableList(1), 'Storage Withdrawal')
            ExVar = [ExVar; StorExt];
    elseif strcmp(VariableList(1), 'West Texas Instrument Oil Price')
            ExVar = [ExVar; WTI];
    elseif strcmp(VariableList(1), 'Cooling Degree Day')
            ExVar = [ExVar; TCDDLA];
    elseif strcmp(VariableList(1), 'Heating Degree Day')
            ExVar = [ExVar; THDDLA];
    elseif strcmp(VariableList(1), 'Extreme Max. Temperature')
            ExVar = [ExVar; TExMxLA];
    elseif strcmp(VariableList(1), 'Extreme Min. Temperature')
            ExVar = [ExVar; TExMnLA];
    elseif strcmp(VariableList(1), 'Mean Temperature')
            ExVar = [ExVar; TMLA];
    end
   
    VariableList(1) = [];
end

ExVar = cell2num(ExVar);

assignin('base', 'Lags', Lags);
assignin('base', 'Nodes', Nodes);
assignin('base', 'ANN_Model', ANN_Model);
assignin('base', 'ExVar', ExVar);

delete(handles.ANNForm);


% --- Executes on selection change in lstExVar2.
function lstExVar2_Callback(hObject, eventdata, handles)
% hObject    handle to lstExVar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lstExVar2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstExVar2


% --- Executes during object creation, after setting all properties.
function lstExVar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstExVar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbAdd.
function pbAdd_Callback(hObject, eventdata, handles)
% hObject    handle to pbAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

liststring2 = getappdata(0, 'liststring2'); 
liststring1 = get(handles.lstExVar1, 'String');
item = get(handles.lstExVar1, 'Value');
liststring2 = [liststring2; liststring1(item)];
set (handles.lstExVar2, 'String', liststring2);
set(handles.pbRemove, 'Enable', 'on');
if item == size(liststring1,1)
    set(handles.lstExVar1, 'Value', 1);
end    
liststring1(item) = [];
set (handles.lstExVar1, 'String', liststring1);
setappdata (0, 'liststring1', liststring1);
setappdata (0, 'liststring2', liststring2); 
if isempty(liststring1)
    set(handles.pbAdd, 'Enable', 'off');
end


% --- Executes on button press in pbRemove.
function pbRemove_Callback(hObject, eventdata, handles)
% hObject    handle to pbRemove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

liststring1 = getappdata(0, 'liststring1'); 
liststring2 = get(handles.lstExVar2, 'String');
item = get(handles.lstExVar2, 'Value');
liststring1 = [liststring1; liststring2(item)];
set (handles.lstExVar1, 'String', liststring1);
set(handles.pbAdd, 'Enable', 'on');
if item == size(liststring2,1)
    set(handles.lstExVar2, 'Value', 1);
end    
liststring2(item) = [];
set (handles.lstExVar2, 'String', liststring2);
setappdata (0, 'liststring1', liststring1); 
setappdata (0, 'liststring2', liststring2);
if isempty(liststring2)
    set(handles.pbRemove, 'Enable', 'off');
end


% --- Executes on button press in rdbNAR.
function rdbNAR_Callback(hObject, eventdata, handles)
% hObject    handle to rdbNAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbNAR

set (handles.pbAdd, 'Enable', 'off');
set (handles.pbRemove, 'Enable', 'off');
set (handles.lstExVar1, 'Enable', 'off');
set (handles.lstExVar2, 'Enable', 'off');



% --- Executes on button press in rdbNARX.
function rdbNARX_Callback(hObject, eventdata, handles)
% hObject    handle to rdbNARX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbNARX

if ~isempty(get(handles.lstExVar1, 'String'))
    set (handles.pbAdd, 'Enable', 'on');
end
if ~isempty(get(handles.lstExVar2, 'String'))
    set (handles.pbRemove, 'Enable', 'on');
end
set (handles.lstExVar1, 'Enable', 'on');
set (handles.lstExVar2, 'Enable', 'on');



function edNodes_Callback(hObject, eventdata, handles)
% hObject    handle to edNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edNodes as text
%        str2double(get(hObject,'String')) returns contents of edNodes as a double


% --- Executes during object creation, after setting all properties.
function edNodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
