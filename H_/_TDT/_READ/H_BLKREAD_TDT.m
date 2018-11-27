function [data, blk] = H_BLKREAD_TDT(vec_task, i_blk, evt, info, params)

cur_blk = vec_task & (i_blk == evt.block_bytask)';
    
blk.evt.code = evt.code(cur_blk);
blk.evt.time = evt.time(cur_blk);

blk.idx_beg = find( cur_blk, 1, 'first');
blk.idx_end = find( cur_blk, 1, 'last');

blk.t(1) = evt.time(blk.idx_beg);
blk.t(2) = evt.time(blk.idx_end);

data = H_READ_TDT(info, params, '-t', blk.t);

end