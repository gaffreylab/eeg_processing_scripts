% input original complete_set files
% get eventlist item # and flags

function summary_info = get_rej_flags(varargin)

global proj

%% Import data
set_filename = proj.set_filenames{proj.currentSub};
EEG = pop_loadset('filename', {set_filename}, 'filepath',...
    'E:\new_go_prep\processed_data_new\complete\');
summary_info.currentId = {proj.currentId};

items = [EEG.EVENTLIST.eventinfo.item]';
flags = [EEG.EVENTLIST.eventinfo.flag]';

table.item = items;
table.flags = flags;

table = [table.item, table.flags];
table = double(table);

table = array2table(table);
table.Properties.VariableNames = {'item' 'flag'};

name = [proj.currentId];
file_name = [name '_rej_flags.txt'];
path = 'E:\new_go_prep\processed_data_new\flags\';

writetable(table, [path file_name], 'Delimiter', ' ')