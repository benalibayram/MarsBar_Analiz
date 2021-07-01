%%
clear all
subj_num = 28;
RSN_num = 15;
labels = {'Kontrast' 'Subj' 'Primer_VN' 'Seconder_VN' 'Somotomotor' 'Posterior_DMN'...
    'Right_FPN' 'BG' 'Cerebellum' 'Left_FPN' 'MPFC_DMN'...
    'Sup_Somotomotor' 'Dorsal_Attention' 'Limbic' 'Left_Somotomotor'...
    'DMN' 'Ventral_Attention'};

cont_names = {'pview', 'smotor', 'srtt', 'gonogo', 'oneback', 'twoback', 'threeback'};
cont_names_len = length(cont_names);
% Contrast Combinations
combins = nchoosek(1:cont_names_len, 2);
for newcond_ind=1:size(combins, 1)
    cont_names{cont_names_len + newcond_ind} = strjoin(cont_names(combins(newcond_ind, :)), {'-'});
end
Cont_num = length(cont_names);
%%
load('stat_struct_C15_f512_none_v5_extra_kontrast.mat')

for i=1:subj_num
    dummy = stat_struct(i).stat';
    f512_none_v5(i,:) = dummy(:)';
end
dummy1 = reshape(f512_none_v5, [subj_num, RSN_num, Cont_num]);
dummy2 = permute(dummy1, [1 3 2]); % subj_num x Cont_num x RSN_num
f512_none_v5 = reshape(dummy2, [subj_num*Cont_num RSN_num]);
f512_none_v5 = [repmat([1:subj_num]',Cont_num,1) f512_none_v5];
f512_none_v5_cell = num2cell(f512_none_v5);
cont_names_all = repelem(cont_names', subj_num, 1);
f512_none_v5_cell = [cont_names_all f512_none_v5_cell];

T_f512_none_v5 = cell2table(f512_none_v5_cell,'VariableNames',labels);

writetable(T_f512_none_v5,'T_C15_f512_none_v5_extra_kontrast_tasksubj.xls');

