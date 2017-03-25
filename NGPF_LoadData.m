% function LoadData

% Import the data
clear all

[~, ~, DataFile] = xlsread('Data_File_04.xlsx','Data 1');
DataFile(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),DataFile)) = {''};

Dates = datenum(DataFile(3:end,1));
Dates = Dates';

HHSP        = (DataFile(3:end,2))';
ImP         = (DataFile(3:end,3))';
ExP         = (DataFile(3:end,4))';	 
ProdTot     = (DataFile(3:end,5))';
ProdGW      = (DataFile(3:end,6))';
ProdOW      = (DataFile(3:end,7))';
ProdShG     = (DataFile(3:end,8))';
ProdCB      = (DataFile(3:end,9))';
ProdMK      = (DataFile(3:end,10))';
ProdLiq     = (DataFile(3:end,11))';
ProdDG      = (DataFile(3:end,12))';
ImpTot      = (DataFile(3:end,13))';
ImpPip      = (DataFile(3:end,14))';
ImpLiq      = (DataFile(3:end,15))';
ExpTot      = (DataFile(3:end,16))';
ExpPip      = (DataFile(3:end,17))';
ExpLiq      = (DataFile(3:end,18))';
StrgCap     = (DataFile(3:end,19))';
StrgVol     = (DataFile(3:end,20))';
StorInj     = (DataFile(3:end,21))';
StorExt     = (DataFile(3:end,22))';
StroExtNet	= (DataFile(3:end,23))';
ConsTot     = (DataFile(3:end,24))';
ConsFul     = (DataFile(3:end,25))';
ConsDis     = (DataFile(3:end,26))';
ConsCon     = (DataFile(3:end,27))';
TCDDNY      = (DataFile(3:end,28))';
THDDNY      = (DataFile(3:end,29))';
TExMxNY     = (DataFile(3:end,30))';
TExMnNY     = (DataFile(3:end,31))';
TMxNY       = (DataFile(3:end,32))';
TMnNY       = (DataFile(3:end,33))';
TMNY        = (DataFile(3:end,34))';
TCDDTX      = (DataFile(3:end,35))';
THDDTX      = (DataFile(3:end,36))';
TExMxTX     = (DataFile(3:end,37))';
TExMnTX     = (DataFile(3:end,38))';
TMxTX       = (DataFile(3:end,39))';
TMnTX       = (DataFile(3:end,40))';
TMTX        = (DataFile(3:end,41))';
TCDDLA      = (DataFile(3:end,42))';
THDDLA      = (DataFile(3:end,43))';
TExMxLA     = (DataFile(3:end,44))';
TExMnLA     = (DataFile(3:end,45))';
TMxLA       = (DataFile(3:end,46))';
TMnLA       = (DataFile(3:end,47))';
TMLA        = (DataFile(3:end,48))';
WTI         = (DataFile(3:end,49))';

HHSPm = cell2num(HHSP);

clear DataFile
save Variables.mat '-append'

% end