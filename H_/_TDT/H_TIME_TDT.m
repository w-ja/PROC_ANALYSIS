function vec_out = H_TIME_TDT(data, fs, t_start)

toRound = 1;

vec_out = 0:(size(data, 2) - 1);
vec_out = vec_out .* (1000 / fs);
vec_out = round(vec_out + t_start);

end
