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

year=find(date_vec(:,1)~=2010);

Swan_tim=time;
Swan_date=date_vec;
Swan_Te=Te;
Swan_hs=Hs;
Swan_currx=curr_x;
Swan_curry=curr_y;
Swan_mdir=Dirm;
Swan_Dspr= Dspr;
Swan_Te_rel= Te_rel;
Swan_Tm_rel= Tm_rel;
Swan_Tm=Tm;


Swan_date=datetime(date_vec);

Swan_tim(year)=[];
date_vec(year,:)=[];
Swan_date(year)=[];
Swan_Te(year)=[];
Swan_hs(year)=[];
Swan_currx(year)=[];
Swan_curry(year)=[];
Swan_mdir(year)=[];
Swan_Dspr(year)= [];
Swan_Te_rel(year)= [];
Swan_Tm_rel(year)=[];
Swan_Tm(year)=[];

%%

hour= find(date_vec(:,5)==0);

Swan_tim=Swan_tim(hour);
Swan_date=Swan_date(hour);
Swan_Te=Swan_Te(hour);
Swan_hs=Swan_hs(hour);
Swan_currx=Swan_currx(hour);
Swan_curry=Swan_curry(hour);
Swan_mdir=Swan_mdir(hour);
Swan_Dspr=Swan_Dspr(hour);
Swan_Te_rel=Swan_Te_rel(hour);
Swan_Tm_rel=Swan_Tm_rel(hour);
Swan_Tm=Swan_Tm(hour);

%% Starting and Ending points  
% Not all buoys recorded for the whole year, this sets the start and end
% point for the Swan Model to match the Wave Hub collection.

s=find(Swan_date==WHub_date(1));
e=find(Swan_date==WHub_date(end));

        Swan_tim=Swan_tim(s:e);
        Swan_date=Swan_date(s:e);
        Swan_Te=Swan_Te(s:e);
        Swan_hs=Swan_hs(s:e);
        Swan_currx=Swan_currx(s:e);
        Swan_curry=curr_y(s:e);
        Swan_mdir=Swan_mdir(s:e);
        Swan_Dspr=Swan_Dspr(s:e);
        Swan_Te_rel=Swan_Te_rel(s:e);
        Swan_Tm_rel=Swan_Tm_rel(s:e);
        Swan_Tm=Swan_Tm(s:e);
 
%%
Swan_tim(2160)=[];
Swan_date(2160)=[];
Swan_Te(2160)=[];
Swan_hs(2160)=[];
Swan_currx(2160)=[];
Swan_curry(2160)=[];
Swan_mdir(2160)=[];
Swan_Dspr(2160)= [];
Swan_Te_rel(2160)= [];
Swan_Tm_rel(2160)=[];
Swan_Tm(2160)=[];


%% Find errors
errorind = find(WH_hm0 < .2 | WH_hm0 > 15);    %%These are user defined, I looked at the plots before hand 
                                                % and picked resaonable
                                                % parameters
                                                

WH_hm0(errorind) = [];
WH_mdir(errorind)=[];
WHub_date(errorind)=[];
WH_ts(errorind)=[];


Swan_date(errorind)=[];
Swan_Te(errorind)=[];
Swan_hs(errorind)=[];
Swan_currx(errorind)=[];
Swan_curry(errorind)=[];
Swan_mdir(errorind)=[];
Swan_Dspr(errorind)= [];
Swan_Te_rel(errorind)= [];
Swan_Tm_rel(errorind)=[];
Swan_Tm(errorind)=[];



%% Plot

plot(Swan_date, Swan_hs,'LineWidth',1)
hold on
plot(WHub_date,WH_hm0)

 %% Sig Heigth Comparison
 
 SHigMean=mean(Swan_hs)
 WHMean=mean(WH_hm0)
 
 Bias = (SHigMean-WHMean)/SHigMean*100
 
 for i = 1:length(Swan_hs)
     num(i)=(Swan_hs(i)-WH_hm0(i))^2;
 end
 num1=sqrt(sum(num)/length(Swan_hs));
 dem=sum(Swan_hs)/length(Swan_hs);
 SI=num1/dem*100
 
 
 %% Direction Comparison
 
 for i = 1:length(Swan_mdir)
     num(i)=180-abs(180-abs(Swan_mdir(i)-WH_mdir(i)));
 end
 
 diff=sum(num)/length(Swan_mdir)
 
  for i = 1:length(Swan_mdir)
     num(i)=180-abs(180-abs(Swan_mdir(i)-WH_mdir(i)));
  end
 
  Dir_rmse=sqrt(sum(num.^2)/length(Swan_mdir))
  year=['20' Year]
  ErrorAnalysis={year, 'H_m0 Bias' 'H_m0 Scatter Index'  'Direction Difference' 'Direction RMSE';...
                  '',  Bias,       SI,                      diff,                   Dir_rmse}
 %%
 

 Swan_mdir=Swan_mdir;
 WH_mdir=WH_mdir;
 figure(42)
 f42=figure(42);
 f42.WindowState = 'maximized';
 Windrose1 =  wind_rose(Swan_mdir,Swan_hs,'di',[0:.5:5],'ci',[5 10 15 20 25],'lablegend','Hm0')
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
 plot(date_vec,Swan_hs,'LineWidth',2')
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
 
save([pwd '/Data/NewCombined Data 20' Year '.mat'],'Swan_currx', 'Swan_curry', 'Swan_date', 'Swan_Dspr', 'Swan_hs', 'Swan_mdir', 'Swan_Te', 'Swan_Te_rel', 'Swan_Tm', 'Swan_Tm_rel', 'WH_hm0', 'WH_mdir', 'WH_ts', 'WHub_date')