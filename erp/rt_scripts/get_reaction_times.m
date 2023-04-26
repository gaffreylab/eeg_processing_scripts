% getting reaction times after preprocessing was already done 
% takes interim_3 file and redoes a few steps 
% outputs a reaction time txt file for each participant

function summary_info = get_reaction_times(varargin)

global proj

%% Import data
set_filename = proj.set_filenames{proj.currentSub};
EEG = pop_loadset('filename', {set_filename}, 'filepath',...
    'E:\new_go_prep\processed_data_new\interim\');
summary_info.currentId = {proj.currentId};

% Select only the events that matter
EEG = pop_selectevent( EEG, 'type',{'Go_C','Go_I','No_C','No_I','resp'},'deleteevents','on');

% Load event list
el_filename = ['E:\new_go_prep\processed_data_new\event_lists\' proj.currentId '_go_event_list.txt'];
EEG  = pop_editeventlist( EEG , 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, ...
    'ExportEL', el_filename, 'List', 'E:\new_go_prep\scripts\rt_scripts\go_equation_list.txt', ...
    'SendEL2', 'EEG&Text', 'UpdateEEG', 'code', 'Warning', 'off' );

% Upload bins file
el_import_filename =  fullfile('', el_filename);
EEG  = pop_binlister( EEG , 'BDF', 'E:\new_go_prep\scripts\rt_scripts\go_bins_with_rt.txt', 'ImportEL', ...
  el_import_filename, 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' ); % 1/19/22 edit to include rt

% Extract bin-based epochs and apply baseline correction
EEG = pop_epochbin(EEG , [-500  800],  [-500 -300]); 
% Baseline is -500 to -300 because the ERN can begin prior to completion of the motor response

% ********************************************************************** %

%% Save reaction times

rt_name = [proj.currentId];
rt_file_name = [rt_name '_rt.txt'];
rt_path = 'E:\new_go_prep\processed_data_new\rt\';

pop_rt2text(EEG, 'arfilter', 'on', 'filename', [rt_path rt_file_name], ...
     'header', 'on', 'listformat', 'itemized' );
 

