function P_MUALINE(f, ax, data, info)

fprintf('\n Begin: Plotting EVP Line. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;
   
t_min = min(min(data.mua_mean));
t_max = max(max(data.mua_mean));
    
sep = t_max - t_min;

for i_ch = 1 : size( data.mua_mean, 1)
    
    plot(data.mua_mean(i_ch,:) - (sep*(i_ch-1)), ...
        'linewidth', 2, 'color', 'k')
    
end

vl = vline(H_T2S(abs(data.flash.t_pre)+1,data.mua_fs));

set(gca, 'xlim', [1, length(data.mua_mean(1,:))], ...
    'ylim', [-sep*(i_ch), 0 + sep], ...
    'linewidth', 2, ...
    'ytick', [])

box off;

xlabel('Time (ms)');
ylabel('Lower<-Cx (Depth)->Upper');
title('Evoked AMUA');

fprintf('\n End: Plotting EVP Line. \n')

end