function P_RTCDF_VS(f, ax, data, info)

fprintf('\n Begin: Plotting RT Histogram. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

h = cdfplot(data.trial_by.rt(data.trial_by.correct==1));
set(h, 'color', 'k', 'linewidth', 2);
hold on;

for i = 1 : numel(data.trial_stat.uniq_targ_col)
    
    h = cdfplot(data.trial_by.rt(data.trial_by.correct==1 & ...
        data.trial_by.targ_col == data.trial_stat.uniq_targ_col(i)));
    set(h, 'color', G_COL(data.trial_stat.uniq_targ_col(i)), 'linewidth', 2);
    
end

grid off

ylabel('CDF');
title('RT CDF')
xlabel( 'RT (ms)' );
axis square; box off;
set(gca, 'fontsize', 12, 'linewidth', 2)

end