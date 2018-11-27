function T_FLASH(evt, info, params, varargin)

evt_pre = 49;
evt_post = 200;

d_type = {'lfp', 'csd', 'mua', 'hga_pwr', 'lga_pwr', ...
    'bet_pwr', 'alp_pwr', 'the_pwr', 'del_pwr', 'pupil', 'pd'};

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'evt_pre',}
            evt_pre = varargin{varStrInd(iv)+1};
        case {'evt_post'}
            evt_post = varargin{varStrInd(iv)+1};
    end
end
    
vec_flash = strcmp(evt.vec_task, 'flash');
n_blk = max(evt.block_bytask(vec_flash));

for i_blk = 1 : n_blk
    
    cur_blk = vec_flash & (i_blk == evt.block_bytask)';
    
    blk.evt.code = evt.code(cur_blk);
    blk.evt.time = evt.time(cur_blk);
    
    blk.idx_beg = find( cur_blk, 1, 'first');
    blk.idx_end = find( cur_blk, 1, 'last');
    
    blk.t(1) = evt.time(blk.idx_beg) - 1000;
    blk.t(2) = evt.time(blk.idx_end) + 1000;
    
    data = H_READ_TDT(info, params, '-t', blk.t);

    data.flash.t_pre = evt_pre;
    data.flash.t_post = evt_post;
    
    t_evt = data.pd_trig_on;
    
    for i_evt = 1:length(t_evt)-1

        idx_1 = H_T2S(t_evt(i_evt) - data.t_lims(1), data.lfp_fs) - evt_pre;
        idx_2 = H_T2S(t_evt(i_evt) - data.t_lims(1), data.lfp_fs) + evt_post;
                
        for i_d = 1 : size(d_type,2)
            p_d = eval(['data.' d_type{i_d} '(:,idx_1:idx_2);']);
            p_base = nanmean(p_d(:,1:evt_pre),2);
            p_d = p_d - p_base;
            eval(['data.' d_type{i_d} '_trial(:,:,i_evt) = p_d;']);
        end
    end
    
    clear t_* p_*
    
    for i_d = 1 : size(d_type,2)
        %eval(['data.' d_type{i_d} '_mean = nanmean(data.' d_type{i_d} '_trial, 3);']);
        eval(['data.' d_type{i_d} '_mean_pt = nanmean(nanmean(data.' d_type{i_d} ...
            '_trial(:,100:200,:), 2), 3);']);
        eval(['data.' d_type{i_d} '_base_pt = nanmean(nanmean(data.' d_type{i_d} ...
            '_trial(:,1:50,:), 2), 3);']);
        
        %f = figure('units','normalized', 'position', [0 0 1 1]);
        
        %f_line = subplot(1,2,1);
        %eval(['P_EVPLINE(f, f_line, data.' d_type{i_d} '_mean, data, info);'])
        %title(['EVP ' d_type{i_d}]);
        
        %f_2d = subplot(1,2,2);
        %eval(['P_CSD2D(f, f_2d, data.' d_type{i_d} '_mean, data, info);'])
        %title(['Evoked ' d_type{i_d}]);
        
    end
    
    %flash_lfpcorr = subplot(1,6,4);
    %P_LFPCORR(figs.flash(i_blk), flash_lfpcorr, data, info);
    
    %flash_psddiff = subplot(1,6,5);
    %P_PSDDIFF(figs.flash(i_blk), flash_psddiff, data, info);
    
end
end