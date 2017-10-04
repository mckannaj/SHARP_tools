
%{ 
Still thinking about Q1....


% first, make a count of prices from N to (N*(N+1))/2
N = 20;
priceCounts = transpose(20:210);
priceCounts(:,2) = zeros(length(priceCounts),1);
initSeqs = []; % so far, we haven't tried any initial sequences
[priceCounts, initSeqs] = dataIncubatorQ1build(10, initSeqs, priceCounts, N, true);

% now, run the build for a half hour (10sec/per), to build up the price counts
for i = 1:1800
    fprintf('Staying alive feedback; i = %d.\n', i);
    [priceCounts, initSeqs] = dataIncubatorQ1build(10, initSeqs, priceCounts, N, false);
end

initSeqs
priceCounts

for i=1:length(priceCounts)
    prices = 
    
mean(priceCounts(:,2))
std(priceCounts(:,2))

prices = priceCounts(:,2) .* priceCounts(:,1)
sum(prices) / sum(priceCounts(:,2))

% delMe = dataIncubatorQ1sim(20, 10000); % 10000 repetitions
%   Mean payment = 143.641500, SD = 18.316559
%   Mean payment = 143.997000, SD = 18.129856
%   Mean payment = 142.536000, SD = 18.809106
%   Mean payment = 143.647000, SD = 18.641993
% Mean payment = 143.577600, SD = 18.533832; probGreaterThan = 0.198100
% Mean payment = 143.577600, SD = 18.533832; probGreaterThan = 0.198100
% Mean payment = 143.548600, SD = 18.491729; probGreaterThan = 0.202500

tic
delMe = dataIncubatorQ1sim(20, 1000000, 160);
toc
% delMe = dataIncubatorQ1sim(20, 10000); % 100000 repetitions
%   Mean payment = 143.437030, SD = 18.449542
%   Mean payment = 143.424740, SD = 18.471291
%   Mean payment = 143.537640, SD = 18.438567
%   Mean payment = 143.468310, SD = 18.438517
%Mean payment = 143.375000, SD = 18.467222; probGreaterThan = 0.197070

% delMe = dataIncubatorQ1sim(20, 10000); % 1000000 repetitions
%   Mean payment = 143.499884, SD = 18.431979
%   Mean payment = 143.493695, SD = 18.440592
% Mean payment = 143.471503, SD = 18.440996; probGreaterThan = 0.197551
% Mean payment = 143.526290, SD = 18.419741; probGreaterThan = 0.198387

%}




% James/Zephy McKanna
% Data Incubator challenge Q2 script
% Due 5/1/17

% First question
data2013 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2013_14_PP.xlsx');
fourYearColleges = data2013(data2013.ICLEVEL == 1, :);
fouryearOPE = unique(fourYearColleges.OPEID);
avgSATs = table(0,0,'VariableNames',{'students','avgSAT'});
insertThisRow = 1;
for index = 1:length(fouryearOPE)
    id = fouryearOPE(index);
    fprintf('Staying alive feedback; id = %d.\n', id);
    curRows = fourYearColleges(fourYearColleges.OPEID == id, :);
    for row = 1:height(curRows) % should usually be only 1, but not always
        curRow = curRows(row, :);
        curAdmitted = str2num(curRow.UGDS{1}) / 4; % approx admitted students
        if ( (strcmpi(curRow.SATVR25{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATVR75{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATMT25{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATMT75{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATWR25{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATWR75{1},'NULL') == 1) )
        else % if we don't have these, assume they're the global mean and ignore
            meanSAT = mean([str2num(curRow.SATVR25{1}) str2num(curRow.SATVR75{1})]) +...
                mean([str2num(curRow.SATMT25{1}) str2num(curRow.SATMT75{1})]) +...
                mean([str2num(curRow.SATWR25{1}) str2num(curRow.SATWR75{1})]);
            avgSATs(insertThisRow,:) = table(curAdmitted,meanSAT,...
                'VariableNames',{'students','avgSAT'});
            insertThisRow = insertThisRow + 1;
        end
    end
end
totalSAT = avgSATs.students .* avgSATs.avgSAT;
totalAvgSAT = sum(totalSAT) / sum(avgSATs.students) % 1.668916867283165e+03
clear fourYearColleges fouryearOPE avgSATs insertThisRow index id curRows row
clear curAdmitted meanSAT totalSAT totalAvgSAT
        
% Second question
allOPE = unique(data2013.OPEID);
enrollmentAndSATs = table(0,0,0,'VariableNames',{'OPEid','enrolledAfter2years','avgSAT'});
insertThisRow = 1;
for index = 1:length(allOPE)
    id = allOPE(index);
    fprintf('Staying alive feedback; id = %d.\n', id);
    curRows = data2013(data2013.OPEID == id, :);
    for row = 1:height(curRows) % should usually be only 1, but not always
        curRow = curRows(row, :);
        curAdmitted = str2num(curRow.UGDS{1}) / 4; % approx admitted students
        meanSAT = -1; % flag to indicate missing data
        estTwoYearRetention = -1; % same
        if ( (strcmpi(curRow.SATVR25{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATVR75{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATMT25{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATMT75{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATWR25{1},'NULL') == 1) || ...
                (strcmpi(curRow.SATWR75{1},'NULL') == 1) )
        else % we need all of these to calculate avg SAT and retention
            meanSAT = mean([str2num(curRow.SATVR25{1}) str2num(curRow.SATVR75{1})]) +...
                mean([str2num(curRow.SATMT25{1}) str2num(curRow.SATMT75{1})]) +...
                mean([str2num(curRow.SATWR25{1}) str2num(curRow.SATWR75{1})]);
        end
        retentionRates = [];
        if (strcmpi(curRow.RET_FT4{1},'NULL') == 0) % there's a value here
            retentionRates = [retentionRates; str2num(curRow.RET_FT4{1})];
        end
        if (strcmpi(curRow.RET_FTL4{1},'NULL') == 0) 
            retentionRates = [retentionRates; str2num(curRow.RET_FTL4{1})];
        end
        if (strcmpi(curRow.RET_PT4{1},'NULL') == 0) 
            retentionRates = [retentionRates; str2num(curRow.RET_PT4{1})];
        end
        if (strcmpi(curRow.RET_PTL4{1},'NULL') == 0) 
            retentionRates = [retentionRates; str2num(curRow.RET_PTL4{1})];
        end
        if (isempty(retentionRates) == 0) % assume equal weight of each rate
            estTwoYearRetention = mean(retentionRates) * mean(retentionRates); % assume same dropout rate for two years
        end
        if ( (meanSAT > -1) && (estTwoYearRetention > -1) ) % these have real values
            enrollmentAndSATs(insertThisRow,:) = table(curRows.OPEID(1),estTwoYearRetention,meanSAT,...
                'VariableNames',{'OPEid','enrolledAfter2years','avgSAT'});
            insertThisRow = insertThisRow + 1;
        end
    end     
end
% have to merge any that have multiple rows but only one OPEid
enrollmentAndSATs.deleteThisRow = zeros(height(enrollmentAndSATs),1);
for index = 2:height(enrollmentAndSATs)
    if (enrollmentAndSATs.OPEid(index) == enrollmentAndSATs.OPEid(index-1)) % this ID has multiple rows
        opeRows = enrollmentAndSATs(enrollmentAndSATs.OPEid == enrollmentAndSATs.OPEid(index), :);
        enrollmentAndSATs.enrolledAfter2years(index-1) = mean(opeRows.enrolledAfter2years);
        enrollmentAndSATs.avgSAT(index-1) = mean(opeRows.avgSAT);
        enrollmentAndSATs.deleteThisRow(index) = 1;
    end
end
enrollmentAndSATs(enrollmentAndSATs.deleteThisRow == 1, :) = []; % remove the extras
retentionSATcorr = corrcoef(enrollmentAndSATs.avgSAT, enrollmentAndSATs.enrolledAfter2years) % 0.658335668440821
clear allOPE enrollmentAndSATs insertThisRow index id curRows curRow row
clear curAdmitted meanSAT estTwoYearRetention retentionRates opeRows retentionSATcorr

% Third question
fourYearColleges = data2013(data2013.ICLEVEL == 1, :);
fourYearColleges(strcmpi(fourYearColleges.LO_INC_COMP_ORIG_YR4_RT, 'NULL'),:) = []; % remove rows where we don't have the data we need
fourYearColleges(strcmpi(fourYearColleges.LO_INC_COMP_ORIG_YR4_RT, 'PrivacySuppressed'),:) = [];
fourYearColleges(strcmpi(fourYearColleges.LO_INC_COMP_4YR_TRANS_YR4_RT, 'NULL'),:) = []; % if they transferred and completed, they still completed
fourYearColleges(strcmpi(fourYearColleges.LO_INC_COMP_4YR_TRANS_YR4_RT, 'PrivacySuppressed'),:) = []; 

fourYearColleges(strcmpi(fourYearColleges.MD_INC_COMP_ORIG_YR4_RT, 'NULL'),:) = []; % required to have this by the question, even though it's not used
fourYearColleges(strcmpi(fourYearColleges.MD_INC_COMP_ORIG_YR4_RT, 'PrivacySuppressed'),:) = [];
fourYearColleges(strcmpi(fourYearColleges.MD_INC_COMP_4YR_TRANS_YR4_RT, 'NULL'),:) = []; 
fourYearColleges(strcmpi(fourYearColleges.MD_INC_COMP_4YR_TRANS_YR4_RT, 'PrivacySuppressed'),:) = []; 

fourYearColleges(strcmpi(fourYearColleges.HI_INC_COMP_ORIG_YR4_RT, 'NULL'),:) = []; 
fourYearColleges(strcmpi(fourYearColleges.HI_INC_COMP_ORIG_YR4_RT, 'PrivacySuppressed'),:) = [];
fourYearColleges(strcmpi(fourYearColleges.HI_INC_COMP_4YR_TRANS_YR4_RT, 'NULL'),:) = []; 
fourYearColleges(strcmpi(fourYearColleges.HI_INC_COMP_4YR_TRANS_YR4_RT, 'PrivacySuppressed'),:) = []; 

fourYearColleges(strcmpi(fourYearColleges.UGDS, 'NULL'),:) = []; % if we don't know the number of students, we can't weight the percentages
%fourYearColleges.UGDSnum = zeros(height(fourYearColleges),1);
fourYearColleges.LoIncOrig = zeros(height(fourYearColleges),1);
fourYearColleges.LoIncTrans = zeros(height(fourYearColleges),1);
fourYearColleges.HiIncOrig = zeros(height(fourYearColleges),1);
fourYearColleges.HiIncTrans = zeros(height(fourYearColleges),1);
fourYearColleges.LoIncAvg = zeros(height(fourYearColleges),1);
fourYearColleges.HiIncAvg = zeros(height(fourYearColleges),1);
for i=1:height(fourYearColleges) % make numbers of the strings for the ones we need
% maybe we don't need to weight by number of students    fourYearColleges.UGDSnum(i) = str2num(fourYearColleges.UGDS{i});
    fourYearColleges.LoIncOrig(i) = str2num(fourYearColleges.LO_INC_COMP_ORIG_YR4_RT{i});
    fourYearColleges.LoIncTrans(i) = str2num(fourYearColleges.LO_INC_COMP_4YR_TRANS_YR4_RT{i});
    fourYearColleges.LoIncAvg(i) = mean([fourYearColleges.LoIncOrig(i) fourYearColleges.LoIncTrans(i)]);
    fourYearColleges.HiIncOrig(i) = str2num(fourYearColleges.HI_INC_COMP_ORIG_YR4_RT{i});
    fourYearColleges.HiIncTrans(i) = str2num(fourYearColleges.HI_INC_COMP_4YR_TRANS_YR4_RT{i});
    fourYearColleges.HiIncAvg(i) = mean([fourYearColleges.HiIncOrig(i) fourYearColleges.HiIncTrans(i)]);
end
% fourYearColleges.studentWeight = fourYearColleges.UGDSnum / sum(fourYearColleges.UGDSnum);
% fourYearColleges.weightedLoInc = fourYearColleges.LoIncAvg .* fourYearColleges.studentWeight;
% fourYearColleges.weightedHiInc = fourYearColleges.HiIncAvg .* fourYearColleges.studentWeight;
totalLoIncAvg = mean(fourYearColleges.LoIncAvg) % 0.182386870234869
totalHiIncAvg = mean(fourYearColleges.HiIncAvg) % 0.251203305329721
diff = totalHiIncAvg - totalLoIncAvg % 0.068816435094852

clear totalLoIncAvg totalHiIncAvg diff
        
% fourth question
[h, p] = ttest2(fourYearColleges.LoIncAvg,fourYearColleges.HiIncAvg,'Tail','both') % not sure why we're not doing a paired test here...
log10(p) % -77.676674420024099
clear h p

% fifth question
colsWeCareAbout = data2013(:,'OPEID'); % first, let's pare this down
% UGDS_WHITE    UGDS_BLACK	UGDS_HISP	UGDS_ASIAN	UGDS_AIAN	UGDS_NHPI	UGDS_2MOR	UGDS_NRA	UGDS_UNKN
colsWeCareAbout.UGDS_WHITE = data2013.UGDS_WHITE;
colsWeCareAbout.UGDS_BLACK = data2013.UGDS_BLACK;
colsWeCareAbout.UGDS_HISP = data2013.UGDS_HISP;
colsWeCareAbout.UGDS_ASIAN = data2013.UGDS_ASIAN;
colsWeCareAbout.UGDS_AIAN = data2013.UGDS_AIAN;
colsWeCareAbout.UGDS_NHPI = data2013.UGDS_NHPI;
colsWeCareAbout.UGDS_2MOR = data2013.UGDS_2MOR;
colsWeCareAbout.UGDS_NRA = data2013.UGDS_NRA;
colsWeCareAbout.UGDS_UNKN = data2013.UGDS_UNKN;
colsWeCareAbout(... % if all of these are null, remove them
    (strcmpi(colsWeCareAbout.UGDS_WHITE,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_BLACK,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_HISP,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_ASIAN,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_AIAN,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_NHPI,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_2MOR,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_NRA,'NULL') == 1) & ...
    (strcmpi(colsWeCareAbout.UGDS_UNKN,'NULL') == 1) , :) = [];
% now that we have nothing but numbers in those cells, make them numbers
colsWeCareAbout.UGDS_WHITE = cellfun(@str2num, colsWeCareAbout.UGDS_WHITE);
colsWeCareAbout.UGDS_BLACK = cellfun(@str2num, colsWeCareAbout.UGDS_BLACK);
colsWeCareAbout.UGDS_HISP = cellfun(@str2num, colsWeCareAbout.UGDS_HISP);
colsWeCareAbout.UGDS_ASIAN = cellfun(@str2num, colsWeCareAbout.UGDS_ASIAN);
colsWeCareAbout.UGDS_AIAN = cellfun(@str2num, colsWeCareAbout.UGDS_AIAN);
colsWeCareAbout.UGDS_NHPI = cellfun(@str2num, colsWeCareAbout.UGDS_NHPI);
colsWeCareAbout.UGDS_2MOR = cellfun(@str2num, colsWeCareAbout.UGDS_2MOR);
colsWeCareAbout.UGDS_NRA = cellfun(@str2num, colsWeCareAbout.UGDS_NRA);
colsWeCareAbout.UGDS_UNKN = cellfun(@str2num, colsWeCareAbout.UGDS_UNKN);
colsWeCareAbout(... % if all of these are zero, remove them
    (colsWeCareAbout.UGDS_WHITE == 0) & ...
    (colsWeCareAbout.UGDS_BLACK == 0) & ...
    (colsWeCareAbout.UGDS_HISP == 0) & ...
    (colsWeCareAbout.UGDS_ASIAN == 0) & ...
    (colsWeCareAbout.UGDS_AIAN == 0) & ...
    (colsWeCareAbout.UGDS_NHPI == 0) & ...
    (colsWeCareAbout.UGDS_2MOR == 0) & ...
    (colsWeCareAbout.UGDS_NRA == 0) & ...
    (colsWeCareAbout.UGDS_UNKN == 0) , :) = [];
ethnicityDiffs = table(0,0,'VariableNames',{'OPEID','biggestDiff'}); % now go through and calculate the biggest diff
insertThisRow = 1;
allOPE = unique(colsWeCareAbout.OPEID); % consider each OPEID as a single institution
for index = 1:length(allOPE)
    id = allOPE(index);
    schoolEthnicityRates = zeros(1,9);
    curRows = colsWeCareAbout(colsWeCareAbout.OPEID == id, :);
    if (height(curRows) > 1) % this OPEID spans multiple rows
        multiRowMatrix = table2array(curRows(:,2:end)); % switch to array so we can use indexing
        for i = 1:9
            if (sum(multiRowMatrix(:,i)) == 0) % none of these are reported
                schoolEthnicityRates(1,i) = 0;
            else % at least one is reported; take the mean of the reported ones
                schoolEthnicityRates(1,i) = sum(multiRowMatrix(:,i)) / ...
                    length(multiRowMatrix(multiRowMatrix(:,1) > 0));
            end
        end
    else % just one row; we have all the data here
        schoolEthnicityRates = [curRows.UGDS_WHITE ...
            curRows.UGDS_BLACK curRows.UGDS_HISP curRows.UGDS_ASIAN ...
            curRows.UGDS_AIAN curRows.UGDS_NHPI curRows.UGDS_2MOR ...
            curRows.UGDS_NRA curRows.UGDS_UNKN];
    end
    ethnicityDiffs(insertThisRow,:) = table(curRows.OPEID(1),...
        max(schoolEthnicityRates) - min(schoolEthnicityRates), ...
        'VariableNames',{'OPEID','biggestDiff'});
    insertThisRow = insertThisRow + 1;
end
min(ethnicityDiffs.biggestDiff) % 0.233500000000000

clear colsWeCareAbout ethnicityDiffs insertThisRow allOPE index id curRows
clear multiRowMatrix schoolEthnicityRates


% Question 6
data2001 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2001_02_PP.xlsx');
women2001 = data2001(:,'OPEID'); % just grab what we need
women2001.UGDS_WOMEN = data2001.UGDS_WOMEN;
clear data2001; % then free up the memory
data2002 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2002_03_PP.xlsx');
women2002 = data2002(:,'OPEID'); 
women2002.UGDS_WOMEN = data2002.UGDS_WOMEN;
clear data2002; 
data2003 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2003_04_PP.xlsx');
women2003 = data2003(:,'OPEID'); 
women2003.UGDS_WOMEN = data2003.UGDS_WOMEN;
clear data2003; 
data2004 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2004_05_PP.xlsx');
women2004 = data2004(:,'OPEID'); 
women2004.UGDS_WOMEN = data2004.UGDS_WOMEN;
clear data2004; 
data2005 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2005_06_PP.xlsx');
women2005 = data2005(:,'OPEID'); 
women2005.UGDS_WOMEN = data2005.UGDS_WOMEN;
clear data2005; 
data2006 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2006_07_PP.xlsx');
women2006 = data2006(:,'OPEID'); 
women2006.UGDS_WOMEN = data2006.UGDS_WOMEN;
clear data2006; 
data2007 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2007_08_PP.xlsx');
women2007 = data2007(:,'OPEID'); 
women2007.UGDS_WOMEN = data2007.UGDS_WOMEN;
clear data2007; 
data2008 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2008_09_PP.xlsx');
women2008 = data2008(:,'OPEID'); 
women2008.UGDS_WOMEN = data2008.UGDS_WOMEN;
clear data2008; 
data2009 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2009_10_PP.xlsx');
women2009 = data2009(:,'OPEID'); 
women2009.UGDS_WOMEN = data2009.UGDS_WOMEN;
clear data2009; 
data2010 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2010_11_PP.xlsx');
women2010 = data2010(:,'OPEID'); 
women2010.UGDS_WOMEN = data2010.UGDS_WOMEN;
clear data2010; 
% now clean and merge them
%women2001.OPEIDnum = cellfun(@str2num, women2001.OPEID);
women2001(strcmpi(women2001.UGDS_WOMEN,'NULL'),:) = []; % delete those for which we have no data
women2002(strcmpi(women2002.UGDS_WOMEN,'NULL'),:) = []; 
women2003(strcmpi(women2003.UGDS_WOMEN,'NULL'),:) = []; 
women2004(strcmpi(women2004.UGDS_WOMEN,'NULL'),:) = []; 
women2005(strcmpi(women2005.UGDS_WOMEN,'NULL'),:) = []; 
women2006(strcmpi(women2006.UGDS_WOMEN,'NULL'),:) = []; 
women2007(strcmpi(women2007.UGDS_WOMEN,'NULL'),:) = []; 
women2008(strcmpi(women2008.UGDS_WOMEN,'NULL'),:) = []; 
women2009(strcmpi(women2009.UGDS_WOMEN,'NULL'),:) = []; 
women2010(strcmpi(women2010.UGDS_WOMEN,'NULL'),:) = []; 
tmpOPEIDlist = women2001(:,'OPEID'); % make a list of the shared OPEIDs
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2002.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2003.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2004.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2005.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2006.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2007.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2008.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2009.OPEID),:) = [];
tmpOPEIDlist(~ismember(tmpOPEIDlist.OPEID, women2010.OPEID),:) = [];
tmpOPEIDlist.w01 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w02 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w03 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w04 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w05 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w06 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w07 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w08 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w09 = zeros(height(tmpOPEIDlist),1);
tmpOPEIDlist.w10 = zeros(height(tmpOPEIDlist),1);
for i = 1:height(tmpOPEIDlist)
    tmpOPEIDlist.w01(i) = str2num(women2001(strcmpi(women2001.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w02(i) = str2num(women2002(strcmpi(women2002.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w03(i) = str2num(women2003(strcmpi(women2003.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w04(i) = str2num(women2004(strcmpi(women2004.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w05(i) = str2num(women2005(strcmpi(women2005.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w06(i) = str2num(women2006(strcmpi(women2006.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w07(i) = str2num(women2007(strcmpi(women2007.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w08(i) = str2num(women2008(strcmpi(women2008.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w09(i) = str2num(women2009(strcmpi(women2009.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
    tmpOPEIDlist.w10(i) = str2num(women2010(strcmpi(women2010.OPEID,tmpOPEIDlist.OPEID(i)),:).UGDS_WOMEN{:});
end
womenMatrix = table2array(tmpOPEIDlist(:,2:end));
mean(mean(womenMatrix)) % 0.645398539663462

clear women2001 women2002 women2003 women2004 women2005 women2006 women2007 women2008 women2009 women2010
clear i womenMatrix tmpOPEIDlist

% Question 7
data2014 = readtable('/Users/z_home/Downloads/CollegeScorecard_Raw_Data/MERGED2014_15_PP.xlsx');
% regions defined by Bureau of Economic Analysis regions at https://en.wikipedia.org/wiki/List_of_regions_of_the_United_States
%{
New England: Connecticut, Maine, Massachusetts, New Hampshire, Rhode Island and Vermont
Mideast: Delaware, District of Columbia, Maryland, New Jersey, New York, and Pennsylvania
Great Lakes: Illinois, Indiana, Michigan, Ohio, and Wisconsin
Plains: Iowa, Kansas, Minnesota, Missouri, Nebraska, North Dakota, and South Dakota
Southeast: Alabama, Arkansas, Florida, Georgia, Kentucky, Louisiana, Mississippi, North Carolina, South Carolina, Tennessee, Virginia, and West Virginia
Southwest: Arizona, New Mexico, Oklahoma, and Texas
Rocky Mountain: Colorado, Idaho, Montana, Utah, and Wyoming
Far West: Alaska, California, Hawaii, Nevada, Oregon, and Washington
%}
reg1 = [{'CT'} {'ME'} {'MA'} {'NH'} {'RI'} {'VT'}]
reg2 = [{'DE'} {'DC'} {'MD'} {'NJ'} {'NY'} {'PA'}]
reg3 = [{'IL'} {'IN'} {'MI'} {'OH'} {'WI'}]
reg4 = [{'IA'} {'KS'} {'MN'} {'MO'} {'NE'} {'ND'} {'SD'}]
reg5 = [{'AL'} {'AK'} {'FL'} {'GA'} {'KY'} {'LA'} {'MS'} {'NC'} {'SC'} {'TN'} {'VA'} {'WV'}]
reg6 = [{'AZ'} {'NM'} {'OK'} {'TX'}]
reg7 = [{'CO'} {'ID'} {'MT'} {'UT'} {'WY'}]
reg8 = [{'AK'} {'CA'} {'HI'} {'NV'} {'OR'} {'WA'}]


