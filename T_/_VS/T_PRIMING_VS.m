function T_PRIMING_VS(evt, info, params, varargin)

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
    end
end

vect = strcmp(evt.vec_task, 'prime');
n_blk = max(evt.block_bytask(vect));

if params.training || params.bhv_only
    bhv_only = true;
else
    bhv_only = false;
end

for i_blk = 1 : n_blk

    cur_blk = vect & (i_blk == evt.block_bytask)';
    
    blk.evt.code = evt.code(cur_blk);
    blk.evt.time = evt.time(cur_blk);
    
    blk.idx_beg = find( cur_blk, 1, 'first');
    blk.idx_end = find( cur_blk, 1, 'last');
    
    blk.t(1) = evt.time(blk.idx_beg) - 1000;
    blk.t(2) = evt.time(blk.idx_end) + 1000;
    
    data = H_READ_TDT(info, params, '-t', blk.t, '-b', bhv_only);
    data = T_CODING_VS(data);

    

end
end