unction P_RASTER(times,numtrials,triallen, varargin)

nin=nargin;

%%%%%%%%%%%%%% Plot variables %%%%%%%%%%%%%%
plotwidth=1;     % spike thickness
plotcolor='k';   % spike color
trialgap=1.5;    % distance between trials
defaultfs=1000;  % default sampling rate
showtimescale=1; % display timescale
showlabels=1;    % display x and y labels

%%%%%%%%% Code Begins %%%%%%%%%%%%
switch nin
 case 3 %no handle so plot in a separate figure
  figure;
  hresp=gca;
  fs=defaultfs;
 case 4 %handle supplied
  hresp=varargin{1};
  if (~ishandle(hresp))
    error('Invalid handle');
  end
  fs=defaultfs;
 case 5 %fs supplied
  hresp=varargin{1};
  if (~ishandle(hresp))
    error('Invalid handle');
  end
  fs = varargin{2};        
 otherwise
  error ('Invalid Arguments');
end


 % plot spikes

  trials=ceil(times/triallen);
  reltimes=mod(times,triallen);
  reltimes(~reltimes)=triallen;
  numspikes=length(times);
  xx=ones(3*numspikes,1)*nan;
  yy=ones(3*numspikes,1)*nan;

  yy(1:3:3*numspikes)=(trials-1)*trialgap;
  yy(2:3:3*numspikes)=yy(1:3:3*numspikes)+1;
  
  %scale the time axis to ms
  xx(1:3:3*numspikes)=reltimes*1000/fs;
  xx(2:3:3*numspikes)=reltimes*1000/fs;
  xlim=[1,triallen*1000/fs];

  axes(hresp);
  h=plot(xx, yy, plotcolor, 'linewidth',plotwidth);
  axis ([xlim,0,(numtrials)*1.5]);  
  
  if (showtimescale)
    set(hresp, 'ytick', [],'tickdir','out');        
  else
    set(hresp,'ytick',[],'xtick',[]);
  end
  
  if (showlabels)
    xlabel('Time(ms)');
    ylabel('Trials');
  end
  
end