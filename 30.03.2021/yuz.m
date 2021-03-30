clear all
clc
 
hamsinyal=load('100m.mat').val;
plot(hamsinyal);
title('Ham Sinyal');
xlabel('Zaman(sn)');
ylabel('Genlik(mV)');



