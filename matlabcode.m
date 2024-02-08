% Yeni bir bulanık mantık sistemi oluşturalım ve dosyanın güvenlik seviyesini değerlendirelim.
fis = newfis('AntivirusSecurityModel', 'mamdani', 'min', 'max', 'min', 'max', 'centroid');

% Mamdani bulanık mantık, giriş değerlerini belirli üyelik fonksiyonları ile tanımlar. Belirsizlik ve kesinlik arasında bir denge sağlar.

% Dosya özellikleri ve indirme kaynağı gibi giriş değişkenlerini tanımlayalım.

fis = addvar(fis, 'input', 'dosyaOzellikleri', [0 10]); % Dosya özellikleri [0, 10] arasında değer alabilir.
fis = addmf(fis, 'input', 1, 'DusukRiskli', 'gaussmf', [1 0]); 
% 'Düşük Riskli' dosya özellikleri için Gauss üyelik fonksiyonu
fis = addmf(fis, 'input', 1, 'OrtaRiskli', 'gaussmf', [1 5]); 
% 'Orta Riskli' dosya özellikleri için Gauss üyelik fonksiyonu
fis = addmf(fis, 'input', 1, 'YuksekRiskli', 'gaussmf', [1 10]);
 % 'Yüksek Riskli' dosya özellikleri için Gauss üyelik fonksiyonu


fis = addvar(fis, 'input', 'indirmeKaynagi', [0 100]);
 % İndirme kaynağı [0, 100] arasında değer alabilir.
fis = addmf(fis, 'input', 2, 'Güvenli', 'trimf', [0 25 50]); 
% 'Güvenli' indirme kaynağı için üçgen üyelik fonksiyonu
fis = addmf(fis, 'input', 2, 'KısmenGüvenli', 'trimf', [30 50 70]); % 'Kısmen Güvenli' indirme kaynağı için üçgen üyelik fonksiyonu
fis = addmf(fis, 'input', 2, 'Şüpheli', 'trimf', [50 75 100]); 
% 'Şüpheli' indirme kaynağı için üçgen üyelik fonksiyonu



% Çıkış değişkenini tanımlayalım: Güvenlik Seviyesi
fis = addvar(fis, 'output', 'guvenlikSeviyesi', [0 100]);
 % Güvenlik Seviyesi [0, 100] arasında değer alabilir.
fis = addmf(fis, 'output', 1, 'Güvenli', 'trimf', [0 25 50]);
 % 'Güvenli' güvenlik seviyesi için üçgen üyelik fonksiyonu
fis = addmf(fis, 'output', 1, 'KısmenGüvenli', 'trimf', [30 50 70]); % 'Kısmen Güvenli' güvenlik seviyesi için üçgen üyelik fonksiyonu
fis = addmf(fis, 'output', 1, 'Riskli', 'trimf', [50 75 100]); 
% 'Riskli' güvenlik seviyesi için üçgen üyelik fonksiyonu

% Kuralları belirleyelim
rules = [
    1 1 1 1 1;
    1 2 2 1 1;
    1 3 3 1 1;
    2 1 2 1 1;
    2 2 3 1 1;
    2 3 3 1 1;
    3 1 3 1 1;
    3 2 3 1 1;
    3 3 3 1 1;
];
fis = addrule(fis, rules); 
% Kuralları bulanık mantık sistemine ekleyelim

% Oluşturduğumuz sistemi kullanarak, belirli dosya özellikleri ve indirme kaynağı güvenliği için güvenlik seviyesini hesaplayalım.

input = [5 40];
% Örnek giriş değerleri: Dosya özellikleri 5, indirme kaynağı güvenliği 40
output = evalfis(fis, input); % Bulanık mantık sistemini kullanarak çıkışı hesaplayalım
disp(['Dosyanın Güvenlik Seviyesi: ', num2str(output), '%']); % Hesaplanan güvenlik seviyesini ekrana yazdıralım


% Elde edilen sonuçları görselleştirelim.


figure;
subplot(3,1,1), plotmf(fis, 'input', 1); title('Dosya Özellikleri Üyelik Fonksiyonları');
subplot(3,1,2), plotmf(fis, 'input', 2); title('İndirme Kaynağı Üyelik Fonksiyonları');
subplot(3,1,3), plotmf(fis, 'output', 1); title('Güvenlik Seviyesi Üyelik Fonksiyonları');

% Oluşturulan grafikleri 'plot.png' olarak results klasörüne kaydedelim.

saveas(gcf, '/results/plot.png');

% Bu örnek girdilerle dosyanın güvenlik seviyesi 65.582% olarak çıkmıştır.
