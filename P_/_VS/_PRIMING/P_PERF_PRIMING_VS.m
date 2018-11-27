function P_PERF_PRIMING_VS(f, ax, data, info)

temp_cor_dat = [];

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

for pitt = 1 : size(data.trial_stat.prime, 2)

    temp_cor_dat = cat(1,temp_cor_dat,sum(data.trial_stat.prime(pitt).correct) / ...
        numel(data.trial_stat.prime(pitt).correct));
    
end

h_cor = plot(temp_cor_dat, 'color', 'k', 'linewidth', 3, ...
    'marker', 'diamond', 'markersize', 10, ...
    'markerfacecolor', 'k');

title(['Priming of Popout Success Rate'])
ylabel('Success Rate'); xlabel( 'Trial Since Color Switch' );
axis square; box off;
set(gca, 'fontsize', 12, 'linewidth', 2, ...
    'xlim', [0 length(data.trial_stat.prime)+1], 'ylim', [.3 1] )

temp_an = annotation('textbox', 'string', ...
    ['CHANCE = ' num2str(1/mode(data.trial_by.set_n))]);

set(temp_an, 'linestyle', 'none', 'fontsize', 12, 'pos', [.5 .125 .25 .031], ...
    'fontweight', 'bold', 'horizontalalignment', 'center')

end