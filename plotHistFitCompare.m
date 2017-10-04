% Zephy McKanna
% plotHistFitCompare(data1, data2, plotTitle)
% 10/30/14
% 
% This function takes two sets of data, in either cell or matrix format,
% and turns them into histograms with a fitting program. It then plots both
% historgrams, and fits, on top of one another in the same plot.
% It also takes a string that it uses as a title for the figure.
%
% 
function [success] = plotHistFitCompare(histData1, histData2, fitData1, fitData2, plotTitle, data1Title, data2Title)

    hist1 = histData1;
    hist2 = histData2;
    if (iscell(histData1) == 1) % if this is a cell matrix, turn it into a regular matrix before using it
        hist1 = cell2mat(histData1);
        fprintf('plotHistFitCompare line 16: data1 is a cell array; reformatting it as a matrix.\n');
    end
    if (iscell(histData2) == 1) % if this is a cell matrix, turn it into a regular matrix before using it
        hist2 = cell2mat(histData2);
        fprintf('plotHistFitCompare line 20: data2 is a cell array; reformatting it as a matrix.\n');
    end
        
%    histfit(cell2mat(hist1(1:end, 1)));
%data1

% Z: what does this do???
subplot(2,1,1)

    histHandles1 = histfit(hist1,[],'gamma'); % handles(1) is the histogram and (2) is the density curve
    hold on; % display any additional plots on this same figure (don't automatically create another figure)
%    histfit(cell2mat(hist2(1:end, 1)));
    histHandles2 = histfit(hist2,[],'gamma'); % handles(1) is the histogram and (2) is the density curve
 
    histHandles = findobj(gca,'Type','patch'); % findobj somehow returns handles to these histograms
%    display(h) % in case you want to see the handles, for some reason...
 
    set(histHandles1(1),'FaceColor','b','EdgeColor','g'); % m = magenta, c = cyan
    set(histHandles1(2),'Color','r'); % m = magenta, c = cyan
    set(histHandles2(1),'FaceColor','m','EdgeColor','g'); % b = blue, g = green
    set(histHandles2(2),'Color','c'); % b = blue, g = green
    title(plotTitle);
    data1DistTitle = strcat(data1Title, 'dist');
    data2DistTitle = strcat(data2Title, 'dist');
    legend(data1Title,data1DistTitle,data2Title,data2DistTitle,'Location','northeast')
    hold off; % any new plots will create a new figure (default)

    
% Z: WE'RE DUPLICATING A LOT HERE; FIGURE OUT WHAT WE DON'T NEED AND CLEAN IT UP
    hist1 = histData1;
    hist2 = histData2;
    if (iscell(histData1) == 1) % if this is a cell matrix, turn it into a regular matrix before using it
        hist1 = cell2mat(histData1);
        fprintf('plotHistFitCompare: histData1 is a cell array; reformatting it as a matrix.\n');
    end
    if (iscell(histData2) == 1) % if this is a cell matrix, turn it into a regular matrix before using it
        hist2 = cell2mat(histData2);
        fprintf('plotHistFitCompare: histData2 is a cell array; reformatting it as a matrix.\n');
    end
    fitHist1 = fitData1;
    fitHist2 = fitData2;
    if (iscell(fitData1) == 1) % if this is a cell matrix, turn it into a regular matrix before using it
        fitHist1 = cell2mat(fitData1);
        fprintf('plotHistFitCompare: fitData1 is a cell array; reformatting it as a matrix.\n');
    end
    if (iscell(fitData2) == 1) % if this is a cell matrix, turn it into a regular matrix before using it
        fitHist2 = cell2mat(fitData2);
        fprintf('plotHistFitCompare: fitData2 is a cell array; reformatting it as a matrix.\n');
    end
    
    xrange = xlim;
    subplot(2,1,2) % z: what does subplot do????
    tmax = max([max(hist1),max(hist2)]); % grab the absolute max of the histograms to see how large the plot should be
    tt = linspace(0,tmax); % linspace splits the range given into 100 equal parts
    pd1 = fitdist(fitHist1,'Kernel','Support','positive');  % 'gamma' (z: support positive means no negative values allowed, i.e. gamma dist)
    pd2 = fitdist(fitHist2,'Kernel','Support','positive');
    f1 = pdf(pd1,tt);
    f2 = pdf(pd2,tt);
    plot(tt,f1,'r','LineWidth',2)
    hold on
    plot(tt,f2,'c','LineWidth',2)
%hist(hist1, tt);
 %   hist(hist2, tt);
    xlim(xrange);
    hold off

    
    success = true; % if we got here, it completed successfully.
end