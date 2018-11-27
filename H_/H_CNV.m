function cnv = H_CNV( raw, krnl )

if ndims( raw ) == 2
    
    tmp = size( raw );
    
    for i = 1 : tmp( 1 )
        
        cnv( i, : ) = H_CNVLIST( raw( i, : ), krnl );
        
    end
    
else
    
    cnv = H_CNVLIST(l,k);
    
end
end