function [idx, val, diff] = H_CLOSEST(val_in, vec_in)

idx = nan(length(val_in), 1);

if nargout > 1
	val = nan(length(val_in), 1);
	if nargout > 2
		diff = nan(length(val_in), 1);
	end
end

for i_val = 1 : length(val_in)

    t_val = abs(val_in-vec_in);
    [~, idx(i_val)] = min(t_val);

    if nargout > 1
    
    	val(i_val) = vec_in(idx(i_val));

    end

    if nargout == 3
    
    	diff(i_val) = abs(val(i_val) - val_in(i_val));

	end
    
end

end