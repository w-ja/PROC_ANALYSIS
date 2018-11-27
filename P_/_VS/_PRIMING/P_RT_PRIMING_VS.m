function P_RT_PRIMING_VS(f, ax, data, info, varargin)

fprintf('\n Begin: Plotting Priming RTs. \n')

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

plotmean = false;
plotsem = false;
plotci = true;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-m','mean'}
            plotmean = varargin{varStrInd(iv)+1};
        case {'-s','sem'}
            plotmean = varargin{varStrInd(iv)+1};
        case {'-c','ci'}
            plotmean = varargin{varStrInd(iv)+1};
    end
end

temp_mean_dat       = [];
temp_med_dat        = [];
temp_sem_dat        = [];
temp_ci_dat         = [];

temp_mean_dat_err   = [];
temp_med_dat_err    = [];
temp_sem_dat_err    = [];
temp_ci_dat_err     = [];

temp_cor_dat        = [];

for pitt = 1 : size(data.trial_stat.prime, 2)
    
    temp_mean_dat   = cat(1,temp_mean_dat,(nanmean(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==1))));

    temp_med_dat    = cat(1,temp_med_dat,(nanmedian(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==1))));

    temp_sem_dat    = cat(1,temp_sem_dat,2*(nanstd(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==1)) / ...
                        sqrt(numel(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==1)))));

    temp_ci_dat     = cat(1,temp_ci_dat, ci(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==1)));
    


    temp_mean_dat_err   = cat(1,temp_mean_dat_err,(nanmean(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==0))));

    temp_med_dat_err    = cat(1,temp_med_dat_err,(nanmedian(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==0))));

    temp_sem_dat_err    = cat(1,temp_sem_dat_err,(nanstd(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==0)) / ...
                            sqrt(numel(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==0)))));

    temp_ci_dat_err     = cat(1,temp_ci_dat_err, ci(data.trial_stat.prime(pitt).rt(data.trial_stat.prime(pitt).correct==0)));

    
    
    temp_cor_dat    = cat(1,temp_cor_dat,sum(data.trial_stat.prime(pitt).correct) / numel(data.trial_stat.prime(pitt).correct));
    
end

if plotmean == true
    h_mean = plot(temp_mean_dat, 'color', 'k', 'linewidth', 3, ...
    'linestyle', '--');
end

h_med = plot(temp_med_dat, 'color', 'k', 'linewidth', 3, ...
    'marker', 'diamond', 'markersize', 10, ...
    'markerfacecolor', 'k');

title(['Priming of Popout RTs'])
ylabel('RT (ms)'); xlabel( 'Trial Since Color Switch' );
axis square; box off;
set(gca, 'fontsize', 12, 'linewidth', 2, ...
    'xlim', [0 length(data.trial_stat.prime)+1] )

if plotsem == 1
    
    if plotmean == 1
        for pitt = 1 : length(data.trial_stat.prime)
            plot(ones(length(temp_mean_dat(pitt) - temp_sem_dat(pitt):.001:...
                temp_mean_dat(pitt) + temp_sem_dat(i) ),1)*pitt,...
                temp_mean_dat(pitt) - temp_sem_dat(pitt):.001:...
                temp_mean_dat(pitt) + temp_sem_dat(i), ...
                'color', 'k', 'linestyle', ':', 'linewidth', 2)
            
        end
    end
        
    for pitt = 1 : length(data.trial_stat.prime)
        plot(ones(length(temp_med_dat(pitt) - temp_sem_dat(pitt):.001:...
            temp_med_dat(pitt) + temp_sem_dat(i) ),1)*pitt,...
            temp_med_dat(pitt) - temp_sem_dat(pitt):.001:...
            temp_med_dat(pitt) + temp_sem_dat(i), ...
            'color', 'k', 'linestyle', ':', 'linewidth', 2)
    end
end

if plotci == 1
    if plotmean == 1
        fill([ 1:size(data.trial_stat.prime,2), fliplr(1:size(data.trial_stat.prime,2))], ...
            [(temp_mean_dat + temp_ci_dat)', ...
            fliplr((temp_mean_dat - temp_ci_dat)') ], ...
            'k', 'facealpha', .25, 'linewidth', 2, ...
            'linestyle', '--')
    end
    
    fill([ 1:size(data.trial_stat.prime,2), fliplr(1:size(data.trial_stat.prime,2))], ...
        [(temp_med_dat + temp_ci_dat)', ...
        fliplr((temp_med_dat - temp_ci_dat)') ], ...
        'k', 'facealpha', .25, 'linewidth', 2)
end

if plotmean == 1
    legend([ h_mean, h_med ], 'Mean', 'Median')
else
    legend(h_med, 'Median')
end
end

function [ci_c] = ci(x)

    SEM = std(x)/sqrt(length(x));          
    ts = tinv([0.975],length(x)-1);      
    ci_c = ts*SEM; 

end
