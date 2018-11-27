function P_CSDLINE(f, ax, data, info)

fprintf('\n Begin: Plotting CSD Line. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;
   
t_min = min(min(data.csd_mean));
t_max = max(max(data.csd_mean));
    
sep = t_max - t_min;

for i_ch = 1 : size( data.csd_mean, 1)
    
    plot(data.csd_mean(i_ch,:) - (sep*(i_ch-1)), ...
        'linewidth', 2, 'color', 'k')
    
end

vl = vline(H_T2S(abs(data.flash.t_pre)+1,data.fs));

set(gca, 'xlim', [1, length(data.csd_mean(1,:))], ...
    'ylim', [-sep*(i_ch), 0 + sep], ...
    'linewidth', 2, ...
    'ytick', [])

box off;

xlabel('Time (ms)');
ylabel('Lower<-Cx (Depth)->Upper');
title('Evoked CSD');

fprintf('\n End: Plotting CSD Line. \n')

end