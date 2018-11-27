function P_LFPCORR(f, ax, data, info)

fprintf('\n Begin: Plotting PSD Difference. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

imagesc(flipud(H_SMOOTHD1(data.lfpcorr)))

colorbar;

box off;

xlabel('Upper<-Cx (Depth)->Lower');
ylabel('Lower<-Cx (Depth)->Upper');
title('Channelwise LFP Correlations');

fprintf('\n End: Plotting PSD Difference. \n')

end