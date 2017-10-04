% Zephy McKanna
% UIUC analyses script / attempt to implement Steve Culpepper's N-back model
% 4/15/17



% First, let's see whether we can get an Ability estimate from GLM
UIUC_Nback = readtable(getFileNameForThisOS('UIUC_NbackTrialRT_1B.csv', 'ParsedData'));

% Let's add a couple of useful columns: Lure and NbackVal
%   zNOTE: ASK CHRIS/EVAN - I'm assuming Difficulty = "Level"? But in the
%   notes, level only goes up to 34, and Difficulty goes up to 37???
UIUC_Nback.Lure = zeros(height(UIUC_Nback),1);
UIUC_Nback.NbackVal = zeros(height(UIUC_Nback),1);
for delMe = 1:height(UIUC_Nback)
    if (UIUC_Nback.TrialType(delMe) == 4) % dual lure
        UIUC_Nback.Lure(delMe) = 1;
    elseif (UIUC_Nback.TrialType(delMe) == 5) % visual lure
        UIUC_Nback.Lure(delMe) = 1;
    elseif (UIUC_Nback.TrialType(delMe) == 6) % auditory lure
        UIUC_Nback.Lure(delMe) = 1;
    end
    if (UIUC_Nback.Difficulty(delMe) < 9) % 1-8: N = 1
        UIUC_Nback.NbackVal(delMe) = 1;
    elseif (UIUC_Nback.Difficulty(delMe) < 18) % 9-17: N = 2
        UIUC_Nback.NbackVal(delMe) = 2;
    elseif (UIUC_Nback.Difficulty(delMe) < 27) % 18-26: N = 3
        UIUC_Nback.NbackVal(delMe) = 3;
    else % 27-34: N = 4
        UIUC_Nback.NbackVal(delMe) = 4;
    end        
end

delMe = UIUC_Nback;
% remove the RT 'NA's
delMe(strcmpi(delMe.RT,'NA'),:) = [];
delMe.RespTime = str2double(delMe.RT); % takes a few seconds, not an error

delMe2 = delMe.Accuracy; % this is binary correct/incorrect in UIUC data
delMe3 = [delMe.Username delMe.NbackVal delMe.Lure delMe.VideoIndex delMe.AudioIndex delMe.RespTime];
UIUC_GLmodel_1B = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Nval + Lure + Vindex + Aindex + RT','distr','binomial','CategoricalVars',[1,2,3,4,5,],'VarNames',{'Subj','Nval','Lure','Vindex','Aindex','RT','Correct'})
printGLMcoeffs(UIUC_GLmodel_1B, true);

% now let's see if these Ability coeffs corespond to the max level people got
delMe4 = unique(UIUC_Nback.Username);
delMe4(:,2) = zeros(1,length(delMe4));
delMe4(1,:) = []; % no estimate from the GLM for the first subject
delMe4(:,3) = UIUC_GLmodel_1B.Coefficients.Estimate(2:144);
for i = 1:length(delMe4)
    subjTrials = UIUC_Nback(UIUC_Nback.Username == delMe4(i,1),:);
    delMe4(i,2) = max(subjTrials.Difficulty);
end
zScatter(delMe4(:,2), delMe4(:,3), 'Comparing UIUC GLM-estimated Ability to max Level attained', 'Max Level attained', 'GLM-estimated Ability score', true, '', '', 14, false, '', '');
csvwrite(getFileNameForThisOS('2017_4_20-UIUC_Nback_info.csv', 'IntResults'), delMe4);

% now let's see if it correlates to their MITRE scores at all
[UIUC_MITRE, ~, ~] = formTables_RF_1A3('UIUC_1B_MITRE_FINAL.xlsx', '', '', true);
[delMe, delMe2] = removeNonMatchingSubjects(UIUC_Nback.Username, UIUC_Nback, UIUC_MITRE.Subject, UIUC_MITRE, false, false);
% the LSAT scores are lsatScore and t2_lsatScore
delMe2.lsatDiff = delMe2.t2_lsatScore - delMe2.lsatScore;
delMe4(:,4) = delMe2.lsatDiff(2:end);
zScatter(delMe4(:,4), delMe4(:,3), 'Comparing UIUC GLM-estimated Ability to MITRE LSAT change', 'MITRE LSAT delta', 'GLM-estimated Ability score', true, '', '', 14, false, '', '');
delMe2.figuresDiff = delMe2.t2_figuresScore - delMe2.figuresScore;
delMe4(:,5) = delMe2.figuresDiff(2:end);
zScatter(delMe4(:,5), delMe4(:,3), 'Comparing UIUC GLM-estimated Ability to MITRE figures change', 'MITRE figures delta', 'GLM-estimated Ability score', true, '', '', 14, false, '', '');
delMe2.figuresScaledDiff = delMe2.t2_figuresScaledScore - delMe2.figuresScaledScore;
delMe4(:,6) = delMe2.figuresScaledDiff(2:end);
zScatter(delMe4(:,6), delMe4(:,3), 'Comparing UIUC GLM-estimated Ability to MITRE figures scaled change', 'MITRE figures scaled delta', 'GLM-estimated Ability score', true, '', '', 14, false, '', '');





% Notes on Steve's model
% Eq1 seems similar to the "Ability" models we've done in the past
%   following similar assumptions: monotonic learning, can only go up 1 level at a time.
% 

