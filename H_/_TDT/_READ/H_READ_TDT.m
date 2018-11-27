function data = H_READ_TDT(info, params, varargin)

fprintf('\n Begin: Reading in TDT data. \n')

warning off

data = struct();

data.t_lims = [0 0];
data.bhv_only = false;
data.data = [];

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-t','time'}
            data.t_lims = varargin{varStrInd(iv)+1};
        case {'-b','bhv'}
            data.bhv_only = varargin{varStrInd(iv)+1};
    end
end

if info.date > 181003
    if info.date > 181004
        
        d_type = {'lfp', 'csd', 'mua', 'hga', 'lga', 'bet', 'alp', 'the', ...
            'del', 'hga_pwr', 'lga_pwr', 'bet_pwr', 'alp_pwr', 'the_pwr', ...
            'del_pwr'};
        
        d_store = {'Lfp1', 'Csd1', 'Mua1', 'Hga1', 'Lga1', 'Bet1', 'Alp1', ...
            'The1', 'Del1', 'Hgp1', 'Lgp1', 'Bpw1', 'Apw1', 'Tpw1', 'Dpw1'};
        
        a_type = {'eye_x', 'eye_y', 'pupil', 'pd', 'reward'};
        a_store = {'Eyx1', 'Eyy1', 'Pud1', 'Pho1', 'Rew1'};
        
        e_type = {'events', 'reward_trig', 'pd_trig'};
        e_store = {'Str1', 'Ret1', 'Pht1'};
        
    elseif info.date == 181004
        
        d_type = {'lfp', 'csd', 'mua', 'hga', 'lga', 'bet', 'alp', 'the', ...
            'del', 'hga_pwr', 'lga_pwr', 'bet_pwr', 'alp_pwr', 'the_pwr', ...
            'del_pwr'};
        
        d_store = {'Lfp1', 'Mua1', 'Csd1', 'Mua1', 'Hga1', 'Lga1', 'Bet1', 'Alp1', ...
            'The1', 'Del1', 'Hgp1', 'Lgp1', 'Bpw1', 'Apw1', 'Tpw1', 'Dpw1'};
        
        a_type = {'eye_x', 'eye_y', 'pupil', 'pd'};
        a_store = {'Eyx1', 'Eyy1', 'Pud1', 'Phd1'};
        
        e_type = {'events', 'fix', 'stim', 'pd_trig'};
        e_store = {'STRB', 'FIX_', 'STM_', 'Pht1'};
        
    end
    
    for i_d = 1 : size(d_type,2)
        
        switch params.fromScratch
            
            case true
                
                if i_d == 1
                    
                    [data.data, data.data_fs] = H_RAW_SUB_READ_TDT(info.cur_dir, ...
                        data.t_lims, info.ch_min);
                    data.data = cat(1, data.data, nan(info.ch_max - info.ch_min, ...
                        size(data.data,2)));
                    data.data_time = H_TIME_TDT(data.data, data.data_fs, data.t_lims(1));
                    
                    i_ch_ctr = 1;
                    
                    for i_ch = info.ch_min+1:info.ch_max
                        
                        i_ch_ctr = i_ch_ctr + 1;
                        
                        data.data(i_ch_ctr,:) = H_RAW_SUB_READ_TDT(info.cur_dir, ...
                            data.t_lims, i_ch);
                    end
                    
                    data.data = double(data.data);
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'mua'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_A_MUA(data);
                    end
                    
                    [data.data, data.data_fs, data.data_time] = ...
                        H_DS(24, data.data, data.data_fs, data.data_time);
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'lfp'},1, size(d_type,2)), 'uniformoutput', false)))
                        data.lfp = data.data;
                        data.lfp_fs = data.data_fs;
                        data.lfp_time = data.data_time;
                    end
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'csd'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_CSD(data, info);
                    end
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'hga'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_HGA(data);
                    end
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'lga'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_LGA(data);
                    end
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'bet'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_BET(data);
                    end
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'alp'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_ALP(data);
                    end
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'the'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_THE(data);
                    end
                    
                    if any(cell2mat(cellfun(@strcmp, d_type, repmat({'del'},1, size(d_type,2)), 'uniformoutput', false)))
                        data = D_DEL(data);
                    end
                    
                end
                
            case false
                
                [t, t_fs] = H_STR_SUB_READ_TDT(info.cur_dir, d_store{i_d}, data.t_lims, info.ch_min);
                
                eval(['data.' d_type{i_d} ' = t;']);
                eval(['data.' d_type{i_d} '_fs = t_fs;']);
                eval(['data.' d_type{i_d} '_time = H_TIME_TDT(data.' ...
                    d_type{i_d} ', data.' d_type{i_d} '_fs, ' ...
                    'data.t_lims(1));']);
                
                if strcmp(d_store{i_d}, 'Csd1')
                    
                    eval(['data.' d_type{i_d} '= cat(1, data.' d_type{i_d} ...
                        ', nan(' num2str(info.ch_max - info.ch_min - 2) ...
                        ',' num2str( eval(['size(data.' d_type{i_d} ', 2);'])) '));']);
                    
                else
                    
                    eval(['data.' d_type{i_d} '= cat(1, data.' d_type{i_d} ...
                        ', nan(' num2str(info.ch_max - info.ch_min) ...
                        ',' num2str( eval(['size(data.' d_type{i_d} ', 2);'])) '));']);
                    
                end
                
                i_ch_ctr = 1;
                
                for i_ch = info.ch_min+1:info.ch_max
                    
                    i_ch_ctr = i_ch_ctr + 1;
                    
                    if i_ch_ctr > info.ch_max - info.ch_min - 2 & ...
                            strcmp(d_store{i_d}, 'Csd1')
                    else
                        
                        [t, t_fs] = H_STR_SUB_READ_TDT(info.cur_dir, d_store{i_d}, data.t_lims, i_ch);
                        
                        eval(['data.' d_type{i_d} '(' num2str(i_ch) ', :) = t;']);
                        
                    end
                end
        end
    end

    for i_a = 1 : size(a_type,2)
        
        [t, t_fs] = H_STR_SUB_READ_TDT(info.cur_dir, a_store{i_a}, data.t_lims);
            
        eval(['data.' a_type{i_a} ' = t;']);
        eval(['data.' a_type{i_a} '_fs = t_fs;']);
        
        eval(['data.' a_type{i_a} '_time = H_TIME_TDT(data.' ...
            a_type{i_a} ', data.' a_type{i_a} '_fs, ' ...
            'data.t_lims(1));']);
        
    end
    
    for i_e = 1 : size(e_type, 2)
        
        [t, t_on, t_off] = H_EPO_SUB_READ_TDT(info.cur_dir, e_store{i_e}, data.t_lims);
            
        eval(['data.' e_type{i_e} '_code = t;']);
        eval(['data.' e_type{i_e} '_on = t_on * 1000;']);
        eval(['data.' e_type{i_e} '_off = t_off * 1000;']);
        
    end
    
    data.events_on(data.events_code == 0) = [];
    data.events_off(data.events_code == 0) = [];
    data.events_code(data.events_code == 0) = [];
    
else
    
    if ~data.bhv_only && ~params.training
        switch params.quick
            
            case false
                
                if isempty(gcp('nocreate'))
                    parpool(32)
                end
                
                t_stream = TDTbin2mat([ info.cur_dir '\RSn1\'], 'T1', data.t_lims(1)/1000, ...
                    'T2', data.t_lims(2)/1000, ...
                    'CHANNEL', info.ch_min);
                
                data.fs = t_stream.RSn1.fs;
                t_data= t_stream.RSn1.data;
                t_data = cat(1, t_data, ...
                    nan(info.ch_max - info.ch_min - 1, size(t_data,2)));
                
                t_dir = info.cur_dir;
                t_lims = data.t_lims;
                
                parfor i_ch = info.ch_min+1 : info.ch_max
                    
                    t_stream = TDTbin2mat([ t_dir '\RSn1\'], 'T1', t_lims(1)/1000, ...
                        'T2', t_lims(2)/1000, ...
                        'CHANNEL', i_ch);
                    
                    t_data(i_ch,:) = t_stream.RSn1.data;
                    
                end
                
                data.data = t_data; clear t_data t_lims t_dir t_stream
                
            case true
                
                switch params.fakeneuron
                    case false
                        
                        if isempty(gcp('nocreate'))
                            parpool(32)
                        end
                        
                        t_stream = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, ...
                            'T2', data.t_lims(2)/1000, ...
                            'TYPE',{'streams'},'STORE','Lfp1', 'CHANNEL', 1);
                        
                        data.fs = t_stream.streams.Lfp1.fs;
                        t_data= t_stream.streams.Lfp1.data;
                        t_data = cat(1, t_data, ...
                            nan(info.ch_max - info.ch_min - 1, size(t_data,2)));
                        
                        t_dir = info.cur_dir;
                        t_lims = data.t_lims;
                        
                        parfor i_ch = info.ch_min+1 : info.ch_max
                            
                            t_stream = TDTbin2mat(t_dir, 'T1', t_lims(1)/1000, ...
                                'T2', t_lims(2)/1000, ...
                                'TYPE',{'streams'},'STORE','Lfp1', 'CHANNEL', i_ch);
                            
                            t_data(i_ch,:) = t_stream.streams.Lfp1.data;
                            
                        end
                        
                        data.data = t_data; clear t_data t_lims t_dir t_stream
                        
                    case true
                        
                        t_data = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, ...
                            'T2', data.t_lims(2)/1000, ...
                            'TYPE',{'streams'},'STORE','Fak1');
                        
                        data.data = t_data.streams.Fak1.data;
                        data.fs = t_data.streams.Fak1.fs;
                        
                end
        end
    else
        data.data = [];
        data.fs = [];
    end
    
    data.data = double(data.data);
    
    data.vec_time = 0:(size(data.data, 2) - 1);
    data.vec_time = data.vec_time .* (1000 / data.fs);
    data.vec_time = data.vec_time + data.t_lims(1);
    
    if params.lim2cx
        data.data = data.data(info.Cx_top : info.Cx_bot,:);
    end
    
    data.pd_1 = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'streams'},'STORE','PD1_');
    data.pd_fs = data.pd_1.streams.PD1_.fs;
    data.pd_1 = data.pd_1.streams.PD1_.data;
    
    data.pd_2 = TDTbin2mat(info.cur_dir,'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'streams'},'STORE','PD2_');
    data.pd_2 = data.pd_2.streams.PD2_.data;
    
    data.eye_x = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'streams'},'STORE','EyeX');
    data.eye_fs = data.eye_x.streams.EyeX.fs;
    data.eye_x = data.eye_x.streams.EyeX.data;
    
    data.eye_y = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'streams'},'STORE','EyeY');
    data.eye_y = data.eye_y.streams.EyeY.data;
    
    data.eye_p = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'streams'},'STORE','PDia');
    data.eye_p = data.eye_p.streams.PDia.data;
    
    stim = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'epocs'},'STORE','STM_');
    data.evt.stim.code = stim.epocs.STM_.data;
    data.evt.stim.time = stim.epocs.STM_.onset .* 1000;
    
    data.evt.stim.time(data.evt.stim.code == 0) = [];
    data.evt.stim.code(data.evt.stim.code == 0) = [];
    
    clear stim;
    
    fix = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'epocs'},'STORE','FIX_');
    data.evt.fix.code = fix.epocs.FIX_.data;
    data.evt.fix.time = fix.epocs.FIX_.onset .* 1000;
    clear fix;
    
    strb = TDTbin2mat(info.cur_dir, 'T1', data.t_lims(1)/1000, 'T2', data.t_lims(2)/1000, ...
        'TYPE',{'epocs'},'STORE','STRB');
    data.evt.code = strb.epocs.STRB.data;
    data.evt.time = strb.epocs.STRB.onset .* 1000;
    clear strb;
    
    data.evt.time(data.evt.code == 0) = [];
    data.evt.code(data.evt.code == 0) = [];
    
    f_stm = find(data.evt.code == 2651);
    t_dif = diff(data.evt.time(data.evt.code==2651));
    e_dif = [0; t_dif < 100];
    
    data.evt.time(f_stm(logical(e_dif))) = [];
    data.evt.code(f_stm(logical(e_dif))) = [];
    
    data.evt.vec_task = H_DETT_TDT(data.evt.code);
    data.evt = H_DETB_TDT(data.evt);
    
    data.pd_vec_time = 0:(size(data.pd_1, 2) - 1);
    data.pd_vec_time = data.pd_vec_time .* (1000 / data.pd_fs);
    data.pd_vec_time = data.pd_vec_time + data.t_lims(1);
    
    data.eye_vec_time = 0:(size(data.eye_x, 2) - 1);
    data.eye_vec_time = data.eye_vec_time .* (1000 / data.eye_fs);
    data.eye_vec_time = data.eye_vec_time + data.t_lims(1);
    
    data.nyq = data.fs/2;
    
    switch params.pd_trigger
        case 'PD1_'
            data = H_TRIGPD_TDT(data);
            data.evt.use.code = data.evt.code;
            data.evt.use.time = data.evt.pd.time;
            
        case 'STM_'
            data.evt.use.code = data.evt.stim.code;
            data.evt.use.time = data.evt.stim.time;
            
        case 'TEMPO' % Unreliable
            data.evt.use.code = data.evt.code;
            data.evt.use.time = data.evt.time;
            
    end
end
warning on

fprintf('\n End: Reading in TDT data. \n')

end