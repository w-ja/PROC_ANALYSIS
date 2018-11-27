function evt = H_DETB_TDT(evt)

evt.block = zeros(length(evt.vec_task),1);
ctr_block = 1;
ctr_task = 1;

uniq_task = unique(evt.vec_task);
itt_task = zeros(numel(uniq_task),1);

for i = 1 : length(evt.vec_task)
    
    if i > 1
        if ~strcmp(evt.vec_task{i}, evt.vec_task{i-1})
            ctr_block = ctr_block + 1;
            ctr_task = ctr_task + 1;
            evt.no_task{ctr_task} = evt.vec_task{i};
            evt.no_block(ctr_task) = ctr_block;
            itt_task(cell2mat(cellfun(@strcmp, uniq_task, repmat(evt.vec_task(i), ...
                numel(uniq_task), 1), 'uniformoutput', false))) = ...
                itt_task(cell2mat(cellfun(@strcmp, uniq_task, repmat(evt.vec_task(i), ...
                numel(uniq_task), 1), 'uniformoutput', false))) + 1;
            
        end
        
    elseif i == 1
        itt_task(cell2mat(cellfun(@strcmp, uniq_task, repmat(evt.vec_task(i), ...
            numel(uniq_task), 1), 'uniformoutput', false))) = ...
            itt_task(cell2mat(cellfun(@strcmp, uniq_task, repmat(evt.vec_task(i), ...
            numel(uniq_task), 1), 'uniformoutput', false))) + 1;
        evt.no_task{ctr_task} = evt.vec_task{i};
        evt.no_block(ctr_task) = 1;
    end
    
    evt.block_overall(i) = ctr_block;
    evt.block_bytask(i) = itt_task(cell2mat(cellfun(@strcmp, uniq_task, repmat(evt.vec_task(i), ...
                numel(uniq_task), 1), 'uniformoutput', false)));
    
    
end
end