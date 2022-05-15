%% Data Creation:
xVals = twav
yVals = hwav;
xEdges = [min(hwav(28,:)): 1/2: max(hwav(28,:)) + 1];
yEdges = [min(twav(28,:)): 1/2: max(twav(28,:)) + 1];

%% Demo:
hFig = figure;
hAxes = axes(hFig);
normalized_histogram2(hAxes,xVals,yVals,xEdges,yEdges);

% make plot look beautiful:
xlabel('X Data');
ylabel('Y Data');
title('Normalized Histogram 2');
hFig.WindowState = 'maximized';