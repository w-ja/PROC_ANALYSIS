function P_PSDDIFF(f, ax, data, info)

fprintf('\n Begin: Plotting PSD Difference. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

imagesc(H_SMOOTHD1(data.psd_norm))

colorbar;

box off;

xlabel('f (Hz)');
ylabel('Lower<-Cx (Depth)->Upper');
title('PSD Difference Across Depth');

fprintf('\n End: Plotting PSD Difference. \n')

end