function P_CSD2D(f, ax, data_in, data, info)

fprintf('\n Begin: Plotting 2D. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

%for i = 1 : size(data_in, 1)
%    t_csd(i,:) = data_in(i,:) - ...
%        nanmean(data_in(i,1:H_T2S(data.flash.t_pre, data.lfp_fs)));
%end

t_csd = data_in;

imagesc(H_SMOOTHD1(t_csd))

vl = vline(H_T2S(abs(data.flash.t_pre)+1,data.lfp_fs));

tej = fliplr(colormap('jet'));
colormap(tej);

csd_prc = prctile(t_csd, [5 95], 2);

csd_min_5 = min(csd_prc(1,:));
csd_max_5 = max(csd_prc(2,:));

csd_lim = max(abs([csd_min_5, csd_max_5]));

caxis([ -csd_lim, csd_lim]);

colorbar;

box off;

xlabel('Time (ms)');
ylabel('Lower<-Cx (Depth)-> Upper');

fprintf('\n End: Plotting 2D. \n')

end