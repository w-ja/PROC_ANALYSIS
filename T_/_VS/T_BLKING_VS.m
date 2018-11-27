function data = T_BLKING_VS(data)

RT      = data.trial_by.rt;
CRCT    = data.trial_by.correct;
SC      = data.trial_by.targ_col;
DC      = data.trial_by.dist_col;
LOC_T   = data.trial_by.targ_loc;
LOC_E   = data.trial_by.ecc;
SET_N   = data.trial_by.set_n;
CACH    = data.trial_by.catch;

data.trial_by.block     = NaN(numel(SC),1);
data.trial_by.block_pres = NaN(numel(SC),1);
data.trial_by.block_ctr = NaN(numel(SC),1);
data.trial_by.change_block = NaN(numel(SC),1);
data.trial_by.change_trial = NaN(numel(SC),1);

for col = 1:numel(SC)
    
    if col == 1
        data.trial_by.block(col)            = 1;
        data.trial_by.block_pres(col)       = 1;
        data.trial_by.block_ctr_it          = 1;
        data.trial_by.block_ctr(col)        = 0;
        data.trial_by.change_block(col)    	= 0;
        data.trial_by.change_trial(col)     = 0;
    else
        
        sc      = SC(col);
        dc      = DC(col);
        
        if (sc_1 == sc && dc_1 == dc) || (sc == dc && dc == dc_1) || (sc_1 == dc && dc == dc_1)
            data.trial_by.block(col)            = BLK_1;
            data.trial_by.block_pres(col)       = NIN_BLK_1+1;
            data.trial_by.block_ctr_it          = data.trial_by.block_ctr_it+1;
            data.trial_by.block_ctr(col)        = 0;
            data.trial_by.change_block(col)     = TOC_BLK_1;
            data.trial_by.change_trial(col)     = 0;
        else
            data.trial_by.block(col)            = BLK_1+1;
            data.trial_by.block_pres(col)       = 1;
            data.trial_by.block_ctr(col)        = 0;
            BLK_0                               = data.trial_by.block_ctr == 0;
            data.trial_by.block_ctr(BLK_0)      = data.trial_by.block_ctr_it;
            data.trial_by.block_ctr_it          = 1;
            switch CACH(col-1)
                case false
                    if sc_1 ~= sc && dc_1 ~= dc
                        data.trial_by.change_block(col)    = 3;
                        data.trial_by.change_trial(col)    = 3;
                    elseif sc_1 == sc && dc_1 ~= dc
                        data.trial_by.change_block(col)    = 2;
                        data.trial_by.change_trial(col)    = 2;
                    elseif sc_1 ~= dc && dc_1 == dc
                        data.trial_by.change_block(col)    = 1;
                        data.trial_by.change_trial(col)    = 1;
                    end
                case true
                    if dc_1 ~= dc
                        data.trial_by.change_block(col)    = 3;
                        data.trial_by.change_trial(col)    = 3;
                    end        
            end
        end
    end
    
    sc_1         = SC(col);
    dc_1         = DC(col);
    BLK_1        = data.trial_by.block(col);
    NIN_BLK_1    = data.trial_by.block_pres(col);
    CTR_BLK_1    = data.trial_by.block_ctr(col);
    TOC_BLK_1    = data.trial_by.change_block(col);
    TOC_TRL_1    = data.trial_by.change_trial(col);
    
end

data.trial_stat.uniq_targ_col                   = unique(SC);
data.trial_stat.uniq_catch_col                  = unique(SC(CACH==true));
for n_s = 1 : numel(data.trial_stat.uniq_targ_col)
    
    tempt = SC == data.trial_stat.uniq_targ_col(n_s) & CACH == false;
    tempt_catch = SC == data.trial_stat.uniq_targ_col(n_s) & CACH == true;
    tempc = SC == data.trial_stat.uniq_targ_col(n_s) & CACH == false & CRCT == true;
    tempc_catch = SC == data.trial_stat.uniq_targ_col(n_s) & CACH == true & CRCT == true;
    
    data.trial_stat.prop_targ_col(n_s)          = sum(tempt) / numel(SC) * 100;
    data.trial_stat.prop_catch_col(n_s)         = sum(tempt_catch) / numel(SC) * 100;
    
    data.trial_stat.n_targ_col(n_s)             = sum(tempt);
    data.trial_stat.n_catch_col(n_s)            = sum(tempt_catch);
    
    data.trial_stat.pct_cor_targ_col(n_s)       = sum(tempc) / sum(tempt) * 100;
    data.trial_stat.pct_cor_catch_col(n_s)      = sum(tempc_catch) / sum(tempt_catch) * 100;
                                                
end

data.trial_stat.uniq_dist_col                   = unique(DC);
for n_s = 1 : numel(data.trial_stat.uniq_dist_col)
    
    tempt = DC == data.trial_stat.uniq_dist_col(n_s) & CACH == false;
    tempc = DC == data.trial_stat.uniq_dist_col(n_s) & CACH == false & CRCT == true;
    
    data.trial_stat.prop_dist_col(n_s)          = sum(tempt) / numel(DC) * 100;
    data.trial_stat.n_dist_col(n_s)             = sum(tempt);
    data.trial_stat.pct_cor_dist_col(n_s)       = sum(tempc) / ...
                                                    sum(tempt) * 100;
end

data.trial_stat.uniq_targ_loc                   = unique(LOC_T);
for n_s = 1 : numel(data.trial_stat.uniq_targ_loc )
    
    tempt = LOC_T == data.trial_stat.uniq_targ_loc(n_s) & CACH == false;
    tempc = LOC_T == data.trial_stat.uniq_targ_loc(n_s) & CACH == false & CRCT == true;
    
    data.trial_stat.prop_targ_loc(n_s)          = sum(tempt) / numel(LOC_T) * 100;
    data.trial_stat.n_targ_loc(n_s)             = sum(tempt);
    data.trial_stat.pct_cor_targ_loc(n_s)       = sum(tempc) / ...
                                                    sum(tempt) * 100;
end

usc = unique(SC);
for t_col = 1:numel(usc)
    for n_s = 1 : numel(data.trial_stat.uniq_targ_loc)
        
        tempt = LOC_T == data.trial_stat.uniq_targ_loc(n_s) & CACH == false & data.trial_by.targ_col == usc(t_col);
        tempc = LOC_T == data.trial_stat.uniq_targ_loc(n_s) & CACH == false & CRCT == true & data.trial_by.targ_col == usc(t_col);
        
        data.trial_stat.prop_targ_loc_by_col(t_col,n_s)          = sum(tempt) / numel(LOC_T) * 100;
        data.trial_stat.n_targ_loc_by_col(t_col,n_s)             = sum(tempt);
        data.trial_stat.pct_cor_targ_loc_by_col(t_col,n_s)       = sum(tempc) / ...
            sum(tempt) * 100;
    end   
end

data.trial_stat.uniq_switch                     = unique(data.trial_by.change_block);
temp_U_SWCH = data.trial_stat.uniq_switch > 0;
data.trial_stat.uniq_switch      = data.trial_stat.uniq_switch(temp_U_SWCH);
for n_s = 1 : numel(data.trial_stat.uniq_switch)
    data.trial_stat.prop_switch(n_s)            = sum(data.trial_by.change_block == data.trial_stat.uniq_switch(n_s)) / ...
                                                    (numel(data.trial_by.change_block)) * 100;
    data.trial_stat.n_switch(n_s)               = sum(data.trial_by.change_block == data.trial_stat.uniq_switch(n_s));
end

data.trial_stat.uniq_block                      = unique(data.trial_by.block_ctr);
temp_U_BLC = data.trial_stat.uniq_block > 0;
data.trial_stat.uniq_block                      = data.trial_stat.uniq_block(temp_U_BLC);
for n_s = 1 : numel(data.trial_stat.uniq_block)
    data.trial_stat.prop_block(n_s)             = sum(data.trial_by.block_ctr == data.trial_stat.uniq_block(n_s)) / ...
                                                    (numel(data.trial_by.block_ctr)) * 100;
    data.trial_stat.n_block(n_s)                = sum(data.trial_by.block_ctr == data.trial_stat.uniq_block(n_s));
end

data.trial_stat.uniq_outcome                    = unique(data.trial_by.outcome);
temp_U_outcome = data.trial_stat.uniq_outcome > 0;
data.trial_stat.uniq_outcome                    = data.trial_stat.uniq_outcome(temp_U_outcome);
for n_s = 1 : numel(data.trial_stat.uniq_outcome)
    data.trial_stat.prop_outcome(n_s)             = sum(data.trial_by.outcome == data.trial_stat.uniq_outcome(n_s)) / ...
                                                    (numel(data.trial_by.outcome)) * 100;
    data.trial_stat.n_outcome(n_s)                = sum(data.trial_by.outcome == data.trial_stat.uniq_outcome(n_s));
end

usc = unique(SC);
for t_col = 1:numel(usc)
    data.trial_stat.uniq_outcome = unique(data.trial_by.outcome);
    for n_s = 1 : numel(data.trial_stat.uniq_outcome)
        data.trial_stat.prop_outcome_by_col(t_col, n_s)             = sum(data.trial_by.outcome(SC == usc(t_col)) == data.trial_stat.uniq_outcome(n_s)) / ...
            numel(data.trial_by.outcome(SC == usc(t_col))) * 100;
        data.trial_stat.n_outcome_by_col(t_col, n_s)                = sum(data.trial_by.outcome(SC == usc(t_col)) == data.trial_stat.uniq_outcome(n_s));
    end
end

temp_LOC_T_1        = [NaN; LOC_T];
temp_LOC_T          = [LOC_T; NaN];
temp_REP_LOC_T      = temp_LOC_T == temp_LOC_T_1;
temp_REP_LOC_T      = temp_REP_LOC_T(1:end-1);
REP_LOC_T           = NaN(numel(LOC_T),1);
REP_LOC_T           = temp_REP_LOC_T;

%{
for PR_IT = 1 : max(data.trial_stat.uniq_block)
    SWCH_CTR = 1;
    for TO_SWCH = data.trial_stat.uniq_switch(data.trial_stat.prop_switch>25)
        
        if PR_IT == 1
            b4 = PR_BLK(PR_BLK_IT);
            aR = PR_IT+1;
        elseif PR_IT == PR_BLK(PR_BLK_IT)
            b4 = PR_IT-1;
            aR = 1;
        else
            b4 = PR_IT-1;
            aR = PR_IT+1;
        end
        
        temp_aR            = data.trial_by.block_pres== aR;
        temp_b4            = data.trial_by.block_pres== b4;
        temp_is            = data.trial_by.block_pres== PR_IT;
        temp_det           = nan(numel(data.trial_by.block_pres),1);
        temp_det(temp_aR)  = 1;
        temp_det(temp_b4)  = -1;
        temp_det(temp_is)  = 0;
        temp_nan           = isnan(temp_det);
        temp_det_nan       = temp_det(~temp_nan);
        
        data.trial_stat.prime(PR_IT, SWCH_CTR).rt = ...
            RT( PR_BLK(PR_BLK_IT) == data.trial_by.block_ctr & ...
            PR_IT == data.trial_by.block_pres & ...
            TO_SWCH == data.trial_by.change_block);
        
        data.trial_stat.prime(PR_IT, SWCH_CTR).correct = ...
            CRCT( PR_BLK(PR_BLK_IT) == data.trial_by.block_ctr & ...
            PR_IT == data.trial_by.block_pres& ...
            TO_SWCH == data.trial_by.change_block);
        
        SWCH_CTR = SWCH_CTR + 1;
        
        clear temp*
        
    end
end
%}
end