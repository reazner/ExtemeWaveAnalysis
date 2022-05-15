%%
clear all

load('TIGER_combined_WaveHub')
date=datetime(time, 'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss ');
date_vec=datevec(date);
hs=Hs;
year=[1990:2020];
% y=zeros(26352,31);
% 
% for i=1:length(year)
%     new =find(date_vec(:,1)==year(i));
%     z=length(y(:,1))-length(new);
%     
%     y(:,i)=[new ; zeros(z,1)];
%      
%  end

s=zeros(2,31);

for i=1:length(year)
    new =find(date_vec(:,1)==year(i));

    
    s(:,i)=[new(1); new(length(new))];
     
 end

%% 95th Percentile
Y = prctile(hs,95)



%% full Model cdf
figure('Name','Full Model Emperical CDF')
[f,x] = ecdf(hs);
f_x=1-f;
semilogy(x,f_x,'o')
grid on
ylabel('Exceednece Probability')
xlabel('Significant Wave Heigth [m]')
%%
figure('Name','Full Model Emperical CDF')
[f,x] = ecdf(hs);
f_x=1-f;
plot(x,f,'o')
grid on
yline(.95,'r')
ylabel('Exceednece Probability')
xlabel('Significant Wave Heigth')


%% Maxima
mx=[];
mi=[];
for i=1:length(year)
    
    st=s(1,i);
    e=s(2,i);
    hs=Hs(st:e);
    [m j]=max(hs);
    mx=[mx m];
    mi=[mi j+st];
    
end

figure('Name', 'Block Maxima')
[f_mx,mx1] = ecdf(mx);
f_x=1-f_mx;
semilogy(mx1,f_x,'o')
xticks(1:.1:10)
hold on


[param,paramCIs] = gevfit(mx1)

p=1-gevcdf(mx1,param(1),param(2),param(3));
semilogy(mx1,p,'r');
hold on
y2 =1-gevcdf(mx1,0,1,7.0680);
semilogy(mx1,y2)
hold on
legend('Data','GEV','Gumbel')
xlabel('Significant Wave Height [m]')
ylabel('Exceedence Probability')


%% Comparison Graphs

fCP=figure('Name', 'Block Maxima Comparison');
fCP.WindowState='Maximized'
subplot(1,2,1)
qqplot(y2,f_x)
xlabel('Model')
ylabel('Emperical')
title('Q-Q Plot')

subplot(1,2,2)
scatter(y2,f_x)
xlabel('Model')
ylabel('Emperical')
title('Probability Plot')


%% Peaks

x=[1:length(Hs)];
date=time./(60*60*24);
th=5.86

[peak,loc,widths,proms]= findpeaks(Hs,x,'MinPeakDistance',360,'MinPeakHeight',th);
   


figure('Name','POT')
[f_peak,pk] = ecdf(peak);
% f_peak(end)=[];
% pk(1)=[];
f_px=1-f_peak;
semilogy(pk,f_peak,'or')

[xi_est,alpha_est,k_est]=gpa_fit(pk)
fit1=1-gpa_cdf(pk,xi_est,alpha_est,k_est);
semilogy(pk,f_px,'ok',pk,fit1);

% fit3=1-gpcdf(pk,-.15,1.19,th);
fit2=1-gpcdf(pk,0,1,th);
hold on
semilogy(pk,fit2)
grid on
legend('Data','GPD','Gumel')
xlabel('Significant Wave Height [m]','FontSize', 15)
ylabel('Exceedence Probability','FontSize', 15)
title('Peak of Threshold Exceedence','FontSize', 24)


%%

fCP=figure('Name','Comparison Peak');
fCP.WindowState='Maximized'
subplot(1,2,1)
qqplot(fit1,f_px)
xlabel('Model')
ylabel('Emperical')
title('Q-Q Plot')

subplot(1,2,2)
scatter(fit1,f_px)
xlabel('Model')
ylabel('Emperical')
title('Probability Plot')


   


%%
sec=find(loc<s(1,31));
loc20=loc;
loc20(sec)=[];
peak20=peak;
peak20(sec)=[];

    figure(70)
    f70=figure(70);
    f70.WindowState = 'maximized';
    hold on
    subplot(2,1,1)
    plot(x,Hs,'b',loc,peak','or')
    hold on
    scatter(mi,mx,'or','MarkerFaceColor','k')
    hold on 
    yline(th,'r','linewidth',1)
    hold on
    xline(s(1,:))
    
    xlabel('Time', 'FontSize', 15)
    ylabel('Significant Wave Height (m)', 'FontSize', 15)
    title('Swan Model Significant Wave Height with Storm Peaks 5 days apart' , 'FontSize', 24)
    legend( 'Significant Wave Height','Storm Peaks','Annual Maxima','Threshold','location', 'best')
    xlim([0 length(time)])
    xticks([0:26297:length(time)])
    xticklabels({'1990','1991','1992','1992','1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020'})
    
 
    
    subplot(2,1,2)
    plot(x(st:e),Hs(st:e),loc20,peak20,'or')
    hold on
    
    
    yline(th,'r','linewidth',1)   
    xlabel('Time', 'FontSize', 15)
    ylabel('Significant Wave Height (m)', 'FontSize', 15)
    title('Significant Wave Height with Storm Peaks 5 Days Apart 2020', 'FontSize', 24)
    legend('Significant Wave Height','Storm Peaks','location', 'best')
    xlim([st e])
    xticks([st:2190:e])
    xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec','2020'})

%%


returnT = [2;5;10;15;25;50;100];
returnP = (1-(1./returnT));

[xi_est,alpha_est,k_est]=gpa_fit(pk);
w1 = gpa_inv(returnP,xi_est,alpha_est,k_est);


returnpV = 1:1:100;
returnTp = (1-(1./returnpV));
returnLevel_P =gpa_inv(returnTp,xi_est,alpha_est,k_est);
return975=1.0250*gpa_inv(returnTp,xi_est,alpha_est,k_est);
return25=0.9402*gpa_inv(returnTp,xi_est,alpha_est,k_est);
figure(6)
plot(returnpV,returnLevel_P,'k',returnT,w1','r*',returnpV,return975,'--b',returnpV,return25,'--b')

%%
parmhat=gevfit(mx);
w2 = gevinv(returnP,parmhat(1),parmhat(2),parmhat(3))

returnpV = 2:10:100;
returnTp = 1-(1./returnpV);
returnLevel_P2 = gevinv(returnTp,parmhat(1),parmhat(2),parmhat(3));
figure(2)
plot(returnpV,returnLevel_P2,'k',returnT,w2,'r*')

%%
%%
parmhat=gevfit(mx);
w2 = gpinv(returnP,-.15,1.19,th)

returnpV = 2:10:100;
returnTp = 1-(1./returnpV);
returnLevel_P2 = gpinv(returnTp,-.15,1.19,th);
figure(2)
plot(returnpV,returnLevel_P2,'k',returnT,w2,'r*')




