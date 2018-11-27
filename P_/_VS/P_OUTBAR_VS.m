function P_OUTBAR_VS(f, ax, data, info)

fprintf('\n Begin: Plotting Outcome Bars. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

ctr = 1;

for i = 1 : numel(data.trial_stat.uniq_outcome)
    bar(ctr, data.trial_stat.prop_outcome(i), 'facecolor', 'w', 'linewidth', 2) 
    ctr = ctr+1;
end

ctr = ctr + 1;

for j = 1 : numel(data.trial_stat.uniq_targ_col)
    
    for i = 1 : numel(data.trial_stat.uniq_outcome)
        bar(ctr, data.trial_stat.prop_outcome_by_col(j,i), ...
            'facecolor', G_COL(data.trial_stat.uniq_targ_col(j)), 'linewidth', 2)
        ctr = ctr+1;
    end
    ctr = ctr + 1;
end
    
set(gca, 'linewidth', 2, 'fontsize', 6, 'xlim', [0 ctr-1], ...
    'xtick', 1:numel(data.trial_stat.uniq_outcome), 'xticklabel', G_OUT(data.trial_stat.uniq_outcome))

xtickangle(45);

axis square
box off
title('Outcome Occurence');
ylabel('% Outcome Occured');
xlabel('Outcome');

end