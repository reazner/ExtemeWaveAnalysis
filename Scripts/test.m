clear th par lg log3 ret3 u3

x=[1:length(Hs)];
date=time./(60*60*24);
th=[5:.01:7.5];


for i=1:length(th)
    [peak,loc,widths,proms]= findpeaks(Hs,x,'MinPeakDistance',360,'MinPeakHeight',th(i));
    [f_peak,pk] = ecdf(peak);
    [xi_est(i),alpha_est(i),k_est(i)]=gpa_fit(pk);
    rt30=1-1/30;
    w1(i) = gpa_inv(rt30,xi_est(i),alpha_est(i),k_est(i));
    fit1=1-gpa_cdf(pk,xi_est(i),alpha_est(i),k_est(i));
    [h(i),p(i)] = adtest(fit1,'Distribution','ev');

end

subplot(2,1,1)
plot(th,k_est)
subplot(2,1,2)
plot(th,alpha_est)

%%
p=1-p;
plot(th,k_est)
hold on
plot(th,p)
%%
subplot(2,1,1)
plot(th,k_est)
subplot(2,1,2)
plot(th,w1)
%%
f_px=1-f_peak;
semilogy(pk,f_px,'or')
fit1=1-gpcdf(pk,par(1),par(2),th);
fit2=1-gpcdf(pk,0,1,th);
hold on
semilogy(pk,fit1)
hold on
semilogy(pk,fit2)
legend('Data','GPD','Gumel')
xlabel('Significant Wave Height [m]')
ylabel('Exceedence Probability')
title('POT')
%%
returnT = [2;10;25;50;100];
returnP = 1-(1./returnT);
[parmhatP parmCi]=gpfit(pk);
w1 = gpinv(returnP,.15,1.19,5.3)

returnpV = 1:10:100;
returnTp = 1-(1./returnpV);
returnLevel_P = gpinv(returnTp,.15,1.19,5.3)
plot(returnpV,returnLevel_P,'k',returnT,w1,'r*')

%%
subplot(2,1,1)
plot(th,par(:,1))
xlabel('Threshold [m]')
ylabel('shape parameter')
subplot(2,1,2)
plot(th,ret3)
xlabel('Threshold [m]')
ylabel('30 year return')

%%
sigma=par(2)-par(1)*(th-par(3));
frac=(1+par(1)*((pk-th)/sigma)).^(-1/par(1));
h_z=1-frac;
h_z=1-h_z
semilogy(pk,f_px,'or')
hold on
semilogy(pk,h_z)

%%
w2 = gpinv(fit1,par(1), par(2),th)


samp= randsample(pk,35,'true')
[f_samp,sp] = ecdf(samp);

s=1-gpcdf(sp,par(1),par(2),th);

f_sx=1-f_samp;
semilogy(sp,f_sx,'or')
hold on
semilogy(sp,s)

%%
c=corr(fit1,f_peak)
fpeak = gpa_inv(fit1,xi_est,alpha_est,k_est)
figure(10)
rhos1000 = bootstrp(10000,@regress,pk,fpeak);
histogram(rhos1000,15,'FaceColor',[.8 .8 1])

Y97 = prctile(rhos1000,97.5)
Y25 = prctile(rhos1000,2.5)
y=regress(pk,fpeak)
%% 
s=gpa_cdf(pk,xi_est,alpha_est,k_est)
[h,p,k] = kstest2(fpeak,pk)


%%

