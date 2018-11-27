function P_RFSURF(f, ax, data_map, info)

fprintf('\n Begin: Plotting RF Surface. \n')

NOP=1000;
THETA=linspace(0,2*pi,NOP);
CENTER = size(data_map,1)/2;

SZ = size(data_map,1);

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

for i_ch = 1 : size(data_map, 3)
    
    h = imagesc(imgaussfilt(data_map(:,:,i_ch), 2));
    
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

cb = colorbar;

ylabel(cb, 'Magnitude');

map = imgaussfilt(data_map);
[m_y, m_x] = find(map == max(map(:)),1);

[m_t, m_r] = cart2pol(m_x - SZ/2, m_y - SZ/2);
m_t = rad2deg(m_t);
m_r = m_r / 10;

%scatter(m_x, m_y, 'marker', 'o', 'linewidth', 3, 'markerfacecolor', 'g', ...
%    'markeredgecolor', 'g')

title(['RF CENTER: THETA = ' num2str(m_t) ', RHO = ' num2str(m_r)])

end