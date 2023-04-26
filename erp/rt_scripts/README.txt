Order of operations:

go_process_single_subj
    - run a second time to regenerate erps from new bdf file 
    - *** Actually we don't need this, we just run the next script with interim_3 data ***

get_reaction_times
    - uses ERPLAB to compute an rt text file
    - input: interim_3 data 
    - output: rt text file for each participant 

get_rej_flags
    - get eventlist item # and flags
    - input: original complete_set files
    - output: flags (txt files)

calculate_rt
    - most complicated script, essentially merges the rt/flag information
    - input: rt ANDflag text files
    - output: matlab file of what to reject when making erps AND csv with reaction times

reject_rt_items
    - applies the rejected items to the erps
    - input: original complete_set files AND rt_rej_items from previous step
    - output: final .set files with new flags based on rt data

average_erps
    - redo averaging after flags are updated
    - input: .set files from previous step
    - output: final erps with trials rejected based on rt data AND csv with number of trials

go_quantify_single_subj
    -chanops/binops for new bins and rois
    -batch-measures a single erp amplitude