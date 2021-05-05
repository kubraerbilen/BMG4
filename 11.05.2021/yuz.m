clear all
clc
% indirdiğimiz 100 numaralı hastanın .mat uzantılı verisini matlabta çizdirme
hamsinyal=load('100m.mat').val;
plot(hamsinyal);
title('Ham Sinyal');
xlabel('Zaman(sn)');
ylabel('Genlik(mV)');



