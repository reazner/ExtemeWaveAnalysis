function[colormax] = wvscatter(H,T,varargin)

%IGA - based on a function written by Sean Barrett

%The limits set in the plot (at the bottom of this file) are setup for the

%Wave Hub site. The error (Line 80) is not fatal, but Matlab seems to think

%it is.

%% Inputs

%
%H should be a single column containing significant wave heights
%T should be a single column containing Wave periods
%optional flag input for a couloured diagram. If this input exists, the
%diagram will be coloured with darker red indicating more records
%
%% Output
%colormax - is the maximum percentage for a cell. It is required to
%manually scale the colorbar
%Set the correct label for the wave period used
Tlab = 'T_{E} (s)';

%% Check input
inlen = length(varargin);
if inlen>0
    plotfile = varargin{1};
    if~ischar(plotfile)
        clear plotfile
        warning('Filename not recognised, scatter diagram figure not saved')
    end
end

%% create colors
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
%% Set the cells to be used
%Uncomment to fix the number of increments (or cells) 20
%minH = min(H);maxH = max(H);incH = round(((maxH-minH)/20)*100)/100;
%minT = min(T);maxT = max(T);incT = round(((maxT-minT)/20)*100)/100;
%Hlist = minH:incH:maxH;
%Tlist = minT:incT:maxT;
%OR
% this sets the maximum for H and T to 20
mH = 10;mT = 10;%set maxH and maxT as mH and mT
incH = 0.5;Hlist = 0:incH:mH;
incT = 0.5;Tlist = 0:incT:mT;%This is a manual set of the min max and increments on which the scatter diagram is calculated
%% Set the cells up
[Ts,Hs] = meshgrid(Tlist,Hlist); %grids for H and T
nH = (mH/incH)+1;nT = (mT/incT)+1;%setting the number of increments of H and T as nH and nT
z = zeros(nT,nH);
z_int = zeros(nT,nH);

%% Find the number (and proportion) of records in each cell
for i = 1:(nT*nH)
    zTs = find(T>=Ts(i) & T<(Ts(i)+incT));%zTs is locations of those Ts that fit in this grid
    if isempty(zTs)==0
        zH = H(zTs);%zH is the H values associated with the suitable Ts
        zHs = find(zH>=Hs(i) & zH<(Hs(i)+incH));%zHs is the locations in zTs of any Hs that fit in this grid square
        if isempty(zHs) ==0
            zlocs = zTs(zHs);%zlocs is therefore the locations of any points where H and T both match
            z(i) = length(zlocs);%and z(i) is set at the number of matching values
        else
            z(i) = 0;%no matching Hs
        end
    else
        z(i) = 0;%no matching Ts
    end
end
zp = ((z./length(H)).*100);%percentage of total occurrences
colormax = max(max(zp));

%% MAke the scatter diagram
figure1 = figure('PaperSize',[20.98 29.68],'Name','Time-series H,T,P');

fac = [1 2 3 4];
ecolor = 'k';
%load('rtow');
colormap(rtow);
mp = max(max(zp));%For setting the colour
for i = 1:mT/incT % period (columns)
        TA = Tlist(i); TB = Tlist(i+1);
    for j = 1:mH/incH % height (rows)
        HA = Hlist(j); HB = Hlist(j+1);
        if z(j,i) ~= 0
            prcnt = zp(j,i)./mp;%For setting the colours
            fc_index = ceil(29*prcnt);%assuming that the 29 relates to the number of color intervals
            if fc_index ==0
            fc_index = 1;
            end
            vert = [TA HA; TA HB; TB HB; TB HA];
            if inlen~=0
                patch('Faces', fac, 'Vertices', vert, 'Edgecolor',ecolor,'Facecolor',rtow(fc_index,:), 'linewidth', 1,'facealpha', 0.8);
            else
                patch('Faces', fac, 'Vertices', vert, 'Edgecolor',ecolor,'Facecolor','none', 'linewidth', 1,'facealpha', 0.8);
            end
            if zp(j,i)>=0.05
                text(TA+(incT/2), HA+(incH/2),num2str(zp(j,i),'%1.1f'),'fontsize',10,'FontName','Arial','fontweight', 'bold','backgroundcolor', 'none','horizontalalignment', 'center')
            elseif zp(j,i)<=0.05
                text(TA+(incT/2), HA+(incH/2),int2str(z(j,i)),'fontsize',8,'FontName','Arial','fontweight', 'bold','fontangle','italic','backgroundcolor', 'none','horizontalalignment', 'center')
            end
        end
    end
end

hold('all')
% for i = 1:mT/incT % period (columns)
%
% TA = Tlist(i); TB = Tlist(i+1);
%
% for j = 1:mH/incH % height (rows)
%
% HA = Hlist(j); HB = Hlist(j+1);
%
% if z_int(j,i)>0
% plot(TA+(incT/2), HA+(incH/2),'marker','o','MarkerSize',(incH)*(1000*z_int(j,i)),'Color',[0 0 1],'Linewidth',2);
% end
% end
% end
%surface(Ts,Hs,z)
xlabel('Tp','FontSize',14);
ylabel('H_{m0} (m)','FontSize',14);
xlim([0 ceil(max(T))]);
ylim([0 ceil(max(H))]);
text(1,7,['From ',int2str(length(H)), ' data'],'fontsize',14,'FontName','Arial')
set(gca,'FontSize',14)

%% Save figures
if exist('plotfile','var')
    saveas(figure1,plotfile,'fig');
    saveas(figure1,plotfile,'jpg');
end
