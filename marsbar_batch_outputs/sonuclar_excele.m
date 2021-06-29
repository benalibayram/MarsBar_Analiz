%%
clear all

labels = {'Primer_VN' 'Seconder_VN' 'Somotomotor' 'Posterior_DMN'...
    'Right_FPN' 'BG' 'Cerebellum' 'Left_FPN' 'MPFC_DMN'...
    'Sup_Somotomotor' 'Dorsal_Attention' 'Limbic' 'Left_Somotomotor'...
    'DMN' 'Ventral_Attention'};

cont_names = {'pview', 'smotor', 'srtt', 'gonogo', 'oneback', 'twoback', 'threeback'};

n=1;
for cont_ex = 1:length(cont_names)
    for ICN_ex = 1:length(labels)
        names_exe(n) = {sprintf('%s_%s',cont_names{cont_ex},labels{ICN_ex})};
        n=n+1;
    end
end

%%
load('stat_struct_C15_f512_none_v5.mat')

for i=1:28
    dummy = stat_struct(i).stat';
    f512_none_v5(i,:) = dummy(:)';
end

T_f512_none_v5 = cell2table(num2cell(f512_none_v5),'VariableNames',names_exe);

writetable(T_f512_none_v5,'T_C15_f512_none_v5.xls');

%%
load('stat_struct_C15_f512_none_v2.mat')

for i=1:28
    dummy = stat_struct(i).stat';
    f512_none_v2(i,:) = dummy(:)';
end

T_f512_none_v2 = cell2table(num2cell(f512_none_v2),'VariableNames',names_exe);

writetable(T_f512_none_v2,'T_C15_f512_none_v2.xls');
%%
% 
% for j = 1:7
%     [R(j,:,:), P(j,:,:)] = corrcoef(squeeze(t_all(:,j,:)));
% end





