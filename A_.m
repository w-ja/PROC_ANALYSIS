function A_(varargin)

%% AUTHORSHIP AND LICENSE
% Jacob A. Westerberg
% Graduate Student
% Maier and Schall Labs
% Vanderbilt University
% 111 21st Ave S
% Nashville, TN 37240
% USA
%
% jacob.a.westerberg@vanderbilt.edu
% jakewesterberg@gmail.com
%
% This work is licensed under the Creative Commons
% Attribution-NonCommercial-NoDerivatives 4.0 International License.
% To view a copy of this license, visit
% http://creativecommons.org/licenses/by-nc-nd/4.0/
% or send a letter to Creative Commons, PO Box 1866, Mountain View,
% CA 94042, USA.
%
% This analysis is designed to incorporate all necessary code to generate
% results I have produced. Rather than creating a directory tree of all .m
% files, this function, and its subfunctions, are self-contained.
%
% ------------------------------------------------------------------------
%% DISCLAIMER
%
% THIS CODE IS INCOMPLETE IN ITS CURRENT STATE! DEVELOPMENT IS ONGOING.
%
% ------------------------------------------------------------------------
%% DEFAULT PARAMETERS

% Online?
params.online_analysis		 = false;
params.synapse_live			 = false; % "Synapse Live has ~6s delay from recording" (Myles from TDT)
params.training              = false;
params.proto                 = false;

% Directories
switch params.online_analysis
    case true
        params.dir_in		 = '';
        params.dir_out		 = '';
    case false
        switch params.training
            case true
                switch params.proto
                    case true
                        params.dir_in	 = 'C:\Users\jakew\OneDrive\Desktop\train\';
                        params.dir_out	 = 'C:\Users\jakew\OneDrive\Desktop\train_out\';
                    case false
                        params.dir_in = '/home/jakew/Data/train/';
                        params.dir_out = '/home/jakew/Data/train/';
                end
            case false
                params.dir_in = 'C:\Data\';
                params.dir_out = 'C:\Data\';
                
        end
end

%%%%%%%%%%%%%%%%%%
%%%%% PARAMS %%%%%
%%%%%%%%%%%%%%%%%%

% Online Data Save Location
params.rec_disk_loc          = 'D:\';

% Preprocess
params.preprocess 			 = false;
params.blk_merge             = false;

% Save settings
params.save_all				 = true;
params.save_plot			 = true;
params.save_copy			 = false;

% Analysis types
params.lim2cx                = false;
params.fakeneuron            = false;
params.quick 				 = false;
params.fromScratch           = false;
params.bhv_only              = false;
params.last_block_only 		 = false;
params.last_sess_only        = false;
params.pd_trigger 			 = 'PD1_';

% Analysis to-do list
params.flash 				 = false;
params.rf_mapping			 = false;
params.vs                    = false;

% Default Infos
cx_limits = [1 32];

% ------------------------------------------------------------------------
%% VARIABLE INPUT (USER)

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-o','online'}
            params.online_analysis = true;
        case {'-d','directory'}
            params.dir_in = varargin{varStrInd(iv)+1};
        case {'-q','quick'}
            params.quick = 1;
        case {'synapse'}
            params.synapse_live = true;
        case {'-cx', 'cx_lim'}
            cx_limits = varargin{varStrInd(iv)+1};
    end
end

% ------------------------------------------------------------------------
%% MAIN LOOP

switch params.online_analysis
    
    case true
        
        switch params.synapse_live
            
            case true
                
                [cur_dir,name,ext] = fileparts(dir_in);
                
                syn_liv = SynapseLive('MODE', 'Preview', 'EXPERIMENT', 'OnlineAveragingDemo');
                
            case false
                
                info.cur_dir = H_LATEDIR(params.rec_disk_loc); 
                info.ch_min = cx_limits(1);
                info.ch_max = cx_limits(2);
                
                evt = struct();
                        
                strb = TDTbin2mat(info.cur_dir,'TYPE',{'epocs'},'STORE','STRB');
                evt.code = strb.epocs.STRB.data;
                evt.time = strb.epocs.STRB.onset .* 1000;
                
                evt.time(evt.code == 0) = [];
                evt.code(evt.code == 0) = [];
                
                f_stm = find(evt.code == 2651);
                t_dif = diff(evt.time(evt.code==2651));
                e_dif = [0; t_dif < 100];
                
                evt.time(f_stm(logical(e_dif))) = [];
                evt.code(f_stm(logical(e_dif))) = [];
                
                clear strb;
                
                evt.vec_task = H_DETT_TDT(evt.code);
                evt = H_DETB_TDT(evt);
                
                T_NONE(evt, info, params); 
                
        end
        
    case false
        
        [rec, rec_head] = H_REC();
        
        dir_dir = H_DIRF(params.dir_in);
        
        for i_dir = 1 : numel(dir_dir)
            
            if params.last_sess_only
                if i_dir ~= numel(dir_dir)
                    continue
                end
            end
            
            info.cur_dir = dir_dir{i_dir};

            if strcmp(info.cur_dir, [params.dir_in 'train\']) && ...
                ~params.training

                continue
                
            end

            
            idx_date  = strfind(info.cur_dir, '-');
            info.date  = str2double(info.cur_dir(idx_date(1)+1:idx_date(2)-1));
            
            info.ind_prb = find( info.date == [rec{:,rec_head.DATE}]);

            for i_prb = 1 : length(info.ind_prb)
                
                if strcmp(rec{ info.ind_prb(i_prb), rec_head.PROCESS }, 'exclude')
                    continue
                end
                
                info.L4_top = rec{ info.ind_prb(i_prb), rec_head.TO4 };
                info.L4_bot = rec{ info.ind_prb(i_prb), rec_head.BO4 };
                info.Cx_top = rec{ info.ind_prb(i_prb), rec_head.TOCX };
                info.Cx_bot = rec{ info.ind_prb(i_prb), rec_head.BOCX };
                
                info.monkey = rec{ info.ind_prb(i_prb), rec_head.IDENT };
                info.investigator = rec{ info.ind_prb(i_prb), rec_head.INVESTIGATOR };
                info.system = rec{ info.ind_prb(i_prb), rec_head.SYSTEM };
                
                if strcmp(rec{ info.ind_prb(i_prb), rec_head.SORTDIR }, 'descending')
                    info.ch_min = rec{ info.ind_prb(i_prb), rec_head.CHSTART };
                    info.ch_max = rec{ info.ind_prb(i_prb), rec_head.CHSTOP };
                elseif strcmp(rec{ info.ind_prb(i_prb), rec_head.SORTDIR }, 'ascending')
                    info.ch_min = rec{ info.ind_prb(i_prb), rec_head.CHSTOP };
                    info.ch_max = rec{ info.ind_prb(i_prb), rec_head.CHSTART };
                end
                
                info.ch_spc = rec{ info.ind_prb(i_prb), rec_head.CSPACING };
                
                switch info.system
                    case 'TDT'
                        
                        evt = struct();
                        
                        strb = TDTbin2mat(info.cur_dir,'TYPE',{'epocs'},'STORE','STRB');
                        evt.code = strb.epocs.STRB.data;
                        evt.time = strb.epocs.STRB.onset .* 1000;
                        
                        evt.time(evt.code == 0) = [];
                        evt.code(evt.code == 0) = [];
                        
                        f_stm = find(evt.code == 2651);
                        t_dif = diff(evt.time(evt.code==2651));
                        e_dif = [0; t_dif < 100];
                        
                        evt.time(f_stm(logical(e_dif))) = [];
                        evt.code(f_stm(logical(e_dif))) = [];

                        clear strb;
                        
                        evt.vec_task = H_DETT_TDT(evt.code);
                        evt = H_DETB_TDT(evt);
                        
                    case 'Blackrock'
                        
                end
                
                if params.flash;        T_FLASH(evt, info, params);     end
                
                if params.rf_mapping;   T_RFMAP(evt, info, params);     end
                
                if params.vs;           T_VS(evt, info, params);        end
                
            end
        end   
end