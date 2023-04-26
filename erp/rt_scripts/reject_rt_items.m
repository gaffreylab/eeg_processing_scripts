
function summary_info = reject_rt_items(varargin)

global proj

erp_filename = proj.erp_filenames{proj.currentSub};
EEG = pop_loadset([erp_filename], [proj.data_location]);

erp_filenames2 = proj.erp_filenames2{proj.currentSub};
all_rows_new = load([proj.data_location2 erp_filenames2]);

summary_info.currentId = {proj.currentId};

X = all_rows_new;
for ii = 1:numel(X.all_rows_new)
    B = X.all_rows_new(ii);
    EEG.EVENTLIST.eventinfo(1,B).flag = 1;
end

EEG = pop_syncroartifacts(EEG, 'Direction', 'bidirectional');

path = 'E:\new_go_prep\processed_data_new\complete_with_rt_rej\'; 
name = [proj.currentId '_complete_with_rt_rej'];
pop_saveset(EEG, fullfile(path, name));