close all;
clear;
clc;
sig=load('100m.mat').val;
N=length(sig);
fs=360;  %örnekleme frekansı
t=[0:N-1]/fs;
figure(1);
plot(sig);
title('Ham Sinyal');

%%
     %          DC Bilesenlerin Atilmasi  
dcsizsinyal=(sig-mean(sig));
%figure(1);
% plot(dcsizsinyal); 
% title('DC Bilesenleri Atilan Sinyal');
%%
     %           Low Pass Filter
b=1/32*[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];
sigL=filter(b,a,dcsizsinyal);
% figure(2);
% plot(sigL);
% title('Low Pass Filter');

%%
     %           High Pass Filter
b=[-1/32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1/32];
a=[1 -1];
sigH=filter(b,a,sigL);
% figure(3);
% plot(sigH);
% title('High Pass Filter');


%%
     %          Derivative Base Filter
b=[1/4 1/8 0 -1/8 -1/4];
a=[1];
sigD=filter(b,a,sigH);
% figure(4);
% plot(sigD);
% title('Derivative Base Filter')



%%
     %normalization
    
sigD2=sigD.^2;
signorm=sigD2/max(abs(sigD2));

%%
 
% h=ones(1,31)/31;
% sigAV=conv(signorm,h);
% sigAV=sigAV(15+[1:N]);
% sigAV=sigAV/max(abs(sigAV));
% figure(5);
% plot(sigAV);
% title('Moving Average filter')

h=(1/10)*ones(1,10);
sigAV=conv(signorm,h);
sigAV=sigAV/max(abs(sigAV));
% figure(5);
% plot(sigAV);
% title('Moving Average filter')



%%
treshold=mean(sigAV);
P_G= (sigAV>0.01);
% figure(3);
% plot(P_G);
% title('treshold Signal');
% figure;
%plot(sigL);

%%

difsig=diff(P_G);
left=find(difsig==1);
raight=find(difsig==-1);

%%
     %      run cancel delay
     %      6 sample delay because of LowPass filtering
     %      16 sample delay because of HighPass filtering

left=left-(6+16);
raight=raight-(6+16);

%%
    % P-QRS-t
for i=1:length(left)
   
    [R_A(i) R_t(i)]=max(sigL(left(i):raight(i)));
    R_t(i)=R_t(i)-1+left(i) %add offset
   
    [Q_A(i) Q_t(i)]=min(sigL(left(i):R_t(i)));
    Q_t(i)=Q_t(i)-1+left(i)
  
    [S_A(i) S_t(i)]=min(sigL(left(i):raight(i)));
    S_t(i)=S_t(i)-1+left(i)
    
    [P_A(i) P_t(i)]=max(sigL(left(i):Q_t(i)));
    P_t(i)=P_t(i)-1+left(i)
    
    [T_A(i) T_t(i)]=max(sigL(S_t(i):raight(i)));
    T_t(i)=T_t(i)-1+left(i)+47
    
   
end
%%
figure(8);
plot(t,sigL,t(Q_t),Q_A,'*g',t(S_t),S_A,'^k',t(R_t),R_A,'ob',t(P_t),P_A,'+b',t(T_t),T_A,'+r');
legend('Sinyal','Q Noktası','S Noktası','RNoktası','P Noktası','T Noktası');
title("P Q R S T Degerleri");

 for i=1:((length(P_t))-1)
    
    HRV=P_t(i+1)-P_t(i)
 end



