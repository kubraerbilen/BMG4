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

%%
     %           Low Pass Filter
b=1/32*[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];
sigL=filter(b,a,dcsizsinyal);

%%
     %           High Pass Filter
b=[-1/32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1/32];
a=[1 -1];
sigH=filter(b,a,sigL);

%%
     %          Derivative Base Filter
b=[1/4 1/8 0 -1/8 -1/4];
a=[1];
sigD=filter(b,a,sigH);

%%
     %normalizasyon
    
sigD2=sigD.^2;
signorm=sigD2/max(abs(sigD2));

%%

h=(1/10)*ones(1,10);
sigAV=conv(signorm,h);
sigAV=sigAV/max(abs(sigAV));

%%
treshold=mean(sigAV);
P_G= (sigAV>0.01);


%%

difsig=diff(P_G);
left=find(difsig==1);
raight=find(difsig==-1);

%%

left=left-(6+15);
raight=raight-(6+15);


%%
    % P-QRS-t
for i=1:length(left)
   
    [R_A(i) R_t(i)]=max(sigL(left(i):raight(i)));
    R_t(i)=R_t(i)-1+left(i) %offset
   
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
figure(2);
plot(t,sigL,t(Q_t),Q_A,'*g',t(S_t),S_A,'^k',t(R_t),R_A,'ob',t(P_t),P_A,'+b',t(T_t),T_A,'+r');
legend('Sinyal','Q Noktası','S Noktası','R Noktası','P Noktası','T Noktası');
title("P Q R S T Degerleri");

 for i=1:((length(P_t))-1)
    
    HRV=P_t(i+1)-P_t(i)
    diary 100mIntervalSonuc.txt
    disp('------------------');
    disp('HRV Ciktisi');
    disp(HRV);
    diary end
 end

%%

disp('s_t_interval');
for i=1:length(S_t)
    s_t_interval(i)=(T_t(i)-S_t(i))/360;
    disp(s_t_interval(i));
end
diary 100mIntervalSonuc.txt
 disp('------------------');
 disp('S-T Interval Ciktilari');
 disp(s_t_interval);
diary end
%%
disp('r_r_interval');
for i=1:length(R_t)-1
    r_r_interval(i)=(R_t(i+1)-R_t(i))/360;
    disp(r_r_interval(i));
end
diary 100mIntervalSonuc.txt
 disp('------------------');
 disp('R-R Interval Ciktilari');
 disp(r_r_interval);
diary end
r_peaks_count=length(R_t)
%%
disp('t_t_interval');
for i=1:length(T_t)-1
    t_t_interval(i)=(T_t(i+1)-T_t(i))/360;
    disp(t_t_interval(i));
end
diary 100mIntervalSonuc.txt
 disp('------------------');
 disp('T-T Interval Ciktilari');
 disp(t_t_interval);
diary end

%%
disp('p_r_interval');
for i=1:(length(R_t)-1)
    p_r_interval(i)=(R_t(i+1)-P_t(i))/360;
    disp(p_r_interval(i));
end
diary 100mIntervalSonuc.txt
 disp('------------------');
 disp('P-R Interval Ciktilari');
 disp(p_r_interval);
diary end
%%
disp('q_t_interval');
for i=1:min(length(Q_t),length(T_t))
    q_t_interval(i)=(T_t(i)-Q_t(i))/360;
    disp(q_t_interval(i));
end
diary 100mIntervalSonuc.txt
 disp('------------------');
 disp('Q-T Interval Ciktilari');
 disp(q_t_interval);
diary end
%%
disp('p_p_interval');
for i=1:length(P_t)-1
    p_p_interval(i)=(P_t(i+1)-P_t(i))/360;
    disp(p_p_interval(i));
end
diary 100mIntervalSonuc.txt
disp('------------------');
disp('P-P Interval Ciktilari');
disp(p_p_interval);
diary end


