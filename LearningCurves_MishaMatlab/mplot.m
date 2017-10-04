function h = mplot(x, y, pname)
% A quick and simple line plotting routine that displays the names of the variables
% x, y are abscissa and ordinate respectively
% ptitle is the optional title 
figure;
if nargin < 2
    %varname = inputname(1);
    h = plot(x,'Linewidth',2);
    title(inputname(1));
    ylabel(inputname(1));
elseif  nargin <3
    h = plot(x,y,'Linewidth',2);
    title([inputname(2), ' vs ', inputname(1)])
    xlabel(inputname(1),'FontSize', 14);
    ylabel(inputname(2),'FontSize', 14);
else
    h = plot(x,y,'Linewidth',2);
    title(pname)
    xlabel(inputname(1),'FontSize', 14);
    ylabel(inputname(2),'FontSize', 14);
end