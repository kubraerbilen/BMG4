close all
clc
%Sinyalin Matlab Ortamina Alinmasi 
hamsinyal=load('100m.mat').val;
plot(hamsinyal);
title('Ham Sinyal');


% DC Bilesenlerin Atilmasi  
dcsizsinyal=(hamsinyal-mean(hamsinyal));
plot(dcsizsinyal); 
title('DC Bilesenleri Atilan Sinyal');

%10 Point Moving Avarege Filtre
B=(1/10)*ones(1,10);
A=1;
freqz(B,A); 
title('10 Point Moving Avarage Filtre');

%Low Pass
avaragefiltrelisinyal=filter(B,A,dcsizsinyal);
plot(avaragefiltrelisinyal); 
title('Low Pass(Düsuk Geciren) Filtreden Gecmis Sinyal');


% Comb Filter
B=conv([1 1],[0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310]);
A=1;
freqz(B,A); 
title('Comb Filter');


% 60Hz sebeke gurultusunu ve harmoniklerini bastiran filtre  
comb=filter(B,A,avaragefiltrelisinyal);
plot(comb); 
title('(60Hz ve Harmoniklerini Bastiran) Filtreden Gecmis Sinyal');


hold on;
findpeaks(comb);
plot(comb); 
title('QRS sinyallerinin Peak Değerleri');
xlabel('Zaman(sn)');
ylabel('Genlik(mV)');
