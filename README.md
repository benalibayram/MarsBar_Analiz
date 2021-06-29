# MarsBar Analiz
#### ICA_timeseries_load.m

GIFT sonucu komponentlerin zaman serilerini çıkaran program.
GIFT analizleri içerisinde *scaling_components_files* klasörü tanımlanması gerekiyor. Tüm subjectler için tasklara ait komponentlerin zaman serileri ardarda ekleniyor. Marsbar tarafından okunacak şekilde *ICA_timeseries_loaded* ile başlayan mat dosyasına  kaydediliyor. Marsbar arayüzünden import edilecek Matlab değişkeninin ismi ise: *tcourses*


#### marsbar_datasave.m

Marsbar arayüzünden Matlab değişkeni yükleyip kaydetmek yerine script ile aynı işi yapmak istersen bu programı kullanabilirsin. Ama eğer *marsbar_batch.m* ile ilerleyeceksen bu kodu kullanman gerekmiyor.

#### marsbar_batch.m ve marsbar_batch_extra_kontrast.m

Tüm analizi yapıp **marsbar_batch_outputs** alt klasöründe *stat_struct_* ile başlayan mat dosyalarına kaydediliyor.

### marsbar_batch_outputs alt klasöründe

#### sonuçlar_excele.m

SPSS analizi için sonuçları excel ortamına transfer eden kod.

#### sonuçlar_FSLe.m

Sonuçları FSL'de permutasyon analizine tabi tutmak için NIfTI formatında kaydediyor.