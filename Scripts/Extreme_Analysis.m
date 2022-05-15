%%
clear all

load('TIGER_combined_WaveHub')
date=datetime(time, 'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss ');
date_vec=datevec(date);

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




%% full Model cdf
figure(90)
pd_r = makedist('normal');
y = cdf(pd_r,Hs);
plot(Hs,y)


y2=1-y;

semilogy(Hs,y2)

grid on
%% CDF By year

for i=1:length(year)
    st=s(1,i);
    e=s(2,i);
    %figure(year(i))
    pd_r = makedist('Rayleigh');
    y = cdf(pd_r,Hs(st:e));
    %plot(Hs(st:e),y)
    
    y2=1-y;
    figure(i)
    semilogy(Hs(st:e),y2)

    grid on

end


%% Maxima
mx=[];
for i=1:length(year)
    
    st=s(1,i);
    e=s(2,i);
    hs=Hs(st:e);
    m=max(hs);
    mx=[mx m];
    
    
end


paramEsts = gpfit(mx)


%% Peaks

x=[1:length(Hs)];
date=time./(60*60*24);
[peak,loc,widths,proms]= findpeaks(Hs,x,'MinPeakDistance',360,'MinPeakHeight',5);

%%
    figure(70)
    f70=figure(70);
    f70.WindowState = 'maximized';
%     findpeaks(Swan_Hsig,x,'MinPeakDistance',120,'MinPeakHeight',3.5);
    hold on
    subplot(2,1,1)
    plot(x,Hs,'b',loc,peak,'or')
    hold on
    yline(4,'linewidth',1)
    xlabel('Time')
    ylabel('Significant Wave Height (m)')
    title('Significant Wave Height with Storm Peaks 5 Days Apart', 'FontSize', 15)
    legend( 'Significant Wave Height','Storm Peaks','location', 'best')
    xlim([0 length(time)])
    xticks([0:26297:length(time)])
    xticklabels({'1990','1991','1992','1992','1994','1995','1996','1997','1998','1999','2000','2001','2002','2203','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020'})
    subplot(2,1,2)
    plot(x(st:e),Hs(st:e),loc(387:407),peak(387:407),'or')
    hold on
    yline(4,'linewidth',1)
    xlabel('Time')
    ylabel('Significant Wave Height (m)')
    title('Significant Wave Height with Storm Peaks 5 Days Apart 2020', 'FontSize', 15)
    legend( 'Significant Wave Height','Storm Peaks','location', 'best')
    xlim([st e])
    xticks([st:2190:e])
    xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec','2020'})
%%
figure(91)
histogram(Hs,100,'Normalization','pdf','FaceColor',[1,0.8,0])

norm = fitdist(Hs,'Normal')
pdf_norm= pdf(norm,Hs);
wbl= fitdist(Hs,'wbl')
pdf_wbl= pdf(wbl,Hs);
rly =fitdist(Hs,'rayleigh')
pdf_rly= pdf(rly,Hs);
hold on 
line(Hs,pdf_norm,'LineStyle','-','Color','r')
hold on 
line(Hs,pdf_wbl,'LineStyle',':','Color','b')
hold on 
line(Hs,pdf_rly,'LineStyle','--','Color','k')