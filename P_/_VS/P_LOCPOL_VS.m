function P_LOCPOL_VS(f, ax, data, info)

fprintf('\n Begin: Plotting Location Performance. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

polarplot(deg2rad([data.trial_stat.uniq_targ_loc; ...
    data.trial_stat.uniq_targ_loc(1)]), ...
	[data.trial_stat.pct_cor_targ_loc ...
    data.trial_stat.pct_cor_targ_loc(1)], ...
    'linewidth', 2, 'color', 'k')

hold on

for i = 1 : numel(data.trial_stat.uniq_targ_col)

    polarplot(deg2rad([data.trial_stat.uniq_targ_loc; ...
        data.trial_stat.uniq_targ_loc(1)]), ...
        [data.trial_stat.pct_cor_targ_loc_by_col(i,:) ...
        data.trial_stat.pct_cor_targ_loc_by_col(i,1)], ...
        'linewidth', 2, 'color', G_COL(data.trial_stat.uniq_targ_col(i)))
    
end

set(gca, 'thetaticklabel', [], 'thetagrid', 'off', ...
    'linewidth', 2);

title('% Correct By Location');

end