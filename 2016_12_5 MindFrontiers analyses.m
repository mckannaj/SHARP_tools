% script to deal with MindFrontiers data

% first, read in the game data
delMe = tdfread(getFileNameForThisOS('/MindFrontiersData/Per-game_1/AnteUp/AnteUpGameData.dat', 'ParsedData'));
MF_anteUp = struct2table(delMe);
delMe = tdfread(getFileNameForThisOS('/MindFrontiersData/Per-game_1/FigureWeights/FigureWeightsGameData.dat', 'ParsedData'));
MF_weights = struct2table(delMe);
delMe = tdfread(getFileNameForThisOS('/MindFrontiersData/Per-game_1/NBack/NBackGameData.dat', 'ParsedData'));
MF_nBack = struct2table(delMe);
delMe = tdfread(getFileNameForThisOS('/MindFrontiersData/Per-game_1/PenEmUp/PenEmUpGameData.dat', 'ParsedData'));
MF_penEm = struct2table(delMe);
delMe = tdfread(getFileNameForThisOS('/MindFrontiersData/Per-game_1/Pipemania/PipemaniaGameData.dat', 'ParsedData'));
MF_pipe = struct2table(delMe);
delMe = tdfread(getFileNameForThisOS('/MindFrontiersData/Per-game_1/RidingShotgun/RidingShotgunGameData.dat', 'ParsedData'));
MF_shotgun = struct2table(delMe);
delMe = tdfread(getFileNameForThisOS('/MindFrontiersData/Per-game_1/SupplyRun/SupplyRunGameData.dat', 'ParsedData'));
MF_supply = struct2table(delMe);
% now add a gameType col to each and make them one table
delMe = {'anteUp'};
MF_anteUp.gameType = repmat(delMe,height(MF_anteUp),1);
MF_anteUp.gameTypeNum = zeros(height(MF_anteUp),1) + 1; % game #1: ante up
delMe = {'figureWeights'};
MF_weights.gameType = repmat(delMe,height(MF_weights),1);
MF_weights.gameTypeNum = zeros(height(MF_weights),1) + 2; % game #2: figure weights
delMe = {'setryDuty'};
MF_nBack.gameType = repmat(delMe,height(MF_nBack),1);
MF_nBack.gameTypeNum = zeros(height(MF_nBack),1) + 3; % game #3: sentry duty
delMe = {'penEmUp'};
MF_penEm.gameType = repmat(delMe,height(MF_penEm),1);
MF_penEm.gameTypeNum = zeros(height(MF_penEm),1) + 4; % game #4: pen 'em up
delMe = {'irrigator'};
MF_pipe.gameType = repmat(delMe,height(MF_pipe),1);
MF_pipe.gameTypeNum = zeros(height(MF_pipe),1) + 5; % game #5: irrigator / pipemania
delMe = {'ridingShotgun'};
MF_shotgun.gameType = repmat(delMe,height(MF_shotgun),1);
MF_shotgun.gameTypeNum = zeros(height(MF_shotgun),1) + 6; % game #6: riding shotgun
delMe = {'supplyRun'};
MF_supply.gameType = repmat(delMe,height(MF_supply),1);
MF_supply.gameTypeNum = zeros(height(MF_supply),1) + 7; % game #7: supply run
MF_gameData = [MF_anteUp;MF_weights;MF_penEm;MF_pipe;MF_shotgun;MF_supply]; 
% note: n-back data are different!!! Have to remove some columns to make it the same as the others. 
delMe = MF_nBack;
delMe.DualTargetAcc = [];
delMe.DualTargetTrials = [];
delMe.VisualTargetAcc = [];
delMe.VisualTargetTrials = [];
delMe.AudioTargetAcc = [];
delMe.AudioTargetTrials = [];
delMe.DualLureAcc = [];
delMe.DualLureTrials = [];
delMe.VisualLureAcc = [];
delMe.VisualLureTrials = [];
delMe.AuditoryLureAcc = [];
delMe.AuditoryLureTrials = [];
delMe.NonTargetAcc = [];
delMe.NonTargetTrials = [];
MF_gameData = [MF_gameData;delMe]; 



% now figure out a GLM_Ability that makes sense (start with reaction time) 
% reaction times that probably make sense: pipes/irrigator, shotgun (simon says), n-back (sentry), pen em up,  
% RTs that don't make sense: ante up, figure weights, supply run

% MF_supply has a timestamp but doesn't necessarily make sense
delMe = zRFP3_included(zRFP3_included.StimShowTime < 4,:); % exclude unusual timeouts and categorization (may also try: < 10 for just categorization)
delMe2 = delMe.Correct;
delMe3 = [delMe.Subject delMe.NbackDifficulty delMe.SwitchFlag delMe.InhibitDifficulty delMe.numOfEFsInThisTrial delMe.anyLogicFlag delMe.TotalTrialCount delMe.StimShowTime delMe.RespTime];
RF_EFmodel_2A = fitglm(delMe3,delMe2,'logit(Correct) ~ 1 + Subj + Ndiff + SwRep + InhDiff + EFcount + anyLogic + TrialCount + Timeout + RT','distr','binomial','CategoricalVars',[1,2,3,5,6,8],'VarNames',{'Subj','Ndiff','SwRep','InhDiff','EFcount','anyLogic','TrialCount','Timeout','RT','Correct'})
printGLMcoeffs(RF_EFmodel_2A, true);






