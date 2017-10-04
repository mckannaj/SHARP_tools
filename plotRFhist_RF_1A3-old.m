% Zephy McKanna
% 
% 10/30/14
% 
% This function takes the output from the getRespTimes_RF_1A3() and plots 
% histograms of the response times for each subject (in each cluster?)
% 
function [] = plotRFhist_RF_1A3(correctRT, incorrectRT)
    histfit(cell2mat(correctRT(1:end, 3)));
    hold on; % display any additional plots on this same figure (don't automatically create another figure)
    histfit(cell2mat(incorrectRT(1:end, 3)));
 
    histHandles = findobj(gca,'Type','patch'); %findobj somehow returns handles to these histograms
%    display(h) % in case you want to see the handles, for some reason...
 
    set(histHandles(1),'FaceColor','m','EdgeColor','c'); % m = magenta, c = cyan
    set(histHandles(2),'FaceColor','b','EdgeColor','g'); % b = blue, g = green
    hold off; % any new plots will create a new figure (default)
end