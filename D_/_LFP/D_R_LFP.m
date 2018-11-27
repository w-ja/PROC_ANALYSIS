function data = D_R_LFP(data, varargin)

data.d_lfpcorr.win = 512;
data.d_lfpcorr.sfl = 0;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'win'}
            data.d_lfpcorr.win = varargin{varStrInd(iv)+1};
        case {'sfl'}
            data.d_lfpcorr.sfl = varargin{varStrInd(iv)+1};
    end
end

nChan = size( data.lfp, 1 );

for i_ch = 1 : nChan
    
    for j_ch = 1 : nChan
        
        if isnan( data.lfp( i_ch, 1 ) ) || isnan( data.lfp( j_ch, 1 ) )
            
            data.lfpcorr( i_ch, j_ch ) = NaN;
            
            continue
            
        end
        
        nWin = floor(length( data.lfp ) / data.d_lfpcorr.win );
        
        for i_win = 1 : nWin
            
            itWin = ( data.d_lfpcorr.win * i_win - ...
                ( data.d_lfpcorr.win-1 ) ) : ( data.d_lfpcorr.win * i_win );
            
            tempCCv = corrcoef( data.lfp( i_ch, itWin ), ...
                data.lfp( j_ch, itWin ) );
            tempCC( i_win ) = tempCCv( 2, 1 );
            
        end
        
        data.lfpcorr( i_ch, j_ch ) = mean( tempCC );
        
    end
end
end