% Zephy McKanna
% small utility script to visualize Ability estimates at the end of each
% shift, for each participant
% 1/5/16
%
%

subjNumList = unique(zKernelShiftEstimates_1B.Subject);
for row = 1:length(subjNumList)
    subjNum = subjNumList(row);
    subjShifts = zKernelShiftEstimates_1B(zKernelShiftEstimates_1B.Subject == subjNum, :);
    subjAbilityEstimates = subjShifts.end_KernelLogit_AllPositive; % start with the end-of-shift Kernel estimates
    subjAbilityEstimates = subjAbilityEstimates + subjShifts.diffEst; % add the cluster difficulty
    titleStr = sprintf('Ability (performance + difficulty) per shift\n(Subject number %d)', subjNum);
    zScatter(subjShifts.ShiftNum, subjAbilityEstimates, titleStr, 'Shift number', 'Ability estimate (end of shift)', false, '', '', '', false, '', '');
    pause(5);
end

clear subjNumList row subjNum subjShifts subjAbilityEstimates titleStr
