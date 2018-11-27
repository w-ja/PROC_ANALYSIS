function P_RFCOUNT(f, ax, data_map, data_ctr, info)

fprintf('\n Begin: Plotting RF Surface. \n')

NOP=1000;
THETA=linspace(0,2*pi,NOP);
CENTER = size(data_map,1)/2;

SZ = size(data_map,1);

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

for i_ch = 1 : size( data_map, 3)
    
    h = imagesc(imgaussfilt(data_ctr(:,:), 2));
    
    ylabel('Horizontal (dva)');
    xlabel('Vertical (dva)');
    set(ax, 'xtick', [0:50:150, 200, 251:50:401], 'xticklabel', ...
        {'-20', '', '-10', '', '0', '', '10', '', '20'}, ...
        'ytick', [0:50:150, 200, 251:50:401], 'yticklabel', ...
        {'-20', '', '-10', '', '0', '', '10', '', '20'})
        
    
end

for i_r = 50:50:floor(SZ/2)
 
    RHO=ones(1,NOP)*i_r;
    [X,Y] = pol2cart(THETA,RHO);
    X=X+CENTER;
    Y=Y+CENTER;
    plot(X,Y, 'linewidth', .5, 'linestyle', '--', 'color', [.4 .4 .4])
    
end

plot([0 SZ], [0 SZ], 'color', [.4 .4 .4], 'linewidth', .5, 'linestyle', '--')
plot([0 SZ], [SZ 0], 'color', [.4 .4 .4], 'linewidth', .5, 'linestyle', '--')

yarg = flipud(colormap('gray'));
colormap(yarg)
axis square
box on

vm = vline(SZ/2);
hm = hline(SZ/2);

set(vm, 'color', [.4 .4 .4], 'linewidth', .5, 'linestyle', '--')
set(hm, 'color', [.4 .4 .4], 'linewidth', .5, 'linestyle', '--')

set(ax, 'ylim', [0 SZ], 'xlim', [0 SZ], 'linewidth', 1)

title('Sampling Distribution');

cb = colorbar;

ylabel(cb, 'Samples (n)');

end