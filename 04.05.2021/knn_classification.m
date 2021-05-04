close all
clc

%İskemi aşamasında EKG ST segmentinde düşüş ve 
%T dalgalarının şeklinde tersine dönme gözükebilir. 
% ST ÇÖKMESİ >=0.05
% T DALGA TERSLEŞMESİ >=0.1
%%
oku_st=fopen('st_invertal.txt','r');
yazdir_st=fscanf(oku_st,'%f',inf);
fclose(oku_st);
%disp(yazdir_st); 

oku_t=fopen('t_dalgasi.txt','r');
yazdir_t=fscanf(oku_t,'%f',inf);
fclose(oku_t);
%disp(yazdir_t); 
%%
% D_Min_Max Normalizasyonu
% Öncelikle modelin uygulanması 
% için tüm veriler 0,1 ile 0,9 arasında
% normalize edilmiştir. Normalizasyon yapılarak veriler
% boyutsuz hale getirilmiş olur
for i=1:8
    st_normalizasyon(i,1)=0.8*(yazdir_st(i)-min(yazdir_st))/(max(yazdir_st)-min(yazdir_st))+0.1;
    %disp(st_normalizasyon(i,1));
end 

for i=1:8
    t_normalizasyon(i,1)=0.8*(yazdir_t(i)-min(yazdir_t))/(max(yazdir_t)-min(yazdir_t))+0.1;
    %disp(t_normalizasyon(i,1));
end


%%
%öklid uzaklık hesaplama

[durum,sayi,tum] = xlsread('knnDurum.xlsx');
veri = str2double(sayi);
[satir sutun]=size(veri);

for i=1:8
    for j=1:8
        a=((veri(i,1))-(st_normalizasyon(j,1)).^2);
        b=((veri(i,2))-(t_normalizasyon(j,1)).^2);
        dist(j,1)=sqrt(abs(a)+abs(b)); 
    end
end
%%
%uzaklıklar ve durumlar eşleştirildi
uzaklik_durum=[dist durum];


%%

%yakınlığa göre durumlarla birlikte sıralandı.
knnSirali=  sortrows(uzaklik_durum,1);

%%
%Sınıflandırma
% 3 degere bakilir ve iskemi gecirip gecirilmediğine karar verilir.
% 0 degerei gecirmemis olması
% 1 degeri gecirmis olmasi 
% 0 ve 1 lerden hangisi çogunluktaysa o sınıfa girer
k=3;
for i=1:k
   disp(knnSirali(i));
   disp(knnSirali(i,2));
end











