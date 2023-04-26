function summary_info = average_erps(varargin)

global proj

%% Import data
set_filename = proj.set_filenames{proj.currentSub};
EEG = pop_loadset('filename', {set_filename}, 'filepath',...
    'E:\new_go_prep\processed_data_new\complete_with_rt_rej\');
summary_info.currentId = {proj.currentId};

%% Compute averaged ERPs

ERP = pop_averager(EEG , 'Criterion', 'good', 'DQ_flag', 1, 'ExcludeBoundary', 'on', 'SEM', 'on' );

% And save them
erp_name = [proj.currentId '_go_averaged_erps_with_rt_rej'];
erp_file_name = [erp_name '.erp'];
erp_path = 'E:\new_go_prep\processed_data_new\erps_with_rt_rej\';
ERP = pop_savemyerp(ERP, 'erpname', erp_name, 'filename', erp_file_name, 'filepath', erp_path, 'Warning', 'off');

%% Save trials rejected & accepted per bin

summary_info.trials_rej_b1_go_c = ERP.ntrials.rejected(1);
summary_info.trials_rej_b2_go_i = ERP.ntrials.rejected(2);
summary_info.trials_rej_b3_no_c = ERP.ntrials.rejected(3);
summary_info.trials_rej_b4_no_i = ERP.ntrials.rejected(4);
summary_info.trials_rej_b5_resp = ERP.ntrials.rejected(5);
summary_info.trials_rej_b6_go_c_resp = ERP.ntrials.rejected(6);
summary_info.trials_rej_b7_no_i_resp = ERP.ntrials.rejected(7);

summary_info.trials_accept_b1_go_c = ERP.ntrials.accepted(1);
summary_info.trials_accept_b2_go_i = ERP.ntrials.accepted(2);
summary_info.trials_accept_b3_no_c = ERP.ntrials.accepted(3);
summary_info.trials_accept_b4_no_i = ERP.ntrials.accepted(4);
summary_info.trials_accept_b5_resp = ERP.ntrials.accepted(5);
summary_info.trials_accept_b6_go_c_resp = ERP.ntrials.accepted(6);
summary_info.trials_accept_b7_no_i_resp = ERP.ntrials.accepted(7);