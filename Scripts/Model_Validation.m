close all
clear all

load('NewCombined Data 2010.mat')

%% Sig_Hi
figure(20)
f20=figure(20);
f20.WindowState = 'maximized';
subplot(2,1,1)
plot(Swan_date,Swan_hs,'b','LineWidth',2)
xlabel('Time','FontSize',15)
ylabel('Significant Wave Height (m)','FontSize',15)
title('Wave Buoy Significant Wave Height Over Time 2010','FontSize',24)
subplot(2,1,2)
plot(Swan_date,WH_hm0,'r')
xlabel('Time','FontSize',15)
ylabel('Significant Wave Height (m)','FontSize',15)
title('Wave Buoy Significant Wave Height Over Time 2010','FontSize',24)
% legend('Swan Model','Wave Buoy','FontSize',15)


%%  Q-Q Plots

figure(10)
qqplot(WH_hm0, Swan_hs);
xlabel('Wave Buoy Significant Wave Height Data','FontSize',15)
ylabel('Swan Model Significant Wave Height Data','FontSize',15)
title('QQ-Plot')




% %% Fit: 'Complete 2010'.
% 
% Full_R = corrcoef(WH_hm0, Swan_hs);
% R_95 = corrcoef(WH_95, Swan_95);
% R_99 = corrcoef(WH_99, Swan_99);
% % Set up fittype and options.
% ft = fittype( 'poly1' );
% 
% % Fit model to data.
% [fitresult, gof] = fit( WH_hm0, Swan_hs, ft );
% [fitresult95, gof95] = fit( WH_95, Swan_95, ft );
% [fitresult99, gof99] = fit( WH_99, Swan_99, ft );
% 
% corr=['Corr =' num2str(round(Full_R(1,2),2));'Corr =' num2str(round(R_95(1,2),2));'Corr =' num2str(round(R_99(1,2),2))];
%  r2=  [ 'R^2=' num2str(round(gof(1).rsquare,2)); 'R^2=' num2str(round(gof95(1).rsquare,2));'R^2=' num2str(round(gof99(1).rsquare,2)) ];
%   rmse=[  'RMSE=' num2str(round(gof(1).rmse,3));'RMSE=' num2str(round(gof95(1).rmse,2));'RMSE=' num2str(round(gof99(1).rmse,2))];
% %%
% 
% % Plot fit with data.
% figure( 'Name', 'Complete 2010' );
% plot( fitresult, WH_hm0,Swan_hs );
% % Label axes
% xlabel('Wave Buoy Significant Wave Height Data')
% ylabel('Swan Model Significant Wave Height Data')
% legend('Signifacant Wave Height', 'Fit Line','location','NorthWest','FontSize',11)
% dim = [0.7 0.3 0.3 0.1];
% str = {corr(1,:),r2(1,:),rmse(1,:)};
% annotation('textbox',dim,'String',str,'FitBoxToText','on')
% 
% 
% %%
% figure( 'Name', '95 Percentile' );
% plot( fitresult95,  WH_95, Swan_95 );
% xlabel('Wave Buoy Significant Wave Height Data')
% ylabel('Swan Model Significant Wave Height Data')
% legend('Signifacant Wave Height', 'Fit Line','location','NorthWest','FontSize',11)
% dim = [0.69 0.3 0.3 0.1];
% str = {corr(2,:),r2(2,:),rmse(2,:)};
% annotation('textbox',dim,'String',str,'FitBoxToText','on')
% 
% 
% figure( 'Name', '99 Percentile' );
% plot( fitresult99,  WH_99, Swan_99 );
% xlabel('Wave Buoy Significant Wave Height Data')
% ylabel('Swan Model Significant Wave Height Data')
% % legend('Signifacant Wave Height', 'Fit Line','location','NorthWest','FontSize',11)
% dim = [.69 .3 0.3 0.1];
% str = {corr(3,:),r2(3,:),rmse(3,:)};
% annotation('textbox',dim,'String',str,'FitBoxToText','on')
% 
% 
% 
