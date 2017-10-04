% Zephy McKanna
% 11/14/14
%
% This function takes a table containing a "Subject" column, and removes
% data from the following subjects (agreed to be excluded from 1A-3):
% 
% If 'excludeThese' is equal to 'noncompliant', then only the noncompliant
% ones are excluded. If 'excludeThese' is equal to 'oldProgression', then
% only the ones doing the Old RF build are excluded. If 'excludeThese'
% equals 'both', then all of them are excluded.
%
% Dropped out:
% 2323
% 3311
% 3334
%
% Old RF build:
% 1305
% 1306
% 1307
% 2301
% 3303
% 3304
% 3306
% 3309
% 3312
% 3317
%
% Observed noncompliance, plus IQ or EF measures that are just noise:
% 1328 
% 1339
% 3331
% 3336
%
% If the justRF flag is set to true, then we will also exclude all subjects
% that were not in [one of] the RobotFactory training group[s]. These
% include:
% 1301 AC
% 1302 NC
% 1303 NC
% 1304 <no group>
% 1308 NC
% 1309 <no group>
% 1310 AC
% 1313 AC
% 1314 NC
% 1315 NC
% 1316 <no group>
% 1317 AC
% 1318 <no group>
% 1320 <no group>
% 1321 NC
% 1322 <no group>
% 1323	NC
% 1325 <no group>
% 1326	AC
% 1329	NC
% 1330	AC
% 1331	NC
% 1332	AC
% 1334	NC
% 1335	NC
% 1337	AC
% 1338	<no group>
% 1340	AC
% 1343	AC
% 2302	AC
% 2303	NC
% 2304	NC
% 2306	AC
% 2307	AC
% 2308	NC
% 2309	AC
% 2310	NC
% 2311	<no group>
% 2313	AC
% 2315	NC
% 2318	NC
% 2320	NC
% 2321	AC
% 2322	AC
% 2323	<no group>
% 2324	AC
% 2326	NC
% 2328	AC
% 2329	NC
% 2330	NC
% 2331	AC
% 2333	AC
% 2334	NC
% 2339	<no group>
% 3301	NC
% 3302	NC
% 3305	NC
% 3307	AC
% 3308	AC
% 3310	NC
% 3311	<no group>
% 3313	NC
% 3314	AC
% 3315	AC
% 3316	NC
% 3318	AC
% 3319	AC
% 3320	AC
% 3321	NC
% 3322	NC
% 3324	AC
% 3325	AC
% 3326	AC
% 3328	NC
% 3329	AC
% 3330	NC
% 3333	NC
% 3334  <no group>
%
% It returns the original table, less the rows of those subjects.
%
function [tableWithoutExcludedSubjects] = excludeSubjects_RF_1A3(excludeThese, justRF, fullData)
    tableWithoutExcludedSubjects = fullData;
    
    if (strcmpi(excludeThese, 'noncompliant') == 0) % we're NOT only excluding the noncompliant ones
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1305, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1306, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1307, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2301, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3303, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3304, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3306, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3309, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3312, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3317, :) = [];
    elseif (strcmpi(excludeThese, 'oldProgression') == 0) % we're NOT only excluding the ones who did the old progression
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1328, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1339, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3331, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3336, :) = [];
    end
    
    if (justRF == true)
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1301, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1302, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1303, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1304, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1308, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1309, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1310, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1313, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1314, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1315, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1316, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1317, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1318, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1320, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1321, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1322, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1323, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1325, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1326, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1329, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1330, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1331, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1332, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1334, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1335, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1337, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1338, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1340, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 1343, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2302, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2303, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2304, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2306, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2307, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2308, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2309, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2310, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2311, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2313, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2315, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2318, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2320, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2321, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2322, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2323, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2324, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2326, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2328, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2329, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2330, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2331, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2333, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2334, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2339, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3301, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3302, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3305, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3307, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3308, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3310, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3311, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3313, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3314, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3315, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3316, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3318, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3319, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3320, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3321, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3322, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3324, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3325, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3326, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3328, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3329, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3330, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3333, :) = [];
        tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3334, :) = [];
    end
    
    
    % regardless, we're excluding the ones who dropped out
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 2323, :) = [];
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3311, :) = [];
    tableWithoutExcludedSubjects(tableWithoutExcludedSubjects.Subject == 3334, :) = [];
    

end
