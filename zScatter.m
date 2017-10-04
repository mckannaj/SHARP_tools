% Zephy McKanna
% zScatter
% 8_5_15
%
% This function creates a scatter plot using the scatter() function, but
% also puts the specified axis labels on it, creates a linear trend line,
% and displays the equation and R-squared value for that line.
% 
% xVals = a one-column list of X values; must have same length as yVals
% yVals = a one-column list of Y values; must have same length as xVals
% titleStr = a string for the graph title (may include \n for multi-line), or '' for no title
% xAxisStr = a string for the X axis label (may include \n for multi-line), or '' for no label
% yAxisStr = a string for the Y axis label (may include \n for multi-line), or '' for no label
% xCoordEquation = the X coordinate for displaying the trend line equation, or '' for default placement 
% yCoordEquation = the Y coordinate for displaying the trend line equation, or '' for default placement 
% fontSize = the font size for the graph, or '' for default (14 for trendline, and slightly larger for the axes labels)
% remove3SDoutliers = true to remove <>3SDs outliers, or false otherwise
%
% xLimits and yLimits = two-item lists (e.g. [0 15]) defining the limits of
% X and Y, respectively. Points outside these bounds will be removed. This
% is for quick removal of known outliers, for ease of display /
% understanding the data. If no such limits should be imposed, set these
% variables to ''.
%
function [] = zScatter(xVals, yVals, titleStr, xAxisStr, yAxisStr, includeTrendline, xCoordEquation, yCoordEquation, fontSize, remove3SDoutliers, xLimits, yLimits)
    if (nargin ~= nargin('zScatter'))
        error('zError: zScatter expects %d inputs, but received %d. Please update any calling code.\n', nargin('zScatter'), nargin);
    end
    
    if (isempty(fontSize))
        fontSize = 14; % default
    elseif (fontSize == 0)
        fontSize = 14; % default
    end

    if (remove3SDoutliers == true) % remove items that are <>3SDs from the mean
        fprintf('zScatter: We may have some <>3SDs in the X data which will be deleted from both lists; here is the list:\n');
        lowXbound = mean(xVals) - (3 * std(xVals))
        highXbound = mean(xVals) + (3 * std(xVals))
        xOutliers = xVals(((xVals < lowXbound) | (xVals > highXbound)), :) % identify the X outliers
        yVals(ismember(xVals, xOutliers), :) = []; % remove the X outliers from Y (must do this first, otherwise we lose the place in the X list)
        xVals(ismember(xVals, xOutliers), :) = []; % remove the X outliers from X
        fprintf('zScatter: After removing those, we also may have some <>3SDs in the Y data which will be deleted from both lists; here is the list:\n');
        lowYbound = mean(yVals) - (3 * std(yVals))
        highYbound = mean(yVals) + (3 * std(yVals))
        yOutliers = yVals(((yVals < lowYbound) | (yVals > highYbound)), :)
        xVals(ismember(yVals, yOutliers), :) = []; % remove the Y outliers from X (must do this first, otherwise we lose the place in the Y list)
        yVals(ismember(yVals, yOutliers), :) = []; % remove the Y outliers from Y 
        if (length(xVals) ~= length(yVals))
            fprintf('zScatter: something weird going on here! xVals length = %d and yVals length = %d; should be equal!\n', length(xVals), length(yVals));
        end
    end
    if (~isempty(xLimits)) % remove items that are outside of this X range
        if (length(xLimits) ~= 2) 
            error('xLimits must be a two-item list, defining the bounds of X.');
        end
        fprintf('zScatter: removing items that are outside the X range %d to %d:\n', xLimits(1), xLimits(2));
        lowXbound = xLimits(1);
        highXbound = xLimits(2);
        xOutliers = xVals(((xVals < lowXbound) | (xVals > highXbound)), :) % identify the X outliers
        yVals(ismember(xVals, xOutliers), :) = []; % remove the X outliers from Y (must do this first, otherwise we lose the place in the X list)
        xVals(ismember(xVals, xOutliers), :) = []; % remove the X outliers from X
    end
    if (~isempty(yLimits)) % remove items that are outside of this X range
        if (length(yLimits) ~= 2) 
            error('yLimits must be a two-item list, defining the bounds of Y.');
        end
        fprintf('zScatter: removing items that are outside the Y range %d to %d:\n', yLimits(1), yLimits(2));
        lowYbound = yLimits(1);
        highYbound = yLimits(2);
        yOutliers = yVals(((yVals < lowYbound) | (yVals > highYbound)), :)
        xVals(ismember(yVals, yOutliers), :) = []; % remove the Y outliers from X (must do this first, otherwise we lose the place in the Y list)
        yVals(ismember(yVals, yOutliers), :) = []; % remove the Y outliers from Y 
    end
    
%    xVals
%    yVals
    scatter(xVals, yVals, 'filled', 'MarkerEdgeColor', 'blue') 
    
    if (includeTrendline == true)
        h = lsline; % add a least-squares regression line just for the ability coefficients
        set(h,'LineWidth',2);

        delYlim = ylim;
        delYrange = delYlim(2) - delYlim(1);

        [delP, delS] = polyfit(xVals, yVals, 1);
        delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));    
        if (~isempty(xCoordEquation))
            text(xCoordEquation, yCoordEquation, delStr, 'FontSize', fontSize); % and put it on the graph
        else
            text(mean(xVals), mean(yVals) - (delYrange/10), delStr, 'FontSize', fontSize); % and put it on the graph
        end

        delR_Sq = regstats(xVals,yVals,'linear',{'rsquare'}) % may as well print the r^2 value
        delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
        if (~isempty(xCoordEquation))
            text(xCoordEquation, yCoordEquation - (delYrange/10), delStr, 'FontSize', fontSize); % and put it on the graph
        else
            text(mean(xVals), mean(yVals) - (delYrange/5), delStr, 'FontSize', fontSize);
        end
    end
    
    if (~isempty(titleStr))
        str = sprintf(titleStr); % this puts any \n characters into the string properly
        title(str);
    end
    if (~isempty(xAxisStr))
        str = sprintf(xAxisStr); % this puts any \n characters into the string properly
        xlabel(str)
    end
    if (~isempty(yAxisStr))
        str = sprintf(yAxisStr); % this puts any \n characters into the string properly
        ylabel(str)
    end
    set(findall(gca,'type','text'),'FontSize',fontSize+8)
    set(findall(gca,'type','axes'),'FontSize',fontSize+4)
end