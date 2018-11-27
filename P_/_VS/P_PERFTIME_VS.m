function P_PERFTIME_VS(f, ax, data, info)

fprintf('\n Begin: Plotting Performance over Time. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

for i = 1 : numel(data.trial_by.correct)
    
    if i == 1 
        b4 = 1;
    else
        
        if (data.trial_by.targ_col(i) == data.trial_by.targ_col(i-1) && ...
                data.trial_by.dist_col(i) == data.trial_by.dist_col(i-1)) || ...
                (data.trial_by.targ_col(i) == data.trial_by.dist_col(i) && ...
                data.trial_by.dist_col(i) == data.trial_by.dist_col(i-1)) || ...
                (data.trial_by.targ_col(i-1) == data.trial_by.dist_col(i) && ...
                data.trial_by.dist_col(i) == data.trial_by.dist_col(i-1))
        else
            
            shadedplot([b4, i],[0, 0], [100, 100], G_COL(data.trial_by.targ_col(i-1)));
            b4 = i;
            
        end
    end
end

pad = 50;
cor = [nan(pad,1); data.trial_by.correct; nan(pad,1)];

for i = pad+1 : numel(data.trial_by.correct)
    
    cortim(i-pad) = nansum(cor(i-pad:i+pad)) / ...
        sum(~isnan(cor(i-pad:i+pad))) * 100;
    
end

plot(cortim, 'linewidth', 2, 'color', 'k');
hold on;
cormem = cortim;
clear cortim
pad = 100;

cor = [nan(pad,1); data.trial_by.correct; nan(pad,1)];
col = [nan(pad,1); data.trial_by.targ_col; nan(pad,1)];
for j = 1 : numel(data.trial_stat.uniq_targ_col)
    for i = pad+1 : numel(data.trial_by.correct)
        
        cortim(i-pad) = nansum(cor(i-pad:i+pad) == 1 & ...
            col(i-pad:i+pad) == ...
            data.trial_stat.uniq_targ_col(j)) / ...
            sum(~isnan(cor(i-pad:i+pad)) & col(i-pad:i+pad) == ...
            data.trial_stat.uniq_targ_col(j)) * 100;
        
    end
    plot(cortim, 'linewidth', 2, 'color', G_COL(data.trial_stat.uniq_targ_col(j)));
    cormem = cat(2,cormem, cortim);
    if j ~= numel(data.trial_stat.uniq_targ_col)
        clear cortim
    end
end

set(gca, 'linewidth', 2, 'fontsize', 12, 'xlim', [1 numel(cortim)], ...
    'ylim', [min(cormem - 10) 100])
axis square
box off
title('% Correct over Time');
ylabel('% Correct');
xlabel('Trial');

end