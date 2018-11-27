function dir_cont = H_DIRD(dir_in,search_exp)

dir_str = dir(dir_in);
dir_cont = {};

for itt_str = 1 : length(dir_str)
    
    if ~dir_str(itt_str).isdir && ...
            ~isempty(regexp(dir_str(itt_str).name,search_exp,'match'))
        
        dir_cont{length(dir_cont) + 1} = [ dir_in '/' dir_str(itt_str).name];
        
    elseif dir_str(itt_str).isdir && ~strcmp(dir_str(itt_str).name,'.') && ...
            ~strcmp(dir_str(itt_str).name,'..')
        
        file_name = fullfile(dir_in,dir_str(itt_str).name);
        temp_dir_cont = H_DIRD(file_name,search_exp);
        
        if ~isempty(temp_dir_cont)
            
            dir_cont((length(dir_cont)+1):(length(dir_cont)+length(temp_dir_cont))) = ...
                temp_dir_cont;
        end
    end
end
end