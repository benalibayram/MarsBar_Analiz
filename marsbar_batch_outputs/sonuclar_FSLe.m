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

% Proje klasörleri oluşturuldu.
proj_dir = '/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN';

for RSN_ind = 1:length(labels)
    mkdir(fullfile(proj_dir, labels{RSN_ind}));
end
%%
load('/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/stat_struct_C15_f512_none_v5.mat')
tvals_512_v5 = cat(3, stat_struct.stat); % 7x15x29
for subj_ind=1:28
    subjname = sprintf('_%02dDDA_512_v5.nii',subj_ind);
    for RSN_ind = 1:length(labels)
        dosya_adi = fullfile(proj_dir, labels{RSN_ind}, [labels{RSN_ind} subjname]);
        niftiwrite(squeeze(tvals_512_v5(:, RSN_ind, subj_ind)), dosya_adi);
    end
end

%%
load('/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/stat_struct_C15_f512_none_v2.mat')
tvals_512_v2 = cat(3, stat_struct.stat); % 7x15x29
for subj_ind=1:28
    subjname = sprintf('_%02dDDA_512_v2.nii',subj_ind);
    for RSN_ind = 1:length(labels)
        dosya_adi = fullfile(proj_dir, labels{RSN_ind}, [labels{RSN_ind} subjname]);
        niftiwrite(squeeze(tvals_512_v2(:, RSN_ind, subj_ind)), dosya_adi);
    end
end

%%
load('/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/stat_struct_C15_f128_none_v2.mat')
tvals_128_v2 = cat(3, stat_struct.stat); % 7x15x29
for subj_ind=1:28
    subjname = sprintf('_%02dDDA_128_v2.nii',subj_ind);
    for RSN_ind = 1:length(labels)
        dosya_adi = fullfile(proj_dir, labels{RSN_ind}, [labels{RSN_ind} subjname]);
        niftiwrite(squeeze(tvals_128_v2(:, RSN_ind, subj_ind)), dosya_adi);
    end
end
%%

proj_dir = '/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN';
%design matris 28 tane 1'den oluşuyor.
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
    
    % versiyon 2, f512
    content = dir('*512_v2.nii');
    if ~isempty(content)
        % merge subject level t-vectors (nifti file) containing values for
        % 7 tasks.
        filelist = struct2cell(content);
        filelist = join(fullfile(filelist([2 1], :)'), filesep, 2); %folder/filename combination
        filelist = strjoin(filelist,' '); % filelist combination for command.
        merge_command = sprintf('fslmerge -t %s_All_512_v2 %s', labels{RSN_ind}, filelist);
        system(merge_command);
        
        % randomise 5000 iterasyon
        randomise_command = sprintf('randomise -i %s_All_512_v2 -o %s -d %s -t %s -x',...
            labels{RSN_ind}, fullfile(guncel_klasor, 'results_512_v2'),...
            fullfile(proj_dir, 'design.mat'), fullfile(proj_dir, 'contrast.mat'));
        system(randomise_command);
        
        %Nifti to excel
        system('gunzip -f results_512_v2_vox_corrp_tstat1.nii.gz');
        corrp_512_v2_c1(:, RSN_ind) = niftiread('results_512_v2_vox_corrp_tstat1.nii');
        system('gunzip -f results_512_v2_vox_corrp_tstat2.nii.gz');
        corrp_512_v2_c2(:, RSN_ind) = niftiread('results_512_v2_vox_corrp_tstat2.nii');
    end
    
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
        randomise_command = sprintf('randomise -i %s_All_512_v5 -o %s -d %s -t %s -x',...
            labels{RSN_ind}, fullfile(guncel_klasor, 'results_512_v5'),...
            fullfile(proj_dir, 'design.mat'), fullfile(proj_dir, 'contrast.mat'));
        system(randomise_command);
        
        system('gunzip -f results_512_v5_vox_corrp_tstat1.nii.gz');
        corrp_512_v5_c1(:, RSN_ind) = niftiread('results_512_v5_vox_corrp_tstat1.nii');
        system('gunzip -f results_512_v5_vox_corrp_tstat2.nii.gz');
        corrp_512_v5_c2(:, RSN_ind) = niftiread('results_512_v5_vox_corrp_tstat2.nii');
    end
    
    % versiyon 2, f128
    content = dir('*128_v2.nii');
    if ~isempty(content)
        % merge subject level t-vectors (nifti file) containing values for
        % 7 tasks.
        filelist = struct2cell(content);
        filelist = join(fullfile(filelist([2 1],:)'),filesep,2);
        filelist = strjoin(filelist,' ');
        merge_command = sprintf('fslmerge -t %s_All_128_v2 %s', labels{RSN_ind}, filelist);
        system(merge_command);
        
        % randomise 
        randomise_command = sprintf('randomise -i %s_All_128_v2 -o %s -d %s -t %s -x',...
            labels{RSN_ind}, fullfile(guncel_klasor, 'results_128_v2'),...
            fullfile(proj_dir, 'design.mat'), fullfile(proj_dir, 'contrast.mat'));
        system(randomise_command);
        
        system('gunzip -f results_128_v2_vox_corrp_tstat1.nii.gz');
        corrp_128_v2_c1(:, RSN_ind) = niftiread('results_128_v2_vox_corrp_tstat1.nii');
        system('gunzip -f results_128_v2_vox_corrp_tstat2.nii.gz');
        corrp_128_v2_c2(:, RSN_ind) = niftiread('results_128_v2_vox_corrp_tstat2.nii');
    end
end
corrp_512_v2_c1_binary = zeros(7, 15);
corrp_512_v2_c1_binary(corrp_512_v2_c1 > 0.95) = 1;
meantvals_512_v2 = mean(tvals_512_v2(:,:,1:28), 3);
corrp_512_v2_c1_binary_table = cell2table(num2cell([corrp_512_v2_c1_binary; corrp_512_v2_c1; meantvals_512_v2]),'VariableNames',labels);
writetable(corrp_512_v2_c1_binary_table,'/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN/corrp_512_v2_c1_binary_table.xls');


corrp_512_v5_c1_binary = zeros(7, 15);
corrp_512_v5_c1_binary(corrp_512_v5_c1 > 0.95) = 1;
meantvals_512_v5 = mean(tvals_512_v5(:,:,1:28), 3);
corrp_512_v5_c1_binary_table = cell2table(num2cell([corrp_512_v5_c1_binary;corrp_512_v5_c1; meantvals_512_v5]),'VariableNames',labels);
writetable(corrp_512_v5_c1_binary_table,'/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN/corrp_512_v5_c1_binary_table.xls');

corrp_128_v2_c1_binary = zeros(7, 15);
corrp_128_v2_c1_binary(corrp_128_v2_c1 > 0.95) = 1;
meantvals_128_v2 = mean(tvals_128_v2(:,:,1:28), 3);
corrp_128_v2_c1_binary_table = cell2table(num2cell([corrp_128_v2_c1_binary;corrp_128_v2_c1; meantvals_128_v2]),'VariableNames',labels);
writetable(corrp_128_v2_c1_binary_table,'/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN/corrp_128_v2_c1_binary_table.xls');


corrp_512_v2_c2_binary = zeros(7, 15);
corrp_512_v2_c2_binary(corrp_512_v2_c2 > 0.95) = 1;
corrp_512_v2_c2_binary_table = cell2table(num2cell([corrp_512_v2_c2_binary;corrp_512_v2_c2; meantvals_512_v2]),'VariableNames',labels);
writetable(corrp_512_v2_c2_binary_table,'/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN/corrp_512_v2_c2_binary_table.xls');


corrp_512_v5_c2_binary = zeros(7, 15);
corrp_512_v5_c2_binary(corrp_512_v5_c2 > 0.95) = 1;
corrp_512_v5_c2_binary_table = cell2table(num2cell([corrp_512_v5_c2_binary;corrp_512_v5_c2; meantvals_512_v5]),'VariableNames',labels);
writetable(corrp_512_v5_c2_binary_table,'/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN/corrp_512_v5_c2_binary_table.xls');

corrp_128_v2_c2_binary = zeros(7, 15);
corrp_128_v2_c2_binary(corrp_128_v2_c2 > 0.95) = 1;
corrp_128_v2_c2_binary_table = cell2table(num2cell([corrp_128_v2_c2_binary;corrp_128_v2_c2; meantvals_128_v2]),'VariableNames',labels);
writetable(corrp_128_v2_c2_binary_table,'/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/MarsBar/marsbar_batch_outputs/FSL_RSN/corrp_128_v2_c2_binary_table.xls');



