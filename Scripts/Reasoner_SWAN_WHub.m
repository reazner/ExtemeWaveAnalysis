clear all
close all


year = [1989:2011];

for i=1:length(year)
    if year(i) == 2011
       filename=['D0_R_0' num2str(year(i)) '_10' num2str(year(i)) '.mat'];
    else
        filename=['D0_R_01' num2str(year(i)) '_12' num2str(year(i)) '.mat'];
    end
    
    load(filename) %%Change for each file
    WHub=data2(:,11);
    Swan_Xp = [WHub.Xp].'; % X coordinates
    Swan_Yp = [WHub.Yp].'; % Y Cooridinates
    Swan_Hsig = [WHub.Hsig].';  %Significant Wave Height
    Swan_TP = [WHub.TPsmoo].';  %Peak Period
    Swan_tim = [WHub.tim]';     %Time     
    Swan_steep = [WHub.Steepn]'; %Steepness
    Swan_dir = [WHub.Dir].';  % Direction
    %Swan_Tm10=[WHub.Tm_10].';   % Wave Energy Period
        for j = 1:length(Swan_tim)
            date(j)=datetime(Swan_tim(j), 'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss ');  % converts time to date in shown format
        end
    Swan_date = date';
    savefile = ['/Data/SWAN' num2str(year(i)) '.mat'];
    save([pwd savefile],'Swan_Xp','Swan_Yp','Swan_Hsig', 'Swan_TP','Swan_steep','Swan_date','Swan_tim','Swan_dir') %%Change for each file
end

%% Updated added direction
date=datetime(buoy_data.time, 'convertfrom','datenum')
formatOut = 'mm/dd';
t=datestr(date,formatOut)
k=1;
for i=1:48:length(t)
    h(k,1:5)=t(i,1:end);
    k=k+1;
end
%%

figure(70)
f70=figure(70);
f70.WindowState = 'maximized';
plot(buoy_data.time(1:336), buoy_data.WaveHeight_m_(1:336))
stem(, yy);
datetick('x','mm/dd')

