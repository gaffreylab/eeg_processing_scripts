
function summary_info = go_quantify_single_sub_method_1(varargin)

global proj

% METHOD 1: Mean amplitude within specified time window

% Load ERP
ERP = pop_loaderp('filename', proj.erp_filenames{proj.currentSub}, ...
    'filepath', 'E:\ern_rest_microstates\processed_eeg_data\ern_data\ern_data_good\');
summary_info.currentId = {proj.currentId};

% Create Pool of Channels Around Cz

ERP = pop_erpchanoperator(ERP, {'ch106 = (ch105+ch7+ch30+ch49+ch70+ch92)/6'} , ... 
    'ErrorMsg', 'popup', 'KeepLocations',  0, 'Warning', 'on');

% Get ERP values 

% Correct Trials

ERP = pop_geterpvalues(ERP, [-64 108],  6,  106 , 'Baseline', 'none', 'FileFormat', ...
      'wide', 'Fracreplace', 'NaN', 'InterpFactor',  1,'Measure', 'meanbl', 'PeakOnset',  1, 'Resolution',  3, ...
      'SendtoWorkspace', 'on');
 
ERP_MEASURES = evalin('base','ERP_MEASURES');
 
correct_mean_amp = ERP_MEASURES;
summary_info.correct_mean_amp = correct_mean_amp;

clear ERP_MEASURES;

% Error Trials

ERP = pop_geterpvalues(ERP, [-64 108],  7,  106 , 'Baseline', 'none', 'FileFormat', ...
      'wide', 'Fracreplace', 'NaN', 'InterpFactor',  1,'Measure', 'meanbl', 'PeakOnset',  1, 'Resolution',  3, ...
      'SendtoWorkspace', 'on');
 
ERP_MEASURES = evalin('base','ERP_MEASURES');
 
error_mean_amp = ERP_MEASURES;
summary_info.error_mean_amp = error_mean_amp;

clear ERP_MEASURES;
