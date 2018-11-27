function data = D_D_MUA( data, varargin )

data.d_dmua.sdc = 4;
data.d_dmua.cnv = true;
data.d_dmua.deci = 1;
data.d_dmua.kType = 'psp';
data.d_dmua.kWid = 20;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'sdc'}
            data.d_dmua.sdc = varargin{varStrInd(iv)+1};
        case {'cnv'}
            data.d_dmua.cnv = varargin{varStrInd(iv)+1};
        case {'deci'}
            data.d_dmua.deci = varargin{varStrInd(iv)+1};
        case {'kernel'}
            data.d_dmua.kType = varargin{varStrInd(iv)+1};
        case {'width'}
            data.d_dmua.kWid = varargin{varStrInd(iv)+1};
    end
end

for i_ch = 1 : size( data.data, 1)
    
    muadMean = mean( data.data(i_ch,:) );
    muadStd = std( data.data(i_ch,:) );
    
    muad = data.data(i_ch,:) >= ( muadMean + ( data.d_dmua.sdc * muadStd ) );
    
    muadInd1 = floor( find( muad ) / data.d_dmua.deci );
    muadInd2 = unique( muadInd1 );
    
    t_mua = zeros( 1, ceil( length( data.data(i_ch,:) ) / data.d_dmua.deci ) );
    
    if muadInd2( 1 ) == 0
        
        muadInd2 = muadInd2( 2 : end );
        
    end
    
    t_mua( muadInd2 ) = 1;
    
    if data.d_dmua.cnv == true
        
        t_mua = H_CNV( t_mua, ...
            G_KRNL(data.d_dmua.kType, ...
            data.d_dmua.kWid * ...
            (data.fs/1000)));
        
    end
    
    data.dmua(i_ch,:) = t_mua; clear t_mua

end
end