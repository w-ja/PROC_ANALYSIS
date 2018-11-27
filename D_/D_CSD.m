function data = D_CSD( data, info, varargin )

data.d_csd.cndt = 0.0004;
data.d_csd.deci = floor(data.data_fs/1000);

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'cndt'}
            data.d_csd.cndt = varargin{varStrInd(iv)+1};
    end
end

if data.d_csd.deci > 1
    for i = 1 : size(data.data,1)
        t_csd(i,:) = decimate( data.data(i,:), data.d_csd.deci );
    end
else
    t_csd = data.data;
end

csd_in = t_csd .* 1000; % mV to uV
spc = info.ch_spc / 1000; % um to mm

nChan = size( csd_in, 1 ) * spc;

dChan = spc : spc : nChan;

nE = length( dChan );
d = mean( diff( dChan ) );

t_csd = [];

for i = 1 : nE - 2
    for j = 1 : nE
        
        if i == (j - 1)
            
            t_csd( i, j ) = -2 / d^2;
            
        elseif abs( i - j + 1) == 1
            
            t_csd( i, j ) = 1 / d^2;
            
        else
            
            t_csd( i, j ) = 0;
            
        end
    end
end

data.csd = -data.d_csd.cndt * t_csd * csd_in;

data.csd = data.csd .* 1000; % uA/mm3 to nA/mm3

data.csd = [ nan( 1, length( data.csd ) ); ...
    data.csd; nan( 1, length( data.csd ) )  ];

data.csd_fs = data.data_fs / data.d_csd.deci;
data.csd_time = 0:(size(data.data, 2) - 1);
data.csd_time = data.csd_time .* (1000 / data.csd_fs);
data.csd_time = round(data.csd_time + data.t_lims(1));

end