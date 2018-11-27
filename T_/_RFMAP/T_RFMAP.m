function T_RFMAP(evt, info, params, varargin)

evt_pre = 49;
evt_post = 200;

bin_t = [50 150];

sz_map = 20;

d_type = {'lfp', 'csd', 'mua','hga_pwr', 'lga_pwr', ...
    'bet_pwr', 'alp_pwr', 'the_pwr', 'del_pwr', 'pupil', 'pd'};

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'evt_pre',}
            evt_pre = varargin{varStrInd(iv)+1};
        case {'evt_post'}
            evt_post = varargin{varStrInd(iv)+1};
        case {'sz_map'}
            sz_map = varargin{varStrInd(iv)+1};
        case {'bin_t'}
            bin_t = varargin{varStrInd(iv)+1};
    end
end

sz_map = sz_map * 10 * 2 + 1;

vec_task = strcmp(evt.vec_task, 'rfmap');
n_blk = max(evt.block_bytask(vec_task));

for i_blk = 1 : n_blk
    
    data = H_BLKREAD_TDT(vec_task, i_blk, evt, info, params);
    data = T_CODING_RFMAP(data);
    
    data.map_ctr = zeros(sz_map, sz_map);
    data.map_center = (sz_map-1) / 2 + 1;
    
    for i_d = 1 : size(d_type,2)
        
        eval(['data.' d_type{i_d} '_trial = [];']);
        
        eval(['data.' d_type{i_d} ...
            '_map = nan(sz_map, sz_map, size(data.' ...
            d_type{i_d} ', 1));']);
        
    end

    for i_evt = 1 : length(data.trial_by.stim)
                
        idx_1 = H_T2S(data.trial_by.stim(i_evt) - data.t_lims(1), data.lfp_fs) - evt_pre;
        idx_2 = H_T2S(data.trial_by.stim(i_evt) - data.t_lims(1), data.lfp_fs) + evt_post;
        
        t_map_ctr = zeros(sz_map, sz_map);
        
        for i_d = 1 : size(d_type,2)
            
            eval(['t_' d_type{i_d} ' = data.' d_type{i_d} ...
                '(:,idx_1:idx_2);']);
            
            eval(['t_' d_type{i_d} ' = t_' d_type{i_d} ...
                ' - mean(t_' d_type{i_d} '(:,1:H_T2S(evt_pre,' ...
                ' data.lfp_fs)-1),2);']);
            
            eval(['t_' d_type{i_d} '_val = mean( t_' d_type{i_d} ...
                '(:,H_T2S(evt_pre, data.lfp_fs)' ...
                '+ H_T2S(bin_t(1), data.lfp_fs): H_T2S(evt_pre, data.lfp_fs)' ...
                '+ H_T2S(bin_t(2), data.lfp_fs)),2);']);
            
            eval(['t_' d_type{i_d} '_map = nan(sz_map, sz_map, size(data.' ...
                d_type{i_d} ',1));']);
            
        end
        
        for i_ctr = 1 : length(data.trial_by.ecc{i_evt})

            t_rad = data.trial_by.ecc{i_evt}(i_ctr) * ...
                (data.trial_by.size{i_evt}(i_ctr) * ...
                data.trial_by.scale{i_evt}(i_ctr)) / 2 * 10;

            [t_x, t_y] = pol2cart(deg2rad(data.trial_by.ang{i_evt}(i_ctr)), ...
                data.trial_by.ecc{i_evt}(i_ctr) * 10);

            t_x = round(t_x);
            t_y = round(t_y);
            
            t_cir_ctr = Circle(t_rad);
            t_r = size(t_cir_ctr,1) / 2;
            
            if mod(size(t_cir_ctr,1),2)
                t_x_coor = floor(data.map_center - t_x - t_r) : floor(data.map_center - t_x + t_r)-1;
                t_y_coor = floor(data.map_center - t_y - t_r) : floor(data.map_center - t_y + t_r)-1;
            else
                t_x_coor = data.map_center - t_x - t_r : data.map_center - t_x + t_r - 1;
                t_y_coor = data.map_center - t_y - t_r : data.map_center - t_y + t_r - 1;
            end
            
            pre_slot_ctr = t_map_ctr(t_x_coor, t_y_coor);
            post_slot_ctr = cat(3, pre_slot_ctr, t_cir_ctr);
            t_map_ctr(t_x_coor, t_y_coor) = nanmax(post_slot_ctr, [], 3);
            
            for i_d = 1 : size(d_type,2)
                
                eval(['t_cir_' d_type{i_d} ' = bsxfun(@times, repmat(double(Circle(t_rad)), 1, 1, size(t_' ...
                    d_type{i_d} '_val, 1)), reshape(t_' d_type{i_d} '_val, 1, 1, []));'])
                
                eval(['pre_slot_' d_type{i_d} ' = t_' d_type{i_d} ...
                    '_map(t_x_coor, t_y_coor, :);'])
                
                eval(['post_slot_' d_type{i_d} ' = ' ...
                    'cat(4, pre_slot_' d_type{i_d} ', t_cir_' ...
                    d_type{i_d} ');'])
                
                eval(['t_' d_type{i_d} '_map(t_x_coor, t_y_coor,:) = ' ...
                    'nanmax(post_slot_' d_type{i_d} ', [], 4);'])
                
            end 
        end

        data.map_ctr = sum(cat(3,data.map_ctr, t_map_ctr),3);
         
        for i_d = 1 : size(d_type,2)
                
                eval(['temp_weight_post_' d_type{i_d} ' = t_' ...
                    d_type{i_d} '_map .* repmat((1./data.map_ctr), 1, 1, size(data.' ...
                    d_type{i_d} ', 1));'])
                
                eval(['temp_weight_pre_' d_type{i_d} ' = data.' ...
                    d_type{i_d} '_map .* repmat(((data.map_ctr - 1)./data.map_ctr), 1, 1, size(data.' ...
                    d_type{i_d} ', 1));'])
                
                eval(['data.' d_type{i_d} '_map = nansum(cat(4,temp_weight_pre_' ...
                    d_type{i_d} ', temp_weight_post_' d_type{i_d} '),4);'])
                
                eval(['data.' d_type{i_d} '_trial = cat(3, data.' ...
                    d_type{i_d} '_trial, t_' d_type{i_d} ');'])
                
        end  
    end

    for i_d = 1 : size(d_type,2)
        
        eval(['t_c = size(data.' d_type{i_d} ', 1);'])
        
        for i_c = 1 : t_c
            
            f = figure;
            rfmap_surf = subplot(1,2,1);
            rfmap_count = subplot(1,2,2);
            
            eval(['P_RFSURF(f, rfmap_surf, data.' d_type{i_d} '_map(:,:,i_c), info);'])
            eval(['P_RFCOUNT(f, rfmap_count, data.' d_type{i_d} '_map(:,:,i_c), data.map_ctr, info);'])
            
            title([d_type{i_d} ' ' num2str(i_c)])
            
            saveas(f, ['C:\Users\westerja\Dropbox\rfmapping\' ...
                d_type{i_d} num2str(i_c) '.png'])
            close all
            
        end
        
    end
end
end