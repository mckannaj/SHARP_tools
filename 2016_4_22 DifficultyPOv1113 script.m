% 2016_4_22 DifficultyPOv1113 script
% BASED ON 2015_12_28 misha_DifficultyPOv1113 script.m
%
% This is intended to estimate the difficulty of shifts (with Nvals) in the
% same way that the 2015_12_28 file estimates the difficulty of clusters.
% 

load(getFileNameForThisOS('2016_4_22_zKernelShiftTransitions_Count_1B.mat', 'IntResults')); % loads zKernelShiftTransitions_Count_1B
load(getFileNameForThisOS('2016_4_22_zKernelShiftTransitions_Avg_1B.mat', 'IntResults')); % loads zKernelShiftTransitions_Avg_1B
load(getFileNameForThisOS('2016_4_22_zKernelShiftTransitions_diffSum_1B.mat', 'IntResults')); % loads zKernelShiftTransitions_diffSum_1B
load(getFileNameForThisOS('2016_4_22_zKernelShiftInfo_1B.mat', 'IntResults')); % loads zKernelShiftInfo_1B
load(getFileNameForThisOS('2016_4_23_shiftPO_1B.mat', 'ParsedData')); % loads shiftPO_1B

% there are a few Nvals that we never saw (e.g., Specializations_N1) - remove them 
delMe = zKernelShiftInfo_1B(zKernelShiftInfo_1B.Count==0,:);
excludeThese = delMe.Properties.RowNames;
infoWithoutExcluded = zKernelShiftInfo_1B;
infoWithoutExcluded(ismember(infoWithoutExcluded.Properties.RowNames, excludeThese),:) = []; % delete the excluded shifts
transAvgWithoutExcluded = zKernelShiftTransitions_Avg_1B;
transAvgWithoutExcluded(ismember(transAvgWithoutExcluded.Properties.RowNames, excludeThese),:) = []; % delete the excluded shifts
transAvgWithoutExcluded(:,ismember(transAvgWithoutExcluded.Properties.VariableNames, excludeThese)) = []; % delete the excluded shifts
transCountWithoutExcluded = zKernelShiftTransitions_Count_1B;
transCountWithoutExcluded(ismember(transCountWithoutExcluded.Properties.RowNames, excludeThese),:) = []; % delete the excluded shifts
transCountWithoutExcluded(:,ismember(transCountWithoutExcluded.Properties.VariableNames, excludeThese)) = []; % delete the excluded shifts
POWithoutExcluded = shiftPO_1B;
POWithoutExcluded(ismember(POWithoutExcluded.Properties.RowNames, excludeThese),:) = []; % delete the excluded shifts
POWithoutExcluded(:,ismember(POWithoutExcluded.Properties.VariableNames, excludeThese)) = []; % delete the excluded shifts

Snames = infoWithoutExcluded.Properties.RowNames;
Deltraw = table2array(transAvgWithoutExcluded);
Lrnraw = table2array(infoWithoutExcluded);
Nraw = table2array(transCountWithoutExcluded);
PO = table2array(POWithoutExcluded);

clear delMe excludeThese infoWithoutExcluded transAvgWithoutExcluded transCountWithoutExcluded POWithoutExcluded

Ncl = length(Nraw);     % Number of clusters
Learn = -Lrnraw(:,2);  
Learn = Learn - min(Learn);  % To make difficulty positive




% Modify cluster names for ploting and debug
for i=1:length(Snames)
    Snames{i} = strrep(Snames{i}, '_', '+');
    SnamesNo{i} = [num2str(i) '-' Snames{i}];  %Add node numbers for debuging
end


% Compute distribution raw deltas in order to see how difficulty is reflected in the changes due to shift transitions
%   (note: this makes three histograms, total)
% Compute distribution of all raw deltas
[h0, ih] = histcounts(Deltraw(:),30);
figure
subplot(3,1,1)
histogram(Deltraw(:),ih,'FaceAlpha',0.3,'FaceColor','g');
title('Shift Transitions')
xlabel('Transition cost \Delta in logit')
hold on
%--------
%Compute the distribution of Delta for paths along the PO
DeltPO = zeros(size(Deltraw));
ix = PO ~= 0;
DeltPO(ix) = Deltraw(ix);
DeltPO(DeltPO == 0) = NaN;
% figure Deltas along the partial order
subplot(3,1,2)
histogram(DeltPO(~isnan(DeltPO)),ih,'FaceAlpha',0.3,'FaceColor','b');
%Compute the distribution of Delta for paths oposing the PO
DeltAPO = [];
for c = 1:Ncl
    for r = 1:Ncl
        if PO(r,c) && ~isnan(Deltraw(c,r)) 
            DeltAPO = [ DeltAPO Deltraw(c,r)]; 
        end
    end
end
subplot(3,1,3)
histogram(DeltAPO(:),ih,'FaceAlpha',0.3,'FaceColor','r')
%ylim([0 35]);
xlabel('Transition cost \Delta in logit')

clear h0 ih DeltPO ix DeltAPO 




%************************************************
%Include all transitions in the difficulty estimation eliminating 2-loops
% Examine by-directional links and eliminate the less frequent ones
Delt = Deltraw;
Nrc = Nraw;
DG = zeros(Ncl,Ncl);    % Directed graph of all transitions
DG(find(Nraw > 5)) = 1; % Eliminate all transitions with less than 5 samples
for c = 1:Ncl % now eliminate all 2-loops
    for r = c:Ncl
        if DG(c,r) & DG(r,c)
            fprintf('(%2d %2d) %f %f %d %d\n', c, r, Deltraw(c,r), Deltraw(r,c),Nraw(c,r), Nraw(r,c));
            if Nraw(c,r) > Nraw(r,c)
                DG(r,c) = 0;
                Delt(r,c) = 0;
                Nrc(r,c) = 0;
            else
                DG(c,r) = 0;
                Delt(c,r) = 0;
                Nrc(c,r) = 0;
            end
        end
    end
end

% Remove reversed links to the starting nodes (NO LONGER MAKES SENSE; FIRST THREE ARE NOT THE "STARTING" NODES) 
% Display the resulting graph
DGt = DG;
% no longer makes sense; first three are not the starting nodes    DGt(:,[1:3]) = 0;  % Should also remove the transition values from Deltraw
for c = 1:Ncl    DGt(c,c) = 0;   end   % Diagonal must be null
dgh = biograph(DGt, Snames);
view(dgh)


% z messing: without eliminating 2-loops (or initial transitions?)
Delt = Deltraw;
Nrc = Nraw;
DG = zeros(Ncl,Ncl);    % Directed graph of all transitions
DG(find(Nraw > 5)) = 1; % Eliminate all transitions with less than 5 samples
DGt = DG;
% no longer makes sense; first three are not the starting nodes    DGt(:,[1:3]) = 0;  % If we do eliminate initial transitions, should also remove the transition values from Delt? Maybe doesn't matter...
for c = 1:Ncl    DGt(c,c) = 0;   end   % Diagonal must be null
dgh = biograph(DGt, Snames);
%view(dgh)


zNOTE: if this works, save the variable files over the old ones!!!
    (and put a note into the word doc indicating that you have to get rid of jump-backs)

D = misha_estimateDifficulty3(DGt,-Delt,Learn,Nrc);  % [D, order] could compute the topological sort
%D(4:end) =  D(4:end)-7;
[Ds,ix] = sort(D);
figure
barh(Ds)
set(gca,'YTick',[1:Ncl])
dispNames = strrep(Snames, '_', '+');
set(gca,'YTickLabel',dispNames(ix))
xlabel('Average Difficulty', 'FontSize', 14)
delMe = table(ix, dispNames(ix), Ds, 'VariableNames', {'Index', 'Name','Difficulty'})

figure
bar(Ds)
set(gca,'XTick',[1:Ncl])
dispNames = strrep(Snames, '_', '+');
set(gca,'XTickLabel',dispNames(ix))
ylabel('Average Difficulty', 'FontSize', 14)
% Write the results
Dcell{:,2} = mat2cell(D,[1 Ncl]); % zNOTE: This doesn't seem to work, but since we never actually use it again...?
T_results = table(D,'RowNames',SnamesNo)
filename = getFileNameForThisOS('2016_4_22 ShiftDifficutyEstimates_onlyRemoving2loops.csv', 'IntResults');
writetable(T_results,filename,'WriteRowNames',true);


hold off
clear fname Snames Deltraw Lrnraw Nraw PO
clear Ncl DG POs SnamesNo dgh
clear h0 ih DeltPO ix DeltAPO r c 
clear Learn D Ds Dcell T_results 
clear Delt Nrc DGt dispNames
clear delMe excludeThese infoWithoutExcluded transAvgWithoutExcluded transCountWithoutExcluded POWithoutExcluded


