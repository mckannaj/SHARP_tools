

% Script to estimate learning curves
clear all
verbose = false;
addpath('C:\Users\pavelm\Documents\Matlab_local\tools_local')
dir_tools = 'C:\Users\pavelm\Dropbox\Projects\SHARP\Tools';
dir_current = pwd;
cd(dir_tools);
load '2016_1_27-zKernelShiftEstimates_1B.mat';

% figure
% for cn=1:Nclust
%     plot([cn,cn+1],[1,2],'Color', linecolors(cn,:))
%     hold on
% end

cd(dir_current);
load 'goodSubjList';
ADest = zKernelShiftEstimates_1B;
clear zKernelShiftEstimates_1B

allSubjList = unique(ADest.Subject);
Lia = ismember(allSubjList,goodSubjList);

Condcell = unique(ADest.Condition);
Clustcell = unique(ADest.Cluster);
% Numericcal reprsention of conditions
Nsub = length(allSubjList);
Nclust = length(Clustcell);
Ntrial = height(ADest);
% Make colors for plots
htmp = ((0:(Nclust-1))/Nclust)';
hsv = [htmp, ones(Nclust,2)];
linecolors = hsv2rgb(hsv);
% Numerical cluster number
CondNum = zeros(Ntrial,1);
ClustNum = zeros(Ntrial,1);
for tn=1:Ntrial
    CondNum(tn) = findstrcell(Condcell, ADest.Condition{tn});
    ClustNum(tn) = findstrcell(Clustcell, ADest.Cluster{tn});
end
ADest.CondNum = CondNum;    % Append data table with condition numbers
ADest.ClustNum = ClustNum;  % Append data table with cluster numbers
VarNames = ADest.Properties.VariableNames;

for sn = 1:length(allSubjList)  % sn = 90
    subjNum = allSubjList(sn);
    disp (['Number ' num2str(sn)  'ID ' num2str(subjNum)])
    SubjADest = ADest(ADest.Subject == subjNum, :);
    for cln = 1:Nclust
        clustSubjADest = SubjADest(SubjADest.ClustNum == cln,:);
        clustAestimates = clustSubjADest.end_KernelLogit_AllPositive;
        clustAestimates = clustAestimates + clustSubjADest.diffEst;
        plot(clustSubjADest.Date,clustAestimates,'LineWidth', 2, 'Color', linecolors(cln,:) ); 
        hold on
    end
    titleStr = sprintf('Ability (Subj%d)',...
        subjNum);
    title(titleStr);
    pause
    hold off
end
        
        
    subjAbilityEstimates = subjShiftEstimates.end_KernelLogit_AllPositive;
    subjAbilityEstimates = subjAbilityEstimates + subjShiftEstimates.diffEst;
    conds = subjShiftEstimates.Condition{1};
    condn(sn) = subjShiftEstimates.CondNum{sn};
    for cln = 1:Nclust




for sn = 1:length(allSubjList)  % sn = 90
    subjNum = allSubjList(sn);
    disp (['Number ' num2str(sn)  'ID ' num2str(subjNum)])
    subjShiftEstimates = ADest(ADest.Subject == subjNum, :);
    subjAbilityEstimates = subjShiftEstimates.end_KernelLogit_AllPositive;
    subjAbilityEstimates = subjAbilityEstimates + subjShiftEstimates.diffEst;
    conds = subjShiftEstimates.Condition{1};
    condn(sn) = findstrcell(condcell,conds);
      
    yhat = loess_m(subjShiftEstimates.ShiftNum,subjAbilityEstimates,subjShiftEstimates.ShiftNum,15,deg);
    % Fitting learning curves
    x = subjShiftEstimates.ShiftNum;
    [f, gof] = fit(x , subjAbilityEstimates, ft,...
        'StartPoint',[1 1 0.1],...          % Starting point
        'Lower', [0, 0, 0]);
    par(sn,:) = [f.a0, f.a1, f.a2];
    ahat = par(sn,1) +  par(sn,2).*x.^ par(sn,3);
    atotal(sn) = ahat(end) - ahat(1);
   if verbose
       titleStr = sprintf('Ability (Subject number %d) \nParameters %8.1f  %8.1f  %6.3f', subjNum,par(sn,1),par(sn,2),par(sn,3));
    zScatter(x, subjAbilityEstimates, titleStr, 'Shift number', 'Ability estimate (end of shift)', false, '', '', '', false, '', '');
    hold on
    plot(x, yhat, 'Color', 'red', 'LineWidth', 2)
    plot(x,ahat,'b','LineWidth',2)
   % plot( f, x, subjAbilityEstimates, 'b');
    hold off
    pause
   end
end
% Compute slope of the learning function at x = 100
x100 = 100;     % Compute the slope here
slopel = par(:,2).*par(:,3)./power(x100,1 - par(:,3));

% Exclude outliers
slope95 = prctile(slopel,95);
ix = find(slopel <= slope95);   % ix contains good subjects
goodSubjList = allSubjList(ix);
save('goodSubjList','goodSubjList');
slopel = slopel(ix);
goodcond = condn(ix);
par = par(ix,:);
atotal = atotal(ix);

figure
boxplot(slopel,goodcond,'labels',condcell);
title('Slopes of Learning Curves','FontSize', 14);
ylabel('Slope','FontSize', 14)
xlabel('Condition','FontSize', 14);

figure
boxplot(par(:,3),goodcond,'labels',condcell);
title('Exponent of Learning Curves','FontSize', 14);
ylabel('Exponent','FontSize', 14)
xlabel('Condition','FontSize', 14);

figure
boxplot(atotal,goodcond,'labels',condcell);
title('Total Learning','FontSize', 14);
ylabel('Ability Gain','FontSize', 14)
xlabel('Condition','FontSize', 14);

