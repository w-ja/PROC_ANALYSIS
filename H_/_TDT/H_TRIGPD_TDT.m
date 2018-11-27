function data = H_TRIGPD_TDT(data, varargin)

pd = 2;
method = 0;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-pd','pd'}
            pd = varargin{varStrInd(iv)+1};
        case {'-m','method'}
            pd = varargin{varStrInd(iv)+1};
    end
end

switch pd
    case 1
        switch method
            case 0
                data.pd_time = data.pd_vec_time(data.pd_1 > std(data.pd_1)*7.5);
            case 1
                data.pd_time = H_FINDPD(data.pd_1, data.pd_vec_time);
        end
    case 2
        switch method
            case 0
                data.pd_time = data.pd_vec_time(data.pd_2 > std(data.pd_2)*7.5);
            case 1
                data.pd_time = H_FINDPD(data.pd_2, data.pd_vec_time);
        end
end

data.evt.pd.time = data.evt.time;
for i_task = 1 : length(data.evt.code)
    
     if data.evt.code(i_task) == 2651
         
        t_t = data.evt.time(i_task);
        
        pd_diff = data.pd_time - t_t;
        pd_diff(pd_diff > 100) = NaN;
        pd_diff(pd_diff < -100) = NaN;
        
        if any(~isnan(pd_diff))
            t_idx = find(data.pd_time(find(~isnan(pd_diff),1)) == data.pd_vec_time,1);
            data.evt.pd.time(i_task) = data.pd_vec_time(t_idx);
        end
        
        %if isempty(t_idx)
        %    
        %    fprintf('Could not find exact index /n')
        %    
        %    t_idx = H_CLOSEST(data.pd_time(find(~isnan(pd_diff),1)), ...
        %        data.pd_vec_time);
        %end
        
    end
end

data.evt.pd.time = round(data.evt.pd.time);

end