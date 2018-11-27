function data = T_CODING_RFMAP(data)

t_ctr = 0;

last_trial = find(data.events_code == 1512,1,'last');

corrupt = false;

for i_evt = 2 : length(data.events_code) - 1
    
    if corrupt && data.events_code(i_evt) ~= 1512
        continue
    end
    
    if data.events_code(i_evt) == 1512
        if i_evt == last_trial
            break
        end
        t_ctr = t_ctr + 1;
        s_ctr = 0;
        h_ctr = 0;
        corrupt = false;
        data.trial_info{t_ctr}.start = data.events_on(i_evt);
        data.trial_info{t_ctr}.outcome = 0;
    end
    
    if ~exist('s_ctr', 'var')
        continue
    end
    
    if data.events_code(i_evt) == 2660
        data.trial_info{t_ctr}.fix = data.events_on(i_evt);
    end
    
    if data.events_code(i_evt) == 2651
        s_ctr = s_ctr + 1;
        data.trial_info{t_ctr}.stim(s_ctr) = data.events_on(i_evt);
    end
    
    if data.events_code(i_evt) == 2727
        data.trial_info{t_ctr}.reward = data.events_on(i_evt);
        data.trial_info{t_ctr}.outcome = 1;
    end
    
    if data.events_code(i_evt) == 2998
        in_pgs = true;
        p_ctr = 1;
        while in_pgs
            
            if data.events_code(i_evt+p_ctr) <= 3000
                in_pgs = false;
                
            else
                t_val = num2str(data.events_code(i_evt+p_ctr));
                t_val = str2double(t_val(2));
                data.trial_info{t_ctr}.page(p_ctr) = t_val - 2;
                p_ctr = p_ctr + 1;
                
            end
        end
    end
    
    if (data.events_code(i_evt) <= 1000 & ...
            (data.events_code(i_evt) >= 800)) & ...
            (data.events_code(i_evt-1) > 3000 & ...
            data.events_code(i_evt-1) < 4000)
        h_ctr = h_ctr + 1;
        g_ctr = 0;
    end
    
    if data.events_code(i_evt) == 3000 & ...
            data.events_code(i_evt+1) > 799 & data.events_code(i_evt+1) < 1001
        
        h_ctr = h_ctr + 1;
        g_ctr = 0;
        
    end
        
    
    if data.events_code(i_evt) > 799 & data.events_code(i_evt) < 1001
        
        g_ctr = g_ctr + 1;
        
        data.trial_info{t_ctr}.stim_info{h_ctr}.ecc(g_ctr) = ...
            (data.events_code(i_evt) - 800) / 10;
        
        if data.trial_info{t_ctr}.stim_info{h_ctr}.ecc(g_ctr) < 0
            corrupt = true;
        end
        
        data.trial_info{t_ctr}.stim_info{h_ctr}.ang(g_ctr) = ...
            data.events_code(i_evt+1) - 5000;
        
        if data.trial_info{t_ctr}.stim_info{h_ctr}.ang(g_ctr) < 0
            corrupt = true;
        end
        
        data.trial_info{t_ctr}.stim_info{h_ctr}.size(g_ctr) = ...
            (data.events_code(i_evt+2) - 6000) / 100;
        
        if data.trial_info{t_ctr}.stim_info{h_ctr}.size(g_ctr) < 0
            corrupt = true;
        end
        
        data.trial_info{t_ctr}.stim_info{h_ctr}.ring(g_ctr) = ...
            data.events_code(i_evt+3) - 7000;
        
        if data.trial_info{t_ctr}.stim_info{h_ctr}.ring(g_ctr) < 0
            corrupt = true;
        end
        
        data.trial_info{t_ctr}.stim_info{h_ctr}.scale(g_ctr) = ...
            (data.events_code(i_evt+4) - 8000) / 100;
        
        if data.trial_info{t_ctr}.stim_info{h_ctr}.scale(g_ctr) < 0 || ...
               data.trial_info{t_ctr}.stim_info{h_ctr}.scale(g_ctr) > 10 
            corrupt = true;
        end
        
    end
    
    if corrupt
       
        data.trial_info{t_ctr} = struct();
        t_ctr = t_ctr - 1;
        continue
        
    end
    
end

data.trial_by.trial = [];
data.trial_by.pres = [];
data.trial_by.stim = [];
data.trial_by.ecc = [];
data.trial_by.ang = [];
data.trial_by.size = [];
data.trial_by.ring = [];
data.trial_by.scale = [];

t_ctr = 0;

for i_trial = 1 : length(data.trial_info)
    
    t_ctr = t_ctr + 1;
    
    if data.trial_info{i_trial}.outcome == 1
        
        for i_pres = 1 : length(data.trial_info{i_trial}.stim)
            
            data.trial_by.trial = cat(1, data.trial_by.trial, t_ctr);
            data.trial_by.pres = cat(1, data.trial_by.pres, i_pres);
            data.trial_by.stim = cat(1, data.trial_by.stim, ...
                data.trial_info{i_trial}.stim(i_pres));
            
            data.trial_by.ecc = cat(1, data.trial_by.ecc, ...
                {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.ecc});
            data.trial_by.ang = cat(1, data.trial_by.ang, ...
                {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.ang});
            data.trial_by.size = cat(1, data.trial_by.size, ...
                {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.size});
            data.trial_by.ring = cat(1, data.trial_by.ring, ...
                {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.ring});
            data.trial_by.scale = cat(1, data.trial_by.scale, ...
                {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.scale});
            
        end
        
    elseif data.trial_info{i_trial}.outcome == 0
        
        if isfield(data.trial_info{i_trial}, 'stim')
            
            if length(data.trial_info{i_trial}.stim) > 1
                
                for i_pres = 1 : length(data.trial_info{i_trial}.stim) - 1
                    
                    data.trial_by.trial = cat(1, data.trial_by.trial, t_ctr);
                    data.trial_by.pres = cat(1, data.trial_by.pres, i_pres);
                    data.trial_by.stim = cat(1, data.trial_by.stim, ...
                        data.trial_info{i_trial}.stim(i_pres));
                    
                    data.trial_by.ecc = cat(1, data.trial_by.ecc, ...
                        {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.ecc});
                    data.trial_by.ang = cat(1, data.trial_by.ang, ...
                        {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.ang});
                    data.trial_by.size = cat(1, data.trial_by.size, ...
                        {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.size});
                    data.trial_by.ring = cat(1, data.trial_by.ring, ...
                        {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.ring});
                    data.trial_by.scale = cat(1, data.trial_by.scale, ...
                        {data.trial_info{i_trial}.stim_info{data.trial_info{i_trial}.page(i_pres)}.scale});
                    
                end
            end
        end
    end
end
end