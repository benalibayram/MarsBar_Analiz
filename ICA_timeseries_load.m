 % MarsBar’a verileri yüklemek için öncelikle ica_timeseries_load.m komutunu çalıştırıyoruz.
% 
% Komponent listesinden (comp_list) 12 çıkartıldı. 09.05.2021

files_loc = '/mnt/Data/ELIF_GORKEM/ANALIZ/mr/gift/four_tasks/four_tasks_scaling_components_files';

% Farklı sessionlardan üretilen 
subj_list = 1:28;
sess_inds = [140 140 287 428];
sess_list = 1:4;
comp_list = [1 2 3 4 5 8 9 10 11 13 14 16 17 23 24];
% artefakt = [6 7 12 15 18 19 20 21 22 25 26];
tcourses = zeros(length(subj_list), sum(sess_inds), length(comp_list)); % subj x tcourses x comps

sess_ind_lims = cumsum([1 sess_inds]);
sess_ind_lims = [sess_ind_lims(1:end-1)' cumsum(sess_inds)'];

for subj_ind = subj_list
    for sess_ind = sess_list
        filename = sprintf('sub%03d_timecourses_ica_s%d_.nii', subj_ind, sess_ind);
        V = spm_vol(fullfile(files_loc, filename));
        I = spm_read_vols(V);
        tcourses(subj_ind, sess_ind_lims(sess_ind,1):sess_ind_lims(sess_ind,2), :) = I(:,comp_list);
    end
end

% MarsBar ile analiz etmek için subject ortalaması üzerinden zaman serileri
% üretildi. Boyutu 995 x 15
subjmean_tcourse = squeeze(mean(tcourses(:,:,:),1));

clearvars -except tcourses subjmean_tcourse
save ICA_timeseries_loaded_C15.mat