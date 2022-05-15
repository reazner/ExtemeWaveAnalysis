clear all
close all

% load('TIGER_combined_WaveHub.mat')
% load('Wave_Hub2010.mat')
load('Combined Data 2010.mat')

%%

overid=find(buoy_data.WaveHeight_m_ < 1.5);
1

j=1;
index=[overid(1)];

while j<length(overid)
    
    if overid(j+1)- overid(j)~= 1
        index=[ index overid(j) overid(j+1)];
       
    end
    
    j=j+1;
    
end 

index=[index length(buoy_data.time)];


%% Full Spectrum
figure(20)
f20=figure(20);
f20.WindowState = 'maximized';
plot(Swan_date,Swan_hs,'b')
xlabel('Time')
ylabel('Significant Wave Height (m)')
title('Significant Wave Height Over Time')
saveas(gcf ,[pwd '/Figures/SigHvsTime.png']);

%% Cutoff Height
i=1;

while i<length(index)
    
    figure(21)
    f21=figure(21);
    f21.WindowState = 'maximized';
    hold on
    plot(buoy_data.time(index(i):index(i+1)),buoy_data.WaveHeight_m_ (index(i):index(i+1)),'b')
    ylim([0 2.5])
    yline(1.5,'r','LineWidth',1)
    text(0, 1.55,'1.5 m Cutoff','FontSize', 10)
    xlabel('Time')
    ylabel('Significant Wave Height (m)')
    title('Significant Wave Height Below Construction Thresehold')
i=i+2;


end

saveas(gcf ,[pwd '/Figures/Cutoff.png']);
%% Weather Window
i=1;
duration=index(2)-index(1)
while i<6
    
    figure(22)
    f22=figure(22);
    f22.WindowState = 'maximized';
    duration=index(i+1)-index(i)
    d_text=[num2str(duration) '  hours'];
    x_loc=(index(i+1)+index(i))/2;
    hold on
    plot(index(i):index(i+1),buoy_data.WaveHeight_m_(index(i):index(i+1)),'b')
    ylim([0 2.5])
    yline(1.5,'r','LineWidth',1)
    text(25, 1.55,'1.5 m Cutoff','FontSize', 10)
    hold on
    text(x_loc, .5,d_text,'FontSize', 10,'HorizontalAlignment', 'center')
    xline(index(i),'--r')
    hold on
    xline(index(i+1),'--r')
    xlabel('Hours')
    ylabel('Significant Wave Height (m)')
    title('Weather Window')
    
    
i=i+2;


end

saveas(gcf ,[pwd '/Figures/Window.png']);
%% Resource Assessment

% load('Wavh-waves.mat')
hmin=find(hm0>7 | tmm10 > 12);
hm0(hmin)=[];
tmm10(hmin)=[];
Hm0_Edges = [min(hm0): 1/2: max(hm0)];  
Te_Edges = [min(tmm10): 1/2: max(tmm10)];


rtow = [ 1.00 1.00 1.00
1.00 0.95 0.95
1.00 0.89 0.89
1.00 0.84 0.84
1.00 0.79 0.79
1.00 0.74 0.74
1.00 0.68 0.68
1.00 0.63 0.63
1.00 0.58 0.58
1.00 0.53 0.53
1.00 0.47 0.47
1.00 0.42 0.42
1.00 0.37 0.37
1.00 0.32 0.32
1.00 0.26 0.26
1.00 0.21 0.21
1.00 0.16 0.16
1.00 0.11 0.11
1.00 0.05 0.05
1.00 0 0
0.95 0 0
0.89 0 0
0.84 0 0
0.78 0 0
0.73 0 0
0.67 0 0
0.62 0 0
0.56 0 0
0.50 0 0];

figure(50)
f50=figure(50);
h = histogram2(tmm10,hm0,Te_Edges,Hm0_Edges);
xlabel('Te (s)')
ylabel('Hm0 (m)')
title('Histogram of Significant Wave Height vs Peak Period per occurance','FontSize',11)
h.FaceColor='Flat';
colormap(rtow)
colorbar;
c=colorbar;
c.Label.String='Number of Observations'

saveas(gcf ,[pwd '/Figures/Hm0vsTp_3D.png']);


[colormax] = wvscatter(hm0,tmm10,1)
title('Histogram of Significant Wave Height vs Peak Period')

saveas(gcf ,[pwd '/Figures/Hm0vsTp_2D.png']);



%% Extreme Points

x=[1:length(date)];
date=time./(60*60*24);
[peak,loc,widths,proms]= findpeaks(Hs,x,'MinPeakDistance',120,'MinPeakHeight',3.5);
 
%% Peak Graphs

    figure(70)
    f70=figure(70);
    f70.WindowState = 'maximized';
    hold on
%     findpeaks(Swan_Hsig,x,'MinPeakDistance',120,'MinPeakHeight',3.5);
    hold on
    plot(x,Hs,'b',loc,peak,'or')
    xlabel('Time')
    ylabel('Significant Wave Height (m)')
    title('Significant Wave Heightwith Storm Peaks 5 Days Apart', 'FontSize', 15)
    legend( 'Significant Wave Height','Storm Peaks','location', 'north')
    hold on
    text(x(loc),peak+.1, num2str(round(peak,2)),'HorizontalAlignment', 'center')
    xticks([0:(8760/12):8760+744])
    xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec','Jan'})
    
    saveas(gcf ,[pwd '/Figures/Extremes.png']);
    
