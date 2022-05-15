%%%%%%% Created for CSMN 404 Advanced Marine Energy %%%%%%%%%%%%%%%%

%%%%%% Written on  2nd Feb 2022 %%%%%%%%%%%%%%%%%%%


%%%%%%%%%% Author: Meagan Reasoner %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



close all
clear all
set(0,'defaultAxesFontSize',15)

Year = '10';
Swanfile =['TIGER_combined_WaveHub.mat'];
WHfile = ['Wave_Hub20' Year '.mat'];



load(Swanfile)  % This is created with the SWAN_WHub.m file
load(WHfile)  % This is created in HOME>>IMPORTDATA and the using the Wave_Params_2009.txt
                           % and the year of interest I uploaded [Hm0,
                            % ts(when possible), tp,
                            % hmm01, Time, latitude, longitude, mdir,
                            % s1mean, change the upload type to column
                            % matrix, then save the Workspace.
                            % Wave_Hub2009 was the name I gave it.


date=datetime(time, 'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss ');  % converts time to date in shown format


WH_Time=datevec(Time);   % This converts the time into a vector [ year month day hour minute seconds]
                            % Since the model is once an hour and the buoy
                            % is every half hour you want the lengths to be
                            % the same for error control
j=1;

for i = 1:length(WH_Time)  %This removes any row for the Wave Hub data that time ends in :30
                            % i.e is the data was collected 1-Jan-2009
                            % 12:30:00 the row for all Wave Hub data will be
                            % removed.
    
    if WH_Time(i,5) ~= 30
        
        WHub_date(j,1:6)=WH_Time(i,1:6);
        WH_ts(j,:)=ts(i);
        WH_hm0(j,:)=hm0(i);
        WH_latitude(j,:)=latitude(i);
        WH_longitude(j,:)=longitude(i);
        WH_mdir(j)=mdir(i);
        WH_tmm10(j,:)= tmm10(i);
%         WH_ts(j,:)= ts(i);
        j=j+1;
        
    end
    
end
% inx=inx(1:end);
WHub_date=datetime(WHub_date);
 WH_mdir= WH_mdir';


 
%%
j=1;
date=datetime(time, 'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss ');  % converts time to date in shown format

date_vec=datevec(date);

for i = 1:length(date_vec)  %This removes any row for the Wave Hub data that time ends in :30
                            % i.e is the data was collected 1-Jan-2009
                            % 12:30:00 the row for all Wave Hub data will be
                            % removed.
    
    if date_vec(i,5) ~= 20 && date_vec(i,5) ~= 40
        
        Swan_date(j,1:6)=date_vec(i,1:6);
%         Swan_Te(j,:)=Te(i);
%         Swan_hs(j,:)=Hs(i);
%         Swan_currx(j,:)=curr_x(i);
%         Swan_curry(j,:)=curr_y(i);
%         Swan_mdir(j)=Dirm(i);
%         Swan_Dspr(j,:)= Dspr(i);
%         Swan_Te_rel(j,:)= Te_rel(i);
%         Swan_Tm_rel(j,:)= Tm_rel(i);
%         Swan_Tm(j,:)=Tm(i);
        
        
        
        j=j+1;
        
    end
    
end
Swan_date=datetime(Swan_date);
%% Starting and Ending points  
% Not all buoys recorded for the whole year, this sets the start and end
% point for the Swan Model to match the Wave Hub collection.

s=find(Swan_date==WHub_date(1));
e=find(Swan_date==WHub_date(end));
if length(s)==0
    s=find(Swan_date==WHub_date(2))
end
if length(e) ==0
    e=find(Swan_date==WHub_date(end-1))
end

        Swan_date=date_vec(s:e);
        Swan_Te=Te(s:e);
        Swan_hs=Hs(s:e);
        Swan_currx=curr_x(s:e);
        Swan_curry=curr_y(s:e);
        Swan_mdir=Dirm(s:e);
        Swan_Dspr= Dspr(s:e);
        Swan_Te_rel= Te_rel(s:e);
        Swan_Tm_rel= Tm_rel(s:e);
        Swan_Tm=Tm(s:e);
 Swan_date=Swan_date';
%%
%There are occasionally double time points in the Swan Model this section
%removes them and ensure that the time of data for Swan Model and Wave Hub
%are in sync
WH_vec=datevec(WHub_date) ;
Swan_vec=Swan_date;
j=1;

while length(Swan_vec) > length(WH_vec)
    
    for i=1:length(Swan_vec)
        if Swan_vec(i,4) ~= WH_vec(i,4)
            ind=i
            Swan_date(ind,:)=[];
            
        end
    end
end
%% Find errors
errorind = find(WH_hm0 < .2 | WH_hm0 > 15);    %%These are user defined, I looked at the plots before hand 
                                                % and picked resaonable
                                                % parameters
                                                
date_vec(errorind) = [];
WH_hm0(errorind) = [];
Swan_Hsig(errorind) = []; 
Swan_dir(errorind)=[];
WH_mdir(errorind)=[];
WHub_date(errorind)=[];
Swan_TP(errorind)=[];
WH_ts(errorind)=[];
Swan_tim(errorind)=[];



 %% Error section
 count2=0;
 count3=0;
 for i = 1:length(WH_hm0)
    RMSE(i)= sqrt(mean(WH_hm0(i)-Swan_Hsig(i)).^2);
    if RMSE(i) > .3
        count3 = count3+1;
    end
    if RMSE(i) > .2
        count2 = count2+1;
    end
 end
 rmse=sqrt(mean(Swan_Hsig-WH_hm0).^2);
 Max = max(RMSE);
 PercentError2=round((count2/length(WH_hm0))*100,2);
 PercentError3=round((count3/length(WH_hm0))*100,2);
 
 if length(num2str(PercentError2)) ~= length(num2str(PercentError3))
     PercentError2=round((count2/length(WH_hm0))*100, 1);
     PercentError3=round((count3/length(WH_hm0))*100, 1);
 end
 
 figure(30)
 f30=figure(30);
 f30.WindowState = 'maximized';
 plot(date_vec,RMSE,'DisplayName','RMSE');
 hold on;
 plot(date_vec,Swan_Hsig,'DisplayName','Swan_Hsig','LineWidth',2')
 hold on
 plot(date_vec,WH_hm0,'DisplayName','WH_hm0');
 hold on
 yline(.2,'r','LineWidth',2')
 PE=['Percentage of Error Greater than 20%: ' num2str(PercentError2) '%'; 'Percentage of Error Greater than 30%: ' num2str(PercentError3) '%'];
 text(0,max(WH_hm0)+.05,PE,'FontSize',12)
 legend('Error', 'Swan Model', 'Wave Hub data', '20% Error Line')
 Errtitle = ['Significant wave height comparison from 20' Year ' with RMSE'];
 title(Errtitle)
 xlabel('Time')
 ylabel('Significant Wave Height (m)')
 hold off;
 Errsave=['/Figures/Error_20' Year '.png']
 saveas(gcf ,[pwd Errsave]);
 
 %% Sig Heigth Comparison
 
 SHigMean=mean(Swan_Hsig)
 WHMean=mean(WH_hm0)
 
 Bias = (SHigMean-WHMean)/SHigMean*100
 
 for i = 1:length(Swan_Hsig)
     num(i)=(Swan_Hsig(i)-WH_hm0(i))^2;
 end
 num1=sqrt(sum(num)/length(Swan_Hsig));
 dem=sum(Swan_Hsig)/length(Swan_Hsig);
 SI=num1/dem*100
 
 
 %% Direction Comparison
 
 for i = 1:length(Swan_dir)
     num(i)=180-abs(180-abs(Swan_dir(i)-WH_mdir(i)));
 end
 
 diff=sum(num)/length(Swan_dir)
 
  for i = 1:length(Swan_dir)
     num(i)=180-abs(180-abs(Swan_dir(i)-WH_mdir(i)));
  end
 
  Dir_rmse=sqrt(sum(num.^2)/length(Swan_dir))
  year=['20' Year]
  ErrorAnalysis={year, 'H_m0 Bias' 'H_m0 Scatter Index'  'Direction Difference' 'Direction RMSE';...
                  '',  Bias,       SI,                      diff,                   Dir_rmse}
 %%
 
 
 Swan_dir=Swan_dir-90;
 WH_mdir=WH_mdir-90;
 figure(42)
 f42=figure(42);
 f42.WindowState = 'maximized';
 Windrose1 =  wind_rose(Swan_dir,Swan_Hsig,'di',[0:.5:5],'ci',[5 10 15 20 25],'lablegend','Hm0')
 SwanWRtitle= ['Wave Rose from 20' Year ' for Swan Model']
 title(SwanWRtitle)
 SwanWRsave=['/Figures/Swan_Wave_Rose_20' Year '.fig']
 saveas(gcf ,[pwd SwanWRsave]);
 
 
 figure(41)
 f41=figure(41);
 f41.WindowState = 'maximized';
 winrose2 = wind_rose(WH_mdir,WH_hm0,'di',[0:.5:5],'ci',[5 10 15 20 25],'lablegend','Hm0')
 WH_WRtitle= ['Wave Rose from 20' Year ' for Wave Hub Buoy']
 title(WH_WRtitle)
 WH_WRsave=['/Figures/Wave_Hub_Wave_Rose_20' Year '.fig']
 saveas(gcf ,[pwd WH_WRsave]);
%  
%  
%  %%
%  
% 
%  Swanfile =['Swan20' Year '.mat'];
%  load(Swanfile)
%  Swan_dir=Swan_dir-90;
%  mdir=mdir-90;
%  figure(44)
%  f44=figure(44);
%  f44.WindowState = 'maximized';
%  winrose4 = wind_rose(mdir,hm0,'di',[0:.5:5],'ci',[5 10 15 20 25],'lablegend','Hm0')
%  WH_WRtitle= ['Wave Rose from 20' Year ' for Complete Wave Hub Buoy']
%  title(WH_WRtitle)
%   WH_WRsave=['/Figures/Full_Wave_Hub_Wave_Rose_20' Year '.fig']
%  saveas(gcf ,[pwd WH_WRsave]);
%  
%  figure(45)
%  f45=figure(45);
%  f45.WindowState = 'maximized';
%  winrose4 = wind_rose(Swan_dir,Swan_Hsig,'di',[0:.5:5],'ci',[5 10 15 20],'lablegend','Hm0')
%  WH_WRtitle= ['Wave Rose from 20' Year ' for Complete Swan Model']
%  title(WH_WRtitle) 
%  SwanWRsave=['/Figures/FullSwan_Wave_Rose_20' Year '.fig']
%  saveas(gcf ,[pwd SwanWRsave]);
%  
%  
 %% Plotting
% Basic Plots of Sig Wave vs Time and Tp vs Time....again Tp for the Wave
% Hub is questionable...will investigate more.

 figure(20)
 f20=figure(20);
 f20.WindowState = 'maximized';
 plot(date_vec,Swan_Hsig,'LineWidth',2')
 hold on
 plot(date_vec,WH_hm0)
 xlabel('Time')
 ylabel('Significant Wave Height (m)')
 legend('Swan Model Data','Wave Buoy', 'location','northwest')
 Sigtitle=['Significant Wave Height Swan Model and In-Situ Data 20' Year];
 title(Sigtitle)
 Sigsave=['/Figures/SigWaveHeight_20' Year '.png'];
 saveas(gcf ,[pwd Sigsave]);
 
 figure(21)
 f21=figure(21);
 f21.WindowState = 'maximized';
 plot(date_vec,Swan_TP)
 hold on
 plot(date_vec,WH_ts)
 xlabel('Time')
 ylabel('Peak Period')
 legend('Swan Model Data','Wave Buoy', 'location','northwest')
 Ptitle=['Peak Period Swan Model and In-Situ Data 20' Year]
 title(Ptitle)
 Psave=['/Figures/PeakPeriod_20' Year '.png'];
 saveas(gcf ,[pwd Psave]);

[Swan_max, Swan_loc]=max(Swan_Hsig)
[WH__max, WH_loc]=max(WH_hm0)
% 
%% Wave Scatter

[colormax] = wvscatter(Swan_Hsig,Swan_TP,1)

[colormax2] = wvscatter(WH_hm0,WH_ts,1)





 %%
 %save([pwd '/Data/Error 20' Year '.mat'], 'Bias', 'SI', 'diff', 'Dir_rmse')
 
save([pwd '/Scripts/Combined Data 20' Year '.mat'],'Swan_tim', 'Swan_date', 'Swan_dir', 'Swan_Hsig', 'Swan_steep', 'Swan_tim', 'Swan_TP', 'Swan_Xp', 'Swan_Yp', 'WH_hm0', 'WH_latitude', 'WH_longitude', 'WH_mdir', 'WH_tmm10', 'WH_ts', 'WHub_date', 'Swan_vec', 'WH_vec')