clear all

marsbar('on')
spm('defaults', 'fmri');
%%
filtre = 512; % karar verildi
AR_var = false; % true or false 
% **********************contrasts SEÇ*************************
mdes_name = 'dortlu_design_3dc_2inst_1deriv_mdes.mat'; % v5
%mdes_name = 'dortlu_design_3dc_2inst_2deriv_mdes.mat'; % v4
%mdes_name = 'dortlu_design_0dc_2inst_1deriv_mdes.mat'; % v2

%{
versiyon 1: derivative:2 instruction: 1 dc:3 
versiyon 2: derivative: 1 instruction: 2 dc:0
versiyon 3: derivative:2 instruction: 1 dc:0
versiyon 4: derivative:2 instruction: 2 dc:3
versiyon 5: derivative:1 instruction: 2 dc:3
%}
% **********************contrasts SEÇ*************************

% 2deriv = ( 9 x 3 ) + 3 = 30
% 1deriv = ( 9 x 2 ) + 3 = 21
% 0dc_1deriv = ( 9 x 2 ) = 18
switch mdes_name
    case 'dortlu_design_0dc_2inst_1deriv_mdes.mat'
        versiyon = 'v2';
        nder = 2; % 3 or 2   3:2derivatives, 2:1derivative
        cont_default = 18; %30 or 21
    case 'dortlu_design_3dc_2inst_1deriv_mdes.mat'
        versiyon = 'v5';
        nder = 2; % 3 or 2   3:2derivatives, 2:1derivative
        cont_default = 21; %30 or 21
    case 'dortlu_design_3dc_2inst_2deriv_mdes.mat'
        versiyon = 'v4';
        nder = 3; % 3 or 2   3:2derivatives, 2:1derivative
        cont_default = 30; %30 or 21
    otherwise
        disp('mdes_name tanımlı değil.')
end
load(mdes_name)

D = des_struct(mardo_5, SPM);
%d = mardo(SPM);
SPM.xsDes = struct(...
	'Basis_functions',	'hrf (with time derivative)',...
	'Number_of_sessions',	1,...
	'Trials_per_session',	length(SPM.Sess.U),...
	'Global_calculation',	'none',...
	'Grand_mean_scaling',	'none',...
	'Global_normalisation',	'none',...
    'Interscan_interval',   sprintf('%0.2f {s}',SPM.xY.RT));
K = struct(	'HParam',	filtre,...
			'row',		SPM.Sess.row,...
			'RT',		SPM.xY.RT);

% K = pr_spm_filter(K);
k = length(K.row);
n = fix(2*(k*K.RT)/K.HParam + 1);
X0 = spm_dctmtx(k,n);
K.X0 = X0(:,2:end);
% K = pr_spm_filter(K);

SPM.xX.K = K;
SPM.xsDes.High_pass_Filter = sprintf('Cutoff: %d {s}', filtre);

if AR_var % true:AR(2), false:none 
    SPM.xVi.Vi = struct('type', 'fmristat', 'order', 2);
    f2cl       = 'V'; % field to clear
    SPM.xVi.form = 'fmristat AR(2)';
else
    SPM.xVi.V  = speye(995);
    f2cl       = 'Vi';
    SPM.xVi.form = 'i.i.d';
end

if isfield(SPM.xVi, f2cl)
    SPM.xVi = rmfield(SPM.xVi, f2cl);
end

xsDes = struct('Serial_correlations', SPM.xVi.form);
SPM.xsDes = mars_struct('ffillmerge', SPM.xsDes, xsDes);
D = des_struct(D,SPM);
mars_arm('update', 'def_design', D);

%%
% ICA_timeseries_load
load('ICA_timeseries_loaded_C15.mat')
clearvars -except tcourses D nder cont_default versiyon AR_var filtre

labels = {'Primer_VN' 'Seconder_VN' 'Somotomotor' 'Posterior_DMN'...
    'Right_FPN' 'BG' 'Cerebellum' 'Left_FPN' 'MPFC_DMN'...
    'Sup_Somotomotor' 'Dorsal_Attention' 'Limbic' 'Left_Somotomotor'...
    'DMN' 'Ventral_Attention'};

nsubj = size(tcourses,1);
% Basic Contrasts
cont_names = {'pview', 'smotor', 'srtt', 'gonogo', 'oneback', 'twoback', ...
    'threeback', 'basitdikkat', 'inh_1', 'inh_2', 'wm', 'wm_2', 'resp_motor', ...
    'gonogo_srtt'};
cont_names_len = length(cont_names);
cont_vals = {[1 zeros(1,cont_default)],... %pview
            [zeros(1, 1*nder) 1 zeros(1, cont_default-1*nder)],... %smotor
            [zeros(1, 2*nder) 1 zeros(1, cont_default-2*nder)],... %srtt
            [zeros(1, 3*nder) 1 zeros(1, cont_default-3*nder)],... %gonogo
            [zeros(1, 4*nder) 1 zeros(1, cont_default-4*nder)],... %oneback
            [zeros(1, 5*nder) 1 zeros(1, cont_default-5*nder)],... %twoback
            [zeros(1, 6*nder) 1 zeros(1, cont_default-6*nder)],... %threeback
            };   
% Contrast Combinations
cont_vals{8} = -1/2*cont_vals{1} + -1/2*cont_vals{2} + 1*cont_vals{3}; %basitdikkat
cont_vals{9} = -1/4*cont_vals{3} + 1*cont_vals{4} + -1/4*cont_vals{5} + -1/4*cont_vals{6} + -1/4*cont_vals{7}; %inh_1
cont_vals{10} = -1/2*cont_vals{3} + 1*cont_vals{4} + -1/2*cont_vals{5}; %inh_2
cont_vals{11} = -1*cont_vals{3} + 1/3*cont_vals{5} + 1/3*cont_vals{6} + 1/3*cont_vals{7}; %wm
cont_vals{12} = -1*cont_vals{3} + 1/6*cont_vals{5} + 2/6*cont_vals{6} + 3/6*cont_vals{7}; %wm_2
cont_vals{13} = -1*cont_vals{1} + 1*cont_vals{3}; %resp_motor
cont_vals{14} = -1*cont_vals{3} + 1*cont_vals{4}; %gonogo_srtt

cont_types = repmat({'T'}, 1, length(cont_names));


tcourses(29,:,:) = squeeze(mean(tcourses(:,:,:),1));
for subj_ind = 1:nsubj+1
    Y = squeeze(tcourses(subj_ind, :,:));
    for rno = 1:length(labels)
        r_data{rno} = Y(:,rno);
        r_info{rno} = struct(...
            'name', labels{rno},...
            'descrip', '',...
            'Y', Y(:,rno),...
            'weights', [],...
            'info', [],...
            'vXYZ', [],...
            'mat', []);
    end
    s_info = struct(...
        'sumfunc', 'unknown', ...
        'descrip', 'Data from matlab',...
        'info', []);
    marsY = marsy(r_data, r_info, s_info);
    
    E = estimate(D, marsY);
    
    [E, Ic] = add_contrasts(E, cont_names, cont_types, cont_vals);
    
    stat_struct(subj_ind) = compute_contrasts(E, Ic);
end


if AR_var, ARname = 'AR2_'; else, ARname = 'none_'; end
filtre_ismi = sprintf('f%d_', filtre);
sonucdosyasi = ['stat_struct_C15_' filtre_ismi ARname versiyon '_extra_kontrast2'];

sonuc_tamisim = fullfile(pwd, 'marsbar_batch_outputs', sonucdosyasi);
save(sonuc_tamisim, 'stat_struct')




