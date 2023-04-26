
function summary_info = ern_rest_trim_data_single_subject(varargin)

global proj

%% Import data
set_filename = proj.set_filenames{proj.currentSub};
EEG = pop_loadset('filename', {set_filename}, 'filepath',...
    'E:\ern_rest_microstates\processed_eeg_data\rest_data\rest_data_good_set\');
summary_info.currentId = {proj.currentId};

%% Trim data to 157 seconds
EEG = pop_select( EEG, 'trial',[1:157]);

%% Save final preprocessed files

% .bva format
bva_path = 'E:\ern_rest_microstates\processed_eeg_data\rest_data\rest_data_good_bva_157s\'; 
bva_name = [proj.currentId '_rest_for_ern_157s'];
pop_writebva(EEG, fullfile(bva_path, bva_name));

% ****************************** THE END ******************************* %