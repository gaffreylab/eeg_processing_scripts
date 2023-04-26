
function summary_info = get_bins_single_subject(varargin)

global proj

% Load ERP
ERP = pop_loaderp('filename', proj.erp_filenames{proj.currentSub}, ...
    'filepath', 'E:\ern_rest_microstates\processed_eeg_data\ern_data\ern_data_good\');
summary_info.currentId = {proj.currentId};

ERP = pop_binoperator(ERP, {'b8 = b7-b6'});

path = 'E:\ern_rest_microstates\processed_eeg_data\ern_data\ern_data_good_for_cartool\'; 
name = [proj.currentId '_ern_diff_wave'];
save = fullfile(path, name);


% path = 'E:\new_go_prep\microstate_analysis'; 
% name = 'grand_average_95_ern_diff_wave';
% save = fullfile(path, name);



% Save bin
pop_export2text(ERP, save,  8, 'precision',  4, 'timeunit',  0.001, ...
    'time', 'off', 'electrodes', 'off', 'transpose', 'off');