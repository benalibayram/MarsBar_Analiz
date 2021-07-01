%{
Bu script'in amacı FSL'in permütasyon tekniğini kullanarak,
taskların subjectler üzerinden permütasyonu ile belirli DDA'lar için 
%}
clear all

labels = {'Primer_VN' 'Seconder_VN' 'Somotomotor' 'Posterior_DMN'...
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

% Proje klasörleri oluşturuldu.
proj_dir = fullfile(pwd, 'FSL_RSN_extra_kontrast');
if ~exist(proj_dir, 'dir')
    mkdir(proj_dir)
end
for RSN_ind = 1:length(labels)
    newFolder = fullfile(proj_dir, labels{RSN_ind});
    if ~exist(newFolder, 'dir')
        mkdir(newFolder)
    end
end
%%
load(fullfile(pwd, 'stat_struct_C15_f512_none_v5_extra_kontrast.mat'))
perm_num = 20000;

tvals_512_v5 = cat(3, stat_struct.stat); % 28x15x29
for subj_ind=1:28
    subjname = sprintf('_%02dDDA_512_v5.nii',subj_ind);
    for RSN_ind = 1:length(labels)
        dosya_adi = fullfile(proj_dir, labels{RSN_ind}, [labels{RSN_ind} subjname]);
        niftiwrite(squeeze(tvals_512_v5(:, RSN_ind, subj_ind)), dosya_adi);
    end
end

%%
proj_dir = fullfile(pwd, 'FSL_RSN_extra_kontrast');
%design matris 28 tane 1'den olusuyor.
design_mat = ones(28,1);
dlmwrite(fullfile(proj_dir, 'design.txt'), design_mat);
makedesign_command = sprintf('Text2Vest %s %s', fullfile(proj_dir, 'design.txt'),...
    fullfile(proj_dir, 'design.mat'));
system(makedesign_command);

%kontrast matrisi
contrast_mat = [1;-1];
dlmwrite(fullfile(proj_dir, 'contrast.txt'), contrast_mat);
makecontrast_command = sprintf('Text2Vest %s %s', fullfile(proj_dir, 'contrast.txt'),...
    fullfile(proj_dir, 'contrast.mat'));
system(makecontrast_command);


for RSN_ind = 1:length(labels)
    guncel_klasor = fullfile(proj_dir, labels{RSN_ind});
    cd(guncel_klasor);
    
    % versiyon 5, f512
    content = dir('*512_v5.nii');
    if ~isempty(content)
        % merge subject level t-vectors (nifti file) containing values for
        % 7 tasks.
        filelist = struct2cell(content);
        filelist = join(fullfile(filelist([2 1],:)'),filesep,2);
        filelist = strjoin(filelist,' ');
        merge_command = sprintf('fslmerge -t %s_All_512_v5 %s', labels{RSN_ind}, filelist);
        system(merge_command);
        
        % randomise 
        randomise_command = sprintf('randomise -i %s_All_512_v5 -o %s -d %s -t %s -n %d -x',...
            labels{RSN_ind}, fullfile(guncel_klasor, 'results_512_v5'),...
            fullfile(proj_dir, 'design.mat'), fullfile(proj_dir, 'contrast.mat'), perm_num);
        system(randomise_command);
        
        system('gunzip -f results_512_v5_vox_corrp_tstat1.nii.gz');
        corrp_512_v5_c1(:, RSN_ind) = niftiread('results_512_v5_vox_corrp_tstat1.nii');
        system('gunzip -f results_512_v5_vox_corrp_tstat2.nii.gz');
        corrp_512_v5_c2(:, RSN_ind) = niftiread('results_512_v5_vox_corrp_tstat2.nii');
    end
end
corrp_512_v5_c1_binary = zeros(length(cont_names), length(labels));
corrp_512_v5_c1_binary(corrp_512_v5_c1 > 0.95) = 1;
meantvals_512_v5 = mean(tvals_512_v5(:,:,1:28), 3);
row_labels = repmat(cont_names',3,1);
corrp_512_v5_c1_binary_table = cell2table([row_labels num2cell([corrp_512_v5_c1_binary;corrp_512_v5_c1; meantvals_512_v5])],'VariableNames',[{'Kontrasts'} labels]);
writetable(corrp_512_v5_c1_binary_table, fullfile(proj_dir, 'corrp_512_v5_c1_binary_table_extra_kontrast.xls'));

corrp_512_v5_c2_binary = zeros(length(cont_names), length(labels));
corrp_512_v5_c2_binary(corrp_512_v5_c2 > 0.95) = 1;
corrp_512_v5_c2_binary_table = cell2table([row_labels num2cell([corrp_512_v5_c2_binary; corrp_512_v5_c2; meantvals_512_v5])],'VariableNames',[{'Kontrasts'} labels]);
writetable(corrp_512_v5_c2_binary_table, fullfile(proj_dir, 'corrp_512_v5_c2_binary_table_extra_kontrast.xls'));

