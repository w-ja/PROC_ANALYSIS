function P_RTHIST_VS(f, ax, data, info)

fprintf('\n Begin: Plotting RT Histogram. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

yyaxis left
histogram(data.trial_by.rt(data.trial_by.correct==1), 0:3:500, 'facecolor', 'w' )
hold on;

for i = 1 : numel(data.trial_stat.uniq_targ_col)
    
    histogram(data.trial_by.rt(data.trial_by.correct==1 & ...
        data.trial_by.targ_col == data.trial_stat.uniq_targ_col(i)), ...
        0:3:500, 'facecolor', G_COL(data.trial_stat.uniq_targ_col(i)) )
    
end
ylabel('Count');
set(ax, 'ycolor','k');

yyaxis right
[f, xi] = ksdensity(data.trial_by.rt(data.trial_by.correct==1));
plot(xi, f, 'linewidth', 2, 'color', 'k')

hold on;

for i = 1 : numel(data.trial_stat.uniq_targ_col)
    
    [f, xi] = ksdensity(data.trial_by.rt(data.trial_by.correct==1 & ...
        data.trial_by.targ_col == data.trial_stat.uniq_targ_col(i)));
    plot(xi, f, 'linewidth', 2, 'linestyle', '-', 'color', ...
        G_COL(data.trial_stat.uniq_targ_col(i)))
    
end

title('Distribution of RTs')
ylabel('PDF'); xlabel( 'RT (ms)' );
set(ax, 'ycolor','k');
axis square; box off;
set(gca, 'fontsize', 12, 'linewidth', 2, ...
    'xlim', [ 100 400 ])

end