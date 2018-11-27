function data = T_CODING_VS(data)

t_ctr = 0;
ctr_1513 = 0;

trials = find(data.evt.use.code == 1513 | data.evt.use.code == 1514)';

for i_evt = trials(1:end-1)
    
    ctr_1513 = ctr_1513 + 1;
    
    trial_evts = data.evt.use.code(i_evt+1:trials(ctr_1513+1)-1);
    
    if ~any(trial_evts == 2651)
        continue
    else
        t_ctr = t_ctr + 1;
    end
    
    data.trial_info{t_ctr}.start = data.evt.use.time(find(trial_evts == 1666) + i_evt);
    data.trial_info{t_ctr}.end = data.evt.use.time(find(trial_evts == 1667) + i_evt);
    data.trial_info{t_ctr}.outcome = 0;
    data.trial_info{t_ctr}.correct = 0;
    
    data.trial_info{t_ctr}.fix = data.evt.use.time(find(trial_evts == 2660) + i_evt);
    data.trial_info{t_ctr}.stim = data.evt.use.time(find(trial_evts == 2651) + i_evt);
    
    if any(trial_evts == 2810)
        data.trial_info{t_ctr}.rt = data.evt.use.time(find(trial_evts == 2810) + i_evt) - ...
            data.trial_info{t_ctr}.stim;
    end
    
    if any(trial_evts == 2727)
        data.trial_info{t_ctr}.correct = 1;
    end
    
    p_ctr = i_evt + find(trial_evts == 2998);
    in_pgs = true;
    a_ctr = 1;
    d_ctr = 1;
    while in_pgs
        p_ctr = p_ctr + 1;
        if data.evt.use.code(p_ctr) == 3000
            
            data.trial_info{t_ctr}.set_n = a_ctr - 1;
            
            data.trial_info{t_ctr}.fix_time = ...
                data.evt.use.code(p_ctr+1) - 3000;
            data.trial_info{t_ctr}.ecc = ...
                (data.evt.use.code(p_ctr+2) - 3000) / 10;
            data.trial_info{t_ctr}.scale = ...
                (data.evt.use.code(p_ctr+3) - 3000) / 100;
            data.trial_info{t_ctr}.outcome = ...
                data.evt.use.code(p_ctr+4) - 3000;
            data.trial_info{t_ctr}.targ_idx = ...
                data.evt.use.code(p_ctr+5) - 800 + 1;
            data.trial_info{t_ctr}.ang_offset = ...
                data.evt.use.code(p_ctr+6) - 300;
            data.trial_info{t_ctr}.targ_col = ...
                data.evt.use.code(p_ctr+7) - 700;
            data.trial_info{t_ctr}.dist_col = ...
                data.evt.use.code(p_ctr+8) - 710;
            data.trial_info{t_ctr}.rew_dur = ...
                data.evt.use.code(p_ctr+9) - 3000;
            data.trial_info{t_ctr}.targ_hold = ...
                data.evt.use.code(p_ctr+10) - 3000;
            
            if data.trial_info{t_ctr}.targ_col == data.trial_info{t_ctr}.dist_col
                data.trial_info{t_ctr}.catch = true;
            else
                data.trial_info{t_ctr}.catch = false;
            end
            
            if data.evt.use.code(p_ctr+11) ~= 2999
                data.trial_info{t_ctr}.info_corrupt = true;
                data.trial_info = data.trial_info(1:end-1);
                t_ctr = t_ctr - 1;
                in_pgs = false;
            else
                data.trial_info{t_ctr}.info_corrupt = false;

                data.trial_info{t_ctr}.size = ...
                    data.trial_info{t_ctr}.ecc * data.trial_info{t_ctr}.scale;
                
                data.trial_info{t_ctr}.targ_loc = ...
                    data.trial_info{t_ctr}.angle(data.trial_info{t_ctr}.targ_idx);
                
                in_pgs = false;
            end
            
        else
            if data.evt.use.code(p_ctr) < 6000
                data.trial_info{t_ctr}.angle(a_ctr) = ...
                    data.evt.use.code(p_ctr) - 5000;
                a_ctr = a_ctr + 1;
            elseif data.evt.use.code(p_ctr) >= 6000
                data.trial_info{t_ctr}.diff(d_ctr) = ...
                    (data.evt.use.code(p_ctr) - 6000) / (d_ctr * 100);
                d_ctr = d_ctr + 1;
            end
        end
    end
end

data.trial_by.isi           = [];

data.trial_by.trial         = [];
data.trial_by.stim          = [];
data.trial_by.fix           = [];

data.trial_by.ecc           = [];
data.trial_by.targ_loc      = [];
data.trial_by.scale         = [];
data.trial_by.targ_col      = [];
data.trial_by.dist_col      = [];
data.trial_by.set_n         = [];

data.trial_by.fix_time      = [];
data.trial_by.targ_hold     = [];
data.trial_by.correct       = [];
data.trial_by.rt            = [];
data.trial_by.rew_dur       = [];

data.trial_by.outcome       = [];
data.trial_by.catch         = [];

data.trial_by.info_corrupt  = [];

for i_trial = 1 : length(data.trial_info)
    
    if i_trial > 1
        data.trial_by.isi = cat(1, data.trial_by.isi, ...
            data.trial_info{i_trial}.stim - data.trial_info{i_trial-1}.stim);
    elseif i_trial == 1
        data.trial_by.isi = cat(1, data.trial_by.isi, nan);
    end
    
    data.trial_by.trial = cat(1, data.trial_by.trial, i_trial);
    data.trial_by.stim = cat(1, data.trial_by.stim, ...
        data.trial_info{i_trial}.stim);
    data.trial_by.fix = cat(1, data.trial_by.fix, ...
        data.trial_info{i_trial}.fix);
    
    data.trial_by.ecc = cat(1, data.trial_by.ecc, ...
        data.trial_info{i_trial}.ecc);
    data.trial_by.targ_loc = cat(1, data.trial_by.targ_loc, ...
        data.trial_info{i_trial}.angle(data.trial_info{i_trial}.targ_idx));
    data.trial_by.scale = cat(1, data.trial_by.scale, ...
        data.trial_info{i_trial}.scale);
    data.trial_by.targ_col = cat(1, data.trial_by.targ_col, ...
        data.trial_info{i_trial}.targ_col);
    data.trial_by.dist_col = cat(1, data.trial_by.dist_col, ...
        data.trial_info{i_trial}.dist_col);
    data.trial_by.set_n = cat(1, data.trial_by.set_n, ...
        data.trial_info{i_trial}.set_n);

    data.trial_by.fix_time = cat(1, data.trial_by.fix_time, ...
        data.trial_info{i_trial}.fix_time);
    data.trial_by.targ_hold = cat(1, data.trial_by.targ_hold, ...
        data.trial_info{i_trial}.targ_hold);
    
    data.trial_by.correct = cat(1, data.trial_by.correct, ...
        data.trial_info{i_trial}.correct);
    
   data.trial_by.catch = cat(1, data.trial_by.catch, ...
       data.trial_info{i_trial}.catch);

    if isfield(data.trial_info{i_trial}, 'rt')
        data.trial_by.rt = cat(1, data.trial_by.rt, ...
            data.trial_info{i_trial}.rt);
    else
        data.trial_by.rt = cat(1, data.trial_by.rt, nan);
    end
    
    data.trial_by.rew_dur = cat(1, data.trial_by.rew_dur, ...
        data.trial_info{i_trial}.rew_dur);

    data.trial_by.outcome = cat(1, data.trial_by.outcome, ...
        data.trial_info{i_trial}.outcome);

    data.trial_by.info_corrupt = cat(1, data.trial_by.info_corrupt, ...
        data.trial_info{i_trial}.info_corrupt);
             
end

end