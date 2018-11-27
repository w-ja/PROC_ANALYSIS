function info = H_DETTOCX(data, info, params)

if ~params.quick
	t_dat = data.amua_trial;
else
	t_dat = data.lfp_trial;
end

in_cx = nan(size(t_dat,1),1);

for i_ch = 1 : size(t_dat,1)

	if ttest2(nanmean(abs(t_dat(i_ch, H_T2S(abs(data.trial.t_pre)+51, data.fs) : ...
		H_T2S(abs(data.trial.t_pre)+151, data.fs),:)),2), nanmean(abs(t_dat(i_ch, ...
		1 : H_T2S(abs(data.trial.t_pre), data.fs),:)),2))

		in_cx(i_ch) = true;
	else
		in_cx(i_ch) = false;
	end

end

info.in_cx = in_cx;

end