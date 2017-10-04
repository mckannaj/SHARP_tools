% Script for Partial Order Analysis of RF Difficulty
% Reads partial order excel 
% References
% http://www.math.uah.edu/stat/foundations/Order.html
% See partially ordered sets http://en.wikipedia.org/wiki/Partially_ordered_set
% Plots Hasse diagram  (http://en.wikipedia.org/wiki/Hasse_diagram) 
%~~~~~~~~~~~~~~~~~~~~~~~
% TRANSITIONS are assumed to be from row i to col j
%~~~~~~~~~~~~~~~~~~~~~~~
% Using biorgraph objects, e.g.  POG = biograph(A,Snames);
% Properties of biograph
% get(POG), set(dgh, 'Label', 'Partial Order')
% POG.Nodes(i)
% POG.Edges(i)

%dir_adapt = 'C:\Users\pavelm\Documents\A_Projects\A_SHARP\AdaptiveProcedures';
%cd(dir_adapt);
%dir_curr = pwd;
%dir_tools = 'C:\Users\pavelm\Dropbox\Projects\SHARP\Tools';
%dir_data = 'C:\Users\pavelm\Dropbox\Projects\SHARP\ParsedData';

%cd(dir_data)
%if exist('trdataiso2.mat','file')
%    load('trdataiso.mat');  %2015_11_24-Mean_IsoTransitions_All.xlsx
%else
    excelranges = {
        'B1:Q1';   % Node Definitions B #, C is name, D timing, E level, F Shift name
        'B2:Q17';   % Transitions from row to column
        'B2:G17';   % WithinCluster:  Count	init_est stdErr_init	end_est	stdErr_end	diff_end_init
        % For the more detailed graph with 30 nodes
        'A2:A31';   % Node Definitions B #, C is name, D timing, E level, F Shift name
        'B2:AE31';   % Transitions from row to column
        'B2:G31';   % WithinCluster:  Count	init_est stdErr_init	end_est	stdErr_end	diff_end_init
   
        };
    fname = getFileNameForThisOS('2015_12_11 KernelClusterInfoMatrix_withL4shifts', 'IntResults');

    %Get node definitions   Transitions from ROW => COL
    [ndata, Snames] = xlsread(fname,'Info',excelranges{4}); %sheet = 'Avg_Clusters';
    [Deltraw, tdata] = xlsread(fname,'Transitions_Avg',excelranges{5}); 
    [Lrnraw, tdata] = xlsread(fname,'Info',excelranges{6}); %WithinCluster
    [Nraw, tdata] = xlsread(fname,'Transitions_Count',excelranges{5});  % was 'Transition_Count'
    fname = getFileNameForThisOS('2015_12_17 PartialOrder_ClustersAndL4shifts', 'ParsedData');
    [PO, tdata] = xlsread(fname,'PO',excelranges{5});  % was 'Transition_Count'
%end
clear ndata tdata excelranges

Ncl = length(Nraw);     % Number of clusters
DG = zeros(Ncl,Ncl);    % Directed graph of all transitions
DG(find(Nraw > 5)) = 1; % Eliminate all transitions with less than 5 samples
POs = sparse(PO);

% Modify cluster names for ploting and debug
for i=1:length(Snames)
    Snames{i} = strrep(Snames{i}, '_', '+');
    SnamesNo{i} = [num2str(i) '-' Snames{i}];  %Add node numbers for debuging
end

dgh = biograph(sparse(DG), Snames);
view(dgh)
PO = misha_TransitiveReduction(PO)
dgh = biograph(PO, Snames);
view(dgh)

% Compute distribution raw deltas in order to see how difficulty is
% reflected in the changes due to shift transitions
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

%Compute intial conditions for difficulty computation is used only for
%   nodes that do not have predcesessors 
Learn = -Lrnraw(:,2);  
Learn = Learn - min(Learn);  % To make difficulty positive
figure
barh(Learn)    %get(gca,'YTick')
set(gca,'YTick',1:Ncl)
set(gca,'YTickLabel',Snames)
xlabel('Initial Difficulty', 'FontSize', 14)

% Estimating difficulty only from transitions in PO
%Delt = - Delt;      % The difficulty is positive and is subtracted...
D = estimateDifficulty3(PO,-DeltPO,Learn);  % [D, order] could compute the topological sort
%D(4:end) =  D(4:end)-7;
[Ds,ix] = sort(D);
figure
barh(Ds)
set(gca,'YTick',[1:Ncl])
set(gca,'YTickLabel',Snames(ix))
xlabel('Average Difficulty', 'FontSize', 14)
% Write the results
Dcell{:,2} = mat2cell(D,[1 Ncl]); % zNOTE: This doesn't seem to work, but since we never actually use it again...?
T_results = table(D,'RowNames',SnamesNo)
filename = getFileNameForThisOS('2015_12_19 ClusterDifficutyEstimates_strictPO.csv', 'IntResults');
writetable(T_results,filename,'WriteRowNames',true);
%xlswrite('DifficultyScores',D)

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

% Remove reversed links to the starting nodes
% Display the resulting graph
DGt = DG;
DGt(:,[1:3]) = 0;  % Should also remove the transition values from Deltraw
for c = 1:Ncl    DGt(c,c) = 0;   end   % Diagonal must be null
dgh = biograph(DGt, Snames);
view(dgh)


% z messing: without eliminating 2-loops (or initial transitions?)
Delt = Deltraw;
Nrc = Nraw;
DG = zeros(Ncl,Ncl);    % Directed graph of all transitions
DG(find(Nraw > 5)) = 1; % Eliminate all transitions with less than 5 samples
DGt = DG;
DGt(:,[1:3]) = 0;  % If we do eliminate initial transitions, should also remove the transition values from Delt? Maybe doesn't matter...
for c = 1:Ncl    DGt(c,c) = 0;   end   % Diagonal must be null
dgh = biograph(DGt, Snames);
%view(dgh)



D = misha_estimateDifficulty3(DGt,-Delt,Learn,Nrc);  % [D, order] could compute the topological sort
%D(4:end) =  D(4:end)-7;
[Ds,ix] = sort(D);
figure
barh(Ds)
set(gca,'YTick',[1:Ncl])
set(gca,'YTickLabel',Snames(ix))
xlabel('Average Difficulty', 'FontSize', 14)
% Write the results
Dcell{:,2} = mat2cell(D,[1 Ncl]); % zNOTE: This doesn't seem to work, but since we never actually use it again...?
T_results = table(D,'RowNames',SnamesNo)
filename = getFileNameForThisOS('2015_12_19 ClusterDifficutyEstimates_onlyRemoving2loops.csv', 'IntResults');
writetable(T_results,filename,'WriteRowNames',true);


hold off
clear fname Snames Deltraw Lrnraw Nraw PO
clear Ncl DG POs SnamesNo dgh
clear h0 ih DeltPO ix DeltAPO r c 
clear Learn D Ds Dcell T_results 
clear Delt Nrc DGt
