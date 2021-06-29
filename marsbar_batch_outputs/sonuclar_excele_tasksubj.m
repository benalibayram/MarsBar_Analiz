%%
clear all

labels = {'Task' 'Primer_VN' 'Seconder_VN' 'Somotomotor' 'Posterior_DMN'...
    'Right_FPN' 'BG' 'Cerebellum' 'Left_FPN' 'MPFC_DMN'...
    'Sup_Somotomotor' 'Dorsal_Attention' 'Limbic' 'Left_Somotomotor'...
    'DMN' 'Ventral_Attention'};

cont_names = {'pview', 'smotor', 'srtt', 'gonogo', 'oneback', 'twoback', 'threeback'};

% n=1;
% for cont_ex = 1:length(cont_names)
%     for ICN_ex = 1:length(labels)
%         names_exe(n) = {sprintf('%s_%s',cont_names{cont_ex},labels{ICN_ex})};
%         n=n+1;
%     end
% end

%%
load('stat_struct_C15_f512_none_v5.mat')

for i=1:28
    dummy = stat_struct(i).stat';
    f512_none_v5(i,:) = dummy(:)';
end
dummy1 = reshape(f512_none_v5,[28 15 7]);
dummy2 = permute(dummy1, [1 3 2]); % 28x7x15
f512_none_v5 = reshape(dummy2, [28*7 15]);
f512_none_v5 = [repelem([1:7]',28) f512_none_v5];
T_f512_none_v5 = cell2table(num2cell(f512_none_v5),'VariableNames',labels);

writetable(T_f512_none_v5,'T_C15_f512_none_v5_tasksubj.xls');

%%
load('stat_struct_C15_f512_none_v2.mat')

for i=1:28
    dummy = stat_struct(i).stat';
    f512_none_v2(i,:) = dummy(:)';
end
dummy1 = reshape(f512_none_v2,[28 15 7]);
dummy2 = permute(dummy1, [1 3 2]); % 28x7x15
f512_none_v2 = reshape(dummy2, [28*7 15]);
f512_none_v2 = [repelem([1:7]',28) f512_none_v2];
T_f512_none_v2 = cell2table(num2cell(f512_none_v2),'VariableNames',labels);

writetable(T_f512_none_v2,'T_C15_f512_none_v2_tasksubj.xls');
%%
% 
% for j = 1:7
%     [R(j,:,:), P(j,:,:)] = corrcoef(squeeze(t_all(:,j,:)));
% end





