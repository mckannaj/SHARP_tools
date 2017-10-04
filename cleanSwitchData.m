% Zephy McKanna and Franziska Plessow
% plotSubjectRThist(subjData)
% 11/3/14
% 
% This function takes the Switch table created by formTables_EF_1A3() and
% cleans it the way Franziska did in SPSS.
%



function [success] = cleanSwitchData(switchTable)

    switchTable.RT = ((switchTable.RespTime - switchTable.StimTime) / 10); % set reaction time to correct milliseconds
    
    switchTable.cueTargetInterval = ones(height(delTable), 1) + 2; % set all the CTI to 3
    switchTable{switchTable{:,'Delay'} == 1500, 'cueTargetInterval'} = 1; % set short CTI to 1
    switchTable{switchTable{:,'Delay'} == 15000, 'cueTargetInterval'} = 2; % set long CTI to 2
    if (isempty(delTable{delTable{:,'cueTargetInterval'} == 3, 'cueTargetInterval'}) == 0) % BAD: somehow have a non-short non-long CTI
        error('aggregateSwitchData: somehow have a delay that isnt 1500 or 15000');
    end
    
%    switchTable.Properties.VariableNames{'Period'} = 'Period_String';
%    switchTable.Period = ones(height(delTable), 1) + 2; % set all the Period to 3
    
    switchTable(strcmp(switchTable{:,'Block'},'Training_1'), :) = []; % delete training/warmup rows
    switchTable(strcmp(switchTable{:,'Block'},'Training_2'), :) = []; % delete training/warmup rows
    switchTable(strcmp(switchTable{:,'Block'},'Warmup_1'), :) = []; % delete training/warmup rows
    switchTable(strcmp(switchTable{:,'Block'},'Warmup_2'), :) = []; % delete training/warmup rows
    switchTable(strcmp(switchTable{:,'Block'},'Warmup_3'), :) = []; % delete training/warmup rows
    switchTable(strcmp(switchTable{:,'Block'},'Warmup_4'), :) = []; % delete training/warmup rows

    


end