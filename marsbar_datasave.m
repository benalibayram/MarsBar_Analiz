clear all
load('ICA_timeseries_loaded_C15.mat')
labels = {'Primer_VN' 'Seconder_VN' 'Somotomotor' 'Posterior_DMN'...
    'Right_FPN' 'BG' 'Cerebellum' 'Left_FPN' 'MPFC_DMN'...
    'Sup_Somotomotor' 'Dorsal_Attention' 'Limbic' 'Left_Somotomotor'...
    'DMN' 'Ventral_Attention'};
descrip = 'Summary data loaded from matlab input';
sumfunc = 'unknown';
for subjid = 1:28
    Y = squeeze(tcourses(subjid, :, :));
    Yvar = sign(Y).*inf;
    for i = 1:15
        regions{i}.name = labels{i};
        regions{i}.descrip = '';
        regions{i}.Y = squeeze(tcourses(subjid, :, i))';
        regions{i}.weights = [];
        regions{i}.info = [];
        regions{i}.vXYZ = [];
        regions{i}.mat = [];
    end
    filename = sprintf('subj%02d_mdata.mat',subjid);
    save(filename,'descrip','regions','sumfunc','Y','Yvar');
end