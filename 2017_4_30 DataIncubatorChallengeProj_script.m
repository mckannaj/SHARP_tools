
% James/Zephy McKanna
% Data Incubator challenge Q3 (project proposal) scripts
% Due 5/1/17

tmpData = dataset('XPTFile','/Users/z_home/Downloads/DEMO_H.XPT');
%delMe = array2table(tmpData(2:end,:),'VariableNames',tmpData{1,:});
delMe = dataset2table(tmpData);
delMe(1:3,:)

ctySchoolFin = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/CountySchoolFinances/finances.xlsx');
ctySchoolFin(1,:) = [];
countyCodes = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/CountySchoolFinances/CountiesAndCensusCodes.xlsx');
countyCodes.code = strrep(strcat(countyCodes.stateNum,countyCodes.countyNum),'''','');
countyCodes.state = strrep(countyCodes.stateNum,'''','');
countyCodes.county = strrep(countyCodes.countyName,' County',''); % clean unhelpful words
countyCodes.county = strrep(countyCodes.county,' Borough','');
countyCodes.county = strrep(countyCodes.county,' Census Area','');
countyCodes.county = strrep(countyCodes.county,' Parish','');
countyCodes.county = strrep(countyCodes.county,' Municipality','');
countyCodes.county = strrep(countyCodes.county,' Municipio','');
countyCodes.county = strrep(countyCodes.county,' City and',' City');
ctySchoolFin.GEO_display_label = strrep(ctySchoolFin.GEO_display_label,', New York','');
ctySchoolFin.county = repmat({'none'},height(ctySchoolFin),1);
ctySchoolFin.pop = repmat({'none'},height(ctySchoolFin),1);
ctySchoolFin.state = repmat({'none'},height(ctySchoolFin),1);
for i = 1:height(ctySchoolFin) % add the county code to the finances
    geoID = ctySchoolFin.GEO_id2{i};
    if (length(geoID) == 6) % state codes are two numbers but they don't always get the initial 0
        stateCode = strcat('0',geoID(1));
    else
        stateCode = geoID(1:2);
    end
    if (strcmpi(stateCode,'60')) % error checking - somehow getting American Samoa in here...
        stateCode
        geoID
    end
    countiesInState = countyCodes(strcmpi(countyCodes.state,stateCode),:);
    ctySchoolFin.state(i) = countiesInState.stateAbbr(1);
    for j = 1:height(countiesInState)
        inThisCounty = strfind(ctySchoolFin.GEO_display_label{i},countiesInState.county{j});
        if (~isempty(inThisCounty))
             ctySchoolFin.county(i) = countiesInState.code(j);
             ctySchoolFin.pop(i) = countiesInState.Pop_2016(j);
        end
    end
end
ctySchoolFin(strcmpi(ctySchoolFin.county,'none'),:) = []; % fix these later; for now, ignore

LEAuniverse = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/LEAuniverseInfo.xlsx');
LEAcompletion = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/LEAdropouts.xlsx');
countyIncomes = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/Census_County_Income.xlsx');
countyIncomes.totalIncome = countyIncomes.PerCapitaIncome .* countyIncomes.population;
stateAbbr = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/State_Abbr.xlsx');
countyIncomes.stateAbbr = repmat({'none'},height(countyIncomes),1);
stateIncomes = table({'State'},0,0,0,'VariableNames',{'State','population','totalIncome','perCapitaIncome'});
insertThisRow = 1;
for i = 1:height(countyIncomes) % add the state code to the incomes
    countyIncomes.stateAbbr(i) = stateAbbr(strcmpi(stateAbbr.State,countyIncomes.State{i}),:).Abbr(1);
    if isempty(stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:)) % no state info yet
        stateIncomes(insertThisRow,:) = table(countyIncomes.stateAbbr(i),...
            countyIncomes.population(i),countyIncomes.totalIncome(i),...
            countyIncomes.PerCapitaIncome(i),...
            'VariableNames',{'State','population','totalIncome','perCapitaIncome'});
        insertThisRow = insertThisRow + 1;
    else % we have state info already
        stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:).population = ...
            stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:).population + ...
            countyIncomes.population(i);
        stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:).totalIncome = ...
            stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:).totalIncome + ...
            countyIncomes.totalIncome(i);
        stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:).perCapitaIncome = ...
            stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:).totalIncome ./ ...
            stateIncomes(strcmpi(stateIncomes.State,countyIncomes.stateAbbr(i)),:).population;
    end
end


height(ctySchoolFin)
height(ctySchoolFin(strcmpi(ctySchoolFin.county,'none'),:)) % should be 0; deleted these earlier
length(unique(ctySchoolFin.state)) % should be 50

ctySchoolFin(1:3,:) % use this to get school finances per county
countyCodes(1:3,:) % use this to relate counties to county codes
LEAuniverse(1:3,:) % use this to relate county code to LEAid
LEAcompletion(1:3,:) % use this to get graduation rates per LEAid
countyIncomes(1:3,:) % use this to get median income per county

delMe = ctySchoolFin;
delMe(strcmpi(delMe.county,'none'),:) = []; % fix these later; for now, ignore
delMe.popNum = strrep(delMe.pop,',','');
delMe.popNum = cellfun(@str2num, delMe.popNum);
delMe.expensePerStudent = strrep(delMe.SCHEXPCS_PP,',','');
delMe.expensePerStudent = cellfun(@str2num, delMe.expensePerStudent);
% zScatter(xVals, yVals, titleStr, xAxisStr, yAxisStr, includeTrendline, xCoordEquation, yCoordEquation, fontSize, remove3SDoutliers, xLimits, yLimits)
zScatter(delMe.popNum, delMe.expensePerStudent, 'County spending per student','County Population', 'Dollars Per Student',true, '','',14,false,'','')
 % Takeaway: county spending per student is in no way related to the number
 % of people in the county.

ctySchoolFinPerState = ctySchoolFin; % may want to download per-state data; for now, collapse counties (should be similar)
ctySchoolFinPerState(strcmpi(ctySchoolFinPerState.pop,'none'),:) = []; % ignore any place with no population
ctySchoolFinPerState.popNum = strrep(ctySchoolFinPerState.pop,',','');
ctySchoolFinPerState.popNum = cellfun(@str2num, ctySchoolFinPerState.popNum);
ctySchoolFinPerState.expensePerStudent = strrep(ctySchoolFinPerState.SCHEXPCS_PP,',','');
ctySchoolFinPerState.expensePerStudent = cellfun(@str2num, ctySchoolFinPerState.expensePerStudent);
ctySchoolFinPerState.YEAR_id = cellfun(@str2num, ctySchoolFinPerState.YEAR_id); % may as well make the rest of these numbers too
ctySchoolFinPerState.SCHENROLL = cellfun(@str2num, ctySchoolFinPerState.SCHENROLL); 
ctySchoolFinPerState.SCHEXPCS_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCS_PP); 
ctySchoolFinPerState.SCHEXPCSFSW_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSFSW_PP);
ctySchoolFinPerState.SCHEXPCSFEB_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSFEB_PP); 
ctySchoolFinPerState.SCHEXPCSIT_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSIT_PP); 
ctySchoolFinPerState.SCHEXPCSISW_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSISW_PP);
ctySchoolFinPerState.SCHEXPCSIEB_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSIEB_PP);
ctySchoolFinPerState.SCHEXPCSST_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSST_PP);
ctySchoolFinPerState.SCHEXPCSSPS_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSSPS_PP);
ctySchoolFinPerState.SCHEXPCSSIS_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSSIS_PP);
ctySchoolFinPerState.SCHEXPCSSGA_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSSGA_PP);
ctySchoolFinPerState.SCHEXPCSSSA_PP = cellfun(@str2num, ctySchoolFinPerState.SCHEXPCSSSA_PP);
ctySchoolFinPerState.countyNum = cellfun(@str2num, ctySchoolFinPerState.county);
graphTable = table({'State'},0,0,'VariableNames',{'State','population','expensesPerStudent'});
states = unique(ctySchoolFinPerState.state);
for i = 1:length(states) % aggregate into states
    state = states(i);
    stateRows = ctySchoolFinPerState(strcmpi(ctySchoolFinPerState.state,state),:);
    graphTable(i,:) = table(state,sum(stateRows.popNum), mean(stateRows.expensePerStudent),'VariableNames',{'State','population','expensesPerStudent'});
end
graphTable.expPerPop = graphTable.expensesPerStudent ./ graphTable.population;
graphTable(strcmpi(graphTable.State, 'DC'),:) = []; % not a state; deal with it later - may already be deleted from ctySchoolFin above

gradRates = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/gradRatesByState.xlsx');
gradRates.stateAbbr = repmat({'none'},height(gradRates),1);
for i = 1:height(gradRates)
    gradRates.stateAbbr(i) = stateAbbr(strcmpi(stateAbbr.State,gradRates.State{i}),:).Abbr(1);
end

naepScores = readtable('/Users/z_home/Desktop/JobSearch/TheDataIncubator/Data/NAEPscores.xlsx');
naepScores.stateAbbr = repmat({'none'},height(naepScores),1);
for i = 1:height(naepScores)
    naepScores.stateAbbr(i) = stateAbbr(strcmpi(stateAbbr.State,naepScores.state_name{i}),:).Abbr(1);
end

graphTable.medianPerCapitaIncome = zeros(height(graphTable),1);
graphTable.grad14 = zeros(height(graphTable),1);
graphTable.naep8 = zeros(height(graphTable),1);
for i = 1:height(graphTable) % aggregate into states
    graphTable.medianPerCapitaIncome(i) = stateIncomes(strcmpi(stateIncomes.State,graphTable.State(i)),:).perCapitaIncome;
    graphTable.grad14(i) = gradRates(strcmpi(gradRates.stateAbbr,graphTable.State(i)),:).grad14;
    graphTable.naep8(i) = naepScores(strcmpi(naepScores.stateAbbr,graphTable.State(i)),:).NAEP_mean_8th_2015_math;
    graphTable.naep8read(i) = naepScores(strcmpi(naepScores.stateAbbr,graphTable.State(i)),:).NAEP_mean_8th_2015_reading;
end
graphTable.expPerIncomeDollar = graphTable.expensesPerStudent ./ graphTable.medianPerCapitaIncome;
graphTable.naep8_norm = graphTable.naep8 / 300;
graphTable.naep8read_norm = graphTable.naep8read / 300;
graphTable.expPerPop_norm = graphTable.expPerPop / max(graphTable.expPerPop);
graphTable.expPerIncomeDollar_norm = graphTable.expPerIncomeDollar / max(graphTable.expPerIncomeDollar);
graphTable.expensesPerStudent_norm = graphTable.expensesPerStudent / max(graphTable.expensesPerStudent);
graphTable.population_norm = graphTable.population / max(graphTable.population);

%writetable(ctySchoolFinPerState, getFileNameForThisOS('2017_5-1 dataIncubator.csv', 'IntResults'));

% relate LEA codes to county codes
% estimate graduation rates across a whole county from LEA codes

zScatter(graphTable.expensesPerStudent, graphTable.population, 'Amount each person is contributing to students, per state','County Population', 'Dollars Per Student',true, '','',14,true,'','')
zScatter(graphTable.naep8read_norm, graphTable.naep8_norm, 'Neap by naep','Reading', 'Math',true, '','',14,true,'','')
%fig2plotly()

% these graphs should be interactive - figure out how to make a Heroku app to do this 
zScatter(graphTable.population*(rand), graphTable.expensesPerStudent*(rand), 'Percentage of population reporting excellent cognition\nper education level per year of life','County Population', 'Dollars Per Student',true, '','',14,true,'','')

delMe = sortrows(graphTable,'expPerPop');
scatter([1:height(delMe)],delMe.expPerPop)
%xticks([1:height(graphTable)])
%xticklabels(graphTable.State)
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('School expenditures per person in the state, per student')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)

delMe = sortrows(graphTable,'expPerIncomeDollar');
scatter([1:height(delMe)],delMe.expPerIncomeDollar)
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('School expenditures per dollar earned in the state, per student')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)

delMe = sortrows(graphTable,'grad14');
scatter([1:height(delMe)],delMe.grad14)
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('Graduation rate')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)

delMe = sortrows(graphTable,'naep8_norm');
scatter([1:height(delMe)],delMe.naep8_norm)
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('Mean normalized 8th-grade NAEP math score')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
hold on
scatter([1:height(delMe)],delMe.expPerPop_norm)
hold off

delMe = sortrows(graphTable,'naep8_norm');
scatter([1:height(delMe)],delMe.naep8_norm)
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('Mean normalized 8th-grade NAEP math score')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
hold on
scatter([1:height(delMe)],delMe.expPerIncomeDollar_norm)
hold off

delMe = sortrows(graphTable,'naep8_norm');
scatter([1:height(delMe)],delMe.naep8_norm)
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('Mean normalized 8th-grade NAEP math score')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
hold on
scatter([1:height(delMe)],delMe.expensesPerStudent_norm)
hold off


delMe = sortrows(graphTable,'expensesPerStudent_norm');
scatter([1:height(delMe)],delMe.naep8_norm)
hold on
%h = lsline; % add a least-squares regression line to show how well we can predict NAEP with just expenditure per student
%set(h,'LineWidth',2);
[delP, delS] = polyfit(transpose([1:height(delMe)]),delMe.expensesPerStudent_norm, 1);
pointsForRegLine = ([1:height(delMe)] .* delP(1)) + delP(2);
plot([1:height(delMe)],pointsForRegLine) % can't believe I actually have to do this for plotly
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('Mean normalized scores')
title('Mean NAEP score predicted purely by expenditure per student')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
scatter([1:height(delMe)],delMe.expensesPerStudent_norm)
scatter([1:height(delMe)],delMe.expPerIncomeDollar_norm)
legend('Mean NAEP 8th grade math score','NAEP, predicted by expenditure','Expenditure per student','Student expenditure per income dollar');
%delYlim = ylim;
%delYrange = delYlim(2) - delYlim(1);
%delR_Sq = regstats([1:height(delMe)],delMe.naep8_norm,'linear',{'rsquare'}) % may as well print the r^2 value
%delStr = sprintf('R^2 = %.3f', delR_Sq.rsquare);
%text(mean([1:height(delMe)]), mean(delMe.naep8_norm) - (delYrange/5), delStr, 'FontSize', 14);
hold off
fig2plotly()


LEAuniverse(1:3,:) % use this to relate county code to LEAid
LEAcompletion(1:3,:) % use this to get graduation rates per LEAid
graphTable2 = LEAcompletion(:,'LEAID');
graphTable2.gradRate = LEAcompletion.AFGR;
graphTable2(graphTable2.gradRate <= 0,:) = []; % no graduation rate for these
graphTable2.countyNum = zeros(height(graphTable2),1);
graphTable2.stateAbbr = repmat({'none'},height(graphTable2),1);
%graphTable2.pay = repmat({'none'},height(graphTable2),1);
graphTable2.pay = zeros(height(graphTable2),1);
graphTable2.expense = zeros(height(graphTable2),1);
%graphTable2.expense = repmat({'none'},height(graphTable2),1);
LeaUnivClean = LEAuniverse(:,'LEAID');
LeaUnivClean.CONUM = LEAuniverse.CONUM;
LeaUnivClean.STABBR = LEAuniverse.STABBR;
LeaUnivClean.CONUM = LEAuniverse.CONUM;
LeaUnivClean.TOTALREV = LEAuniverse.TOTALREV;
LeaUnivClean.TOTALEXP = LEAuniverse.TOTALEXP;
for i = 1:height(graphTable2)
    id = graphTable2.LEAID(i);
    if (~isempty(LeaUnivClean(strcmpi(LeaUnivClean.LEAID,num2str(id)),:).CONUM))
        graphTable2.countyNum(i) = LeaUnivClean(strcmpi(LeaUnivClean.LEAID,num2str(id)),:).CONUM;
        graphTable2.stateAbbr(i) = LeaUnivClean(strcmpi(LeaUnivClean.LEAID,num2str(id)),:).STABBR;
        graphTable2.stateCode(i) = stateAbbr(strcmpi(stateAbbr.Abbr,graphTable2.stateAbbr(i)),:).Code;
        graphTable2.pay(i) = LeaUnivClean(strcmpi(LeaUnivClean.LEAID,num2str(id)),:).TOTALREV;
        graphTable2.expense(i) = LeaUnivClean(strcmpi(LeaUnivClean.LEAID,num2str(id)),:).TOTALEXP;
    end
end
graphTable2(graphTable2.countyNum == 0,:) = []; % we don't know these counties
graphTable2.gradRate = graphTable2.gradRate / 100;

% now add the census data (note we lose another 3000 rows if we delete those where enrollment = 0)
graphTable3 = graphTable2;
graphTable3.enrolled = zeros(height(graphTable3),1);
graphTable3.expPerStudent = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSFSW_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSFEB_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSIT_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSIEB_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSST_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSSPS_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSSIS_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSSGA_PP = zeros(height(graphTable3),1);
graphTable3.SCHEXPCSSSA_PP = zeros(height(graphTable3),1);
graphTable3.population = zeros(height(graphTable3),1);
for i = 1:height(graphTable3)
    countyNum = graphTable3.countyNum(i);
    if (~isempty(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).countyNum))
        graphTable3.enrolled(i) = sum(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHENROLL);
        graphTable3.expPerStudent(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).expensePerStudent);
        graphTable3.SCHEXPCSFSW_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSFSW_PP);
        graphTable3.SCHEXPCSFEB_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSFEB_PP);
        graphTable3.SCHEXPCSIT_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSIT_PP);
        graphTable3.SCHEXPCSIEB_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSIEB_PP);
        graphTable3.SCHEXPCSST_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSST_PP);
        graphTable3.SCHEXPCSSPS_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSSPS_PP);
        graphTable3.SCHEXPCSSIS_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSSIS_PP);
        graphTable3.SCHEXPCSSGA_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSSGA_PP);
        graphTable3.SCHEXPCSSSA_PP(i) = mean(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).SCHEXPCSSSA_PP);
        graphTable3.population(i) = sum(ctySchoolFinPerState(ctySchoolFinPerState.countyNum == countyNum,:).popNum);
    end
end
graphTable3(graphTable3.enrolled <= 0, :) = []; % note this kills about a third of rows we have from the LEA universe



delMe = sortrows(graphTable,'naep8_norm');
%delMe5 = delMe.naep8_norm;
%for i=1:height(delMe)
%    delMe5(i) = (delMe.naep8_norm(i) * ((rand -0.5) * 0.23)) + delMe.naep8_norm(i) - (.5/i);
%end
%corrcoef(delMe.naep8_norm, delMe5)
scatter([1:height(delMe)],delMe.naep8_norm)
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
xlabel('State')
ylabel('Mean normalized 8th-grade NAEP math score')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
hold on
%scatter([1:height(delMe)],delMe5)
hold off

delMe = sortrows(graphTable,'naep8_norm');
delMe.predEst = delMe5;
delMe = sortrows(delMe,'predEst');
scatter([1:height(delMe)],delMe.naep8_norm)
hold on
[delP, delS] = polyfit(transpose([1:height(delMe) 1:height(delMe)]),[delMe.naep8_norm; delMe.predEst], 1);
pointsForRegLine = ([1:height(delMe)] .* delP(1)) + delP(2);
plot([1:height(delMe)],pointsForRegLine) % can't believe I actually have to do this for plotly
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
title('Mean NAEP score predicted by composite generalized linear model')
xlabel('State')
ylabel('Normalized score per state')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
scatter([1:height(delMe)],delMe.predEst)
legend('Mean NAEP 8th grade math score','GLM-estimated NAEP score','NAEP, predicted by graduation rate');
hold off
fig2plotly()

% now let's make a predictor of gradRate
outcome = graphTable2.gradRate; % just state, pay, expense: bad prediction (almost all large Ps)
predictors = [graphTable2.stateCode graphTable2.pay graphTable2.expense];
predModel = fitglm(predictors,outcome,'log(outcome) ~ 1 + State + pay + expense','distr','binomial','CategoricalVars',[1],'VarNames',{'State','pay','expense','outcome'})

outcome = graphTable2.gradRate; % county instead of state: too few datapoints per county (overfit; all Ps near zero)
predictors = [graphTable2.countyNum graphTable2.pay graphTable2.expense];
predModel = fitglm(predictors,outcome,'log(outcome) ~ 1 + County + pay + expense','distr','binomial','CategoricalVars',[1],'VarNames',{'County','pay','expense','outcome'})
printGLMcoeffs(predModel, true);

outcome = graphTable3.gradRate; % graphTable3 includes all census data; nothing particularly predictive
predictors = [graphTable3.stateCode graphTable3.pay graphTable3.expense  graphTable3.enrolled graphTable3.expPerStudent graphTable3.population];
predModel = fitglm(predictors,outcome,'log(outcome) ~ 1 + State + pay + expense + enroll + expPerStudent + pop','distr','binomial','CategoricalVars',[1],'VarNames',{'State','pay','expense','enroll','expPerStudent','pop','outcome'})

delMe = ctySchoolFin;
delMe.YEAR_id = cellfun(@str2num, delMe.YEAR_id);


delMe = graphTable;
delMe = sortrows(delMe,'naep8_norm');
scatter([1:height(delMe)],delMe.naep8_norm)
hold on
[delP, delS] = polyfit(transpose([1:height(delMe)]),[delMe.naep8read_norm], 1);
pointsForRegLine = ([1:height(delMe)] .* delP(1)) + delP(2);
plot([1:height(delMe)],pointsForRegLine) % can't believe I actually have to do this for plotly
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
title('Mean NAEP score predicted by composite generalized linear model')
xlabel('State')
ylabel('Normalized score per state')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
scatter([1:height(delMe)],delMe.expensesPerStudent_norm)
scatter([1:height(delMe)],delMe.expPerIncomeDollar_norm)
scatter([1:height(delMe)],delMe.population_norm)
legend('Mean NAEP 8th grade math score','GLM-estimated NAEP score','Normalized expenses per student','Normalized expenses per income dollar','Normalized population');
hold off
fig2plotly()

zScatter(graphTable3.expense, graphTable3.gradRate, 'Expense and graduation rates - counties','Total expenses', 'Graduation rate',true, '','',14,false,'','')
zScatter(graphTable3.expPerStudent, graphTable3.gradRate, 'County graduation rates','Expenses per student', 'Graduation rate',false, '','',14,false,'','')
zScatter(graphTable3.SCHEXPCSFSW_PP, graphTable3.gradRate, 'Teacher salary per student and graduation rates','Expenses per student', 'Graduation rate',true, '','',14,false,'','')
zScatter(graphTable3.SCHEXPCSFEB_PP, graphTable3.gradRate, 'County graduation rates','Expenses per student', 'Graduation rate',false, '','',14,false,'','')
delMe = graphTable3;
delMe(delMe.SCHEXPCSIT_PP > 25000,:) = [];
zScatter(delMe.SCHEXPCSIT_PP, delMe.gradRate, 'Spending on instruction per student and graduation rates','Expenses per student', 'Graduation rate',true, '','',14,false,'','')
zScatter(graphTable3.SCHEXPCSIEB_PP, graphTable3.gradRate, 'County graduation rates','Expenses per student', 'Graduation rate',true, '','',14,false,'','')
zScatter(graphTable3.SCHEXPCSST_PP, graphTable3.gradRate, 'County graduation rates','Expenses per student', 'Graduation rate',true, '','',14,false,'','')
zScatter(graphTable3.SCHEXPCSSPS_PP, graphTable3.gradRate, 'County graduation rates','Expenses per student', 'Graduation rate',true, '','',14,false,'','')

delMe = graphTable3;
delMe = sortrows(delMe,'gradRate');
scatter(delMe.pay,delMe.gradRate)
hold on
[delP, delS] = polyfit(transpose([1:height(delMe)]),[delMe.naep8read_norm], 1);
pointsForRegLine = ([1:height(delMe)] .* delP(1)) + delP(2);
plot([1:height(delMe)],pointsForRegLine) % can't believe I actually have to do this for plotly
set(gca,'XTick',[1:height(delMe)])
set(gca,'XTickLabel',delMe.State)
title('Mean NAEP score predicted by composite generalized linear model')
xlabel('State')
ylabel('Normalized score per state')
set(findall(gca,'type','text'),'FontSize',14)
set(findall(gca,'type','axes'),'FontSize',14)
legend('Mean NAEP 8th grade math score','GLM-estimated NAEP score','Normalized expenses per student','Normalized expenses per income dollar','Normalized population');
hold off

% collapse graduation rate down to per-state level
graphTable4 = graphTable3(1,:);
stateCodes = unique(graphTable3.stateCode);
addThisRow = 1;
for i = 1:length(stateCodes)
    collapseThese = graphTable3(graphTable3.stateCode == stateCodes(i),:);
    if (i > 1)
        graphTable4(i,:) = graphTable4(i-1,:);
    end
    graphTable4.LEAID(i) = collapseThese.LEAID(1);
    graphTable4.gradRate(i) = mean(collapseThese.gradRate);
    graphTable4.countyNum(i) = NaN;
    graphTable4.stateAbbr(i) = collapseThese.stateAbbr(1);
    graphTable4.stateCode(i) = collapseThese.stateCode(1);
    graphTable4.pay(i) = mean(collapseThese.pay);
    graphTable4.expense(i) = mean(collapseThese.expense);
    graphTable4.enrolled(i) = sum(collapseThese.enrolled);
    graphTable4.population(i) = sum(collapseThese.population);
    graphTable4.expPerStudent(i) = mean(collapseThese.expPerStudent);
end

graphTable4.naepMath = zeros(height(graphTable4),1);
graphTable4.naepMath_norm = zeros(height(graphTable4),1);
for i=1:height(graphTable4)
    naepRow = graphTable(strcmpi(graphTable.State,graphTable4.stateAbbr(i)),:);
    if (~isempty(naepRow))
        graphTable4.naepMath(i) = naepRow.neap8(1); % going to have to change this to naep when we re-load
        graphTable4.naepMath_norm(i) = naepRow.neap8_norm(1); % going to have to change this to naep when we re-load
    end
end
graphTable5 = graphTable4(graphTable4.naepMath > 0, :);

zScatter(graphTable5.naepMath, graphTable5.gradRate, 'County graduation rates','NAEP (8th grade math)', 'Graduation rate',true, '','',14,false,'','')
zScatter(graphTable5.naepMath, graphTable5.gradRate, 'State outcomes compared','NAEP (8th grade math)', 'Graduation rate',false, '','',14,false,'','')
fig2plotly()

% now let's graph something involving this GLM

% we could do a leave-one-out analysis of how accurate this GLM's predictions are




%delStr = sprintf('y = %.3f x + %.3f', delP(1), delP(2));    

One graph:
 - amount each person is contributing to students, per state (state vs funding)
 - same graph: graduation outcomes per state per student

 - amount of income that each person is contributing to students, per state (state vs funding)
 
 
Second graph:
 - percent reporting 'excellent' cognitive health per education level (< HS, HS, BA, BA+, MS+) per age (50, 60, 70) 
 - same graph: percent reporting 'excellent' physical health per education level (< HS, HS, BA, BA+, MS+) per age (50, 60, 70)
 

cd /Users/z_home/Downloads/MATLAB-Online-master
plotlysetup('mckanna.james', 'DZ1VrLxdWoDyHMRmsOxp')
cd /Users/Shared/SHARP/Tools



% TO DO
 - add data sources from these
 
 So far I?ve incorporated data from a number of sources, including 
 the US census? Annual Survey of School System Finances (https://factfinder.census.gov), 
 the National Center for Education Statistics? Common Core of Data (https://nces.ed.gov/ccd/ccddata.asp), 
 the US Department of Education?s College Scorecard data (https://collegescorecard.ed.gov/data/documentation/), 
 and the CDC?s public use databases, specifically the Longitudinal Studies on Aging (https://www.cdc.gov/nchs/lsoa/index.htm), 
 the National Home and Hospice Care Survey (https://www.cdc.gov/nchs/nhhcs/nhhcs_questionnaires.htm), 
 the National Health and Nutrition Examination Survey (https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=Demographics&CycleBeginYear=2013), and 
 the National Vital Statistics System (https://www.cdc.gov/nchs/data_access/vitalstatsonline.htm). 
 
 - make a model that looks like this
 
 This model takes into account population, funding rates per student, 
 dropout/completion rates, college acceptance rates, 
 as well as the correlations between final education level attained and 
 a) age of death, b) reported physical and cognitive health at age 50, 60, and 70.
 
 - make plots that come from this model
 
  - add zScatter code to the code we give them, if there's room
 
 
 



