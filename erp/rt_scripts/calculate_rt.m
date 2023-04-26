% getting reaction times after preprocessing was already done 

function summary_info = calculate_rt(varargin)

global proj

%% Import data
erp_filename = proj.erp_filenames{proj.currentSub};

[proj.data_location erp_filename];
rt = readtable([proj.data_location erp_filename], 'PreserveVariableNames',true);

erp_filenames2 = proj.erp_filenames2{proj.currentSub};

[proj.data_location2 erp_filename];
flags = readtable([proj.data_location2 erp_filenames2], 'PreserveVariableNames',true);

summary_info.currentId = {proj.currentId};

% for testing
% rt = readtable('C:\DEED\Armen\erp\go_no_go\processed_data\rt\7502FU1_rt.txt', 'PreserveVariableNames',true);
% flags = readtable('C:\DEED\Armen\erp\go_no_go\processed_data\flags\7502FU1_rej_flags.txt', 'PreserveVariableNames',true);
% proj.currentI = 'test';


rt = rt(:,[1 2 5]);

rt.Properties.VariableNames = {'item' 'time' 'bin'};

table(rt)   % only items with rt in rt-file
table(flags) % all items 
 
rt_flag_cell = table2array(outerjoin(rt,flags,'Keys',1));
 
R = isnan(rt_flag_cell(:,1)); % remove row/item if column 1 has NA; (no rt value)
rt_flag_cell(R,:) = [];  
 
M = rt_flag_cell(:,5) == 1; % remove row/item if flagged to reject
rt_flag_cell(M,:) = []; 
 
format long g

% grab original number of trials

original = size(rt_flag_cell, 1);

% bin 6 only
P = rt_flag_cell;
Q = P(:,3) == 7;  % bin number=6
P(Q,:) = []; 
summary_info.orig_num_trials_b6 = size(P, 1);

% bin 7 only
summary_info.orig_num_trials_b7 = original - size(P, 1);

% calculate mean, min, max of column 2 when column 3 = 6
mean_b6 = mean(rt_flag_cell(rt_flag_cell(:,3) == 6, 2));
min_b6 = min(rt_flag_cell(rt_flag_cell(:,3) == 6, 2));
max_b6 = max(rt_flag_cell(rt_flag_cell(:,3) == 6, 2));

% calculate mean, min, max of column 2 when column 3 = 7
mean_b7 = mean(rt_flag_cell(rt_flag_cell(:,3) == 7, 2));
min_b7 = min(rt_flag_cell(rt_flag_cell(:,3) == 7, 2));
max_b7 = max(rt_flag_cell(rt_flag_cell(:,3) == 7, 2));

if isempty(min_b7)
   min_b7 = 0;
end

if isempty(max_b7)
   max_b7 = 0;
end

% put in spreadsheet
summary_info.mean_b6 = mean_b6;
summary_info.min_b6 = min_b6;
summary_info.max_b6 = max_b6;
summary_info.mean_b7 = mean_b7;
summary_info.min_b7 = min_b7;
summary_info.max_b7 = max_b7;

% find rt that are outside of acceptable threshold
low = find(rt_flag_cell(:,2)<100);
high = find(rt_flag_cell(:,2)>2000);

low = rt_flag_cell(low,:);
high = rt_flag_cell(high,:);

met_thresh = cat(1, low,high);
met_thresh = met_thresh(:,1:3);

% save number of rows
summary_info.num_trials_rej = size(met_thresh,1);

% save actual items
all_rows = met_thresh(:,1);
prev_rows = all_rows - 1;
all_rows = all_rows';
prev_rows = prev_rows';
all_rows = [prev_rows all_rows];
all_rows_new = num2str(all_rows);
summary_info.items_to_rej = all_rows_new;

% save all_rows_new for each participate and matlab thing
name = [proj.currentId];
file_name = [name '_rt_rej_items'];
path = 'E:\new_go_prep\processed_data_new\rt_rej_items\';
save([path file_name], 'all_rows_new')
 
% save new means
Y = rt_flag_cell(:,2) < 100; % remove if flagged to reject
rt_flag_cell(Y,:) = []; 
Y = rt_flag_cell(:,2) > 2000; % remove if flagged to reject
rt_flag_cell(Y,:) = []; 


% calculate mean, min, max of column 2 when column 3 = 6
new_mean_b6 = mean(rt_flag_cell(rt_flag_cell(:,3) == 6, 2));
new_min_b6 = min(rt_flag_cell(rt_flag_cell(:,3) == 6, 2));
new_max_b6 = max(rt_flag_cell(rt_flag_cell(:,3) == 6, 2));

% calculate mean, min, max of column 2 when column 3 = 7
new_mean_b7 = mean(rt_flag_cell(rt_flag_cell(:,3) == 7, 2));
new_min_b7 = min(rt_flag_cell(rt_flag_cell(:,3) == 7, 2));
new_max_b7 = max(rt_flag_cell(rt_flag_cell(:,3) == 7, 2));

if isempty(new_min_b7)
   new_min_b7 = 0;
end

if isempty(new_max_b7)
   new_max_b7 = 0;
end


% put in spreadsheet
summary_info.new_mean_b6 = new_mean_b6;
summary_info.new_min_b6 = new_min_b6;
summary_info.new_max_b6 = new_max_b6;
summary_info.new_mean_b7 = new_mean_b7;
summary_info.new_min_b7 = new_min_b7;
summary_info.new_max_b7 = new_max_b7;

% grab total numbner of trials for bin 6 and 7 

new_original = size(rt_flag_cell, 1);

% bin 6 only
Q = rt_flag_cell(:,3) == 7;
rt_flag_cell(Q,:) = []; 
summary_info.new_num_trials_b6 = size(rt_flag_cell, 1);

% bin 7 only
summary_info.new_num_trials_b7 = new_original - size(rt_flag_cell, 1);


