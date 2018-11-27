function vec_task = H_DETT_TDT(evt_code)

vec_task = cell(length(evt_code), 1);
task = 'placeholder';

for i = 1 : length(evt_code)
    
    if evt_code(i) == 1512
        task = 'rfmap';
    elseif evt_code(i) == 1513 || evt_code(i) == 1514
        task = 'prime';
    elseif evt_code(i) == 1505
        task = 'flash';
    elseif evt_code(i) == 1502
        task = 'memg';
    end
    
    vec_task{i} = task;
    
    if i > 1
        if ~strcmp(task, 'placeholder') && ...
                strcmp(vec_task{i-1}, 'placeholder')
            
            for j = 1 : i-1
                
                if strcmp(vec_task{i-j}, 'placeholder')
                    
                    vec_task{i-j} = task;
                    
                end
            end
        end
    end
end
end