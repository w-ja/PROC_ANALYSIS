function T_NONE(evt, info, params, varargin)

d_type = {'lfp', 'mua', 'hga_pwr', 'lga_pwr', ...
    'bet_pwr', 'alp_pwr', 'the_pwr', 'del_pwr'};

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'start',}
            t_start = varargin{varStrInd(iv)+1};
        case {'end'}
            t_end = varargin{varStrInd(iv)+1};
    end
end

data = H_READ_TDT(info, params);

end