
% get some "progress" estimates for AC by taking overall mean Final_level_achieved_per_day 
[zACthumb_levels_1B, zACvis_levels_1B, zACsilo_levels_1B] = formTables_RF_1A3('1b-Final-Parsed-AC.thumbprint-level.xlsx', '1b-Final-Parsed-AC.visualsearch-level.xlsx', '1b-Final-Parsed-AC.silo-level.xlsx', true);
% make sure the distributions are relatively wide
delMe = zACthumb_levels_1B(:,'Subject');
delMe.Final1 = zACthumb_levels_1B.Final1;
delMe.Final2 = zACthumb_levels_1B.Final2;
delMe.Final3 = zACthumb_levels_1B.Final3;
delMe.Final4 = zACthumb_levels_1B.Final4;
delMe.Final5 = zACthumb_levels_1B.Final5;
delMe.Final6 = zACthumb_levels_1B.Final6;
delMe.Final7 = zACthumb_levels_1B.Final7;
delMe.Final8 = zACthumb_levels_1B.Final8;
delMe.Final9 = zACthumb_levels_1B.Final9;
delMe.Final10 = zACthumb_levels_1B.Final10;
delMe.Final11 = zACthumb_levels_1B.Final11;
delMe.Final12 = zACthumb_levels_1B.Final12;
delMe.meanFinal = zeros(height(delMe),1);
for delMe2 = 1:height(delMe) % go through all subjects
    delMe.meanFinal(delMe2) = nanmean(delMe{delMe2, 2:(end-1)}); % average everything but the Subject and meanFinal columns
end
hist(delMe.meanFinal)
title(sprintf('Distribution of mean Final level for AC thumbprint'));
xlabel(sprintf('Equally distributed groups of subjects'));
ylabel(sprintf('Mean Final level achieved'));

delMe = zACsilo_levels_1B(:,'Subject');
delMe.Final1 = zACsilo_levels_1B.Final1;
delMe.Final2 = zACsilo_levels_1B.Final2;
delMe.Final3 = zACsilo_levels_1B.Final3;
delMe.Final4 = zACsilo_levels_1B.Final4;
delMe.Final5 = zACsilo_levels_1B.Final5;
delMe.Final6 = zACsilo_levels_1B.Final6;
delMe.Final7 = zACsilo_levels_1B.Final7;
delMe.Final8 = zACsilo_levels_1B.Final8;
delMe.Final9 = zACsilo_levels_1B.Final9;
delMe.Final10 = zACsilo_levels_1B.Final10;
delMe.Final11 = zACsilo_levels_1B.Final11;
delMe.Final12 = zACsilo_levels_1B.Final12;
delMe.meanFinal = zeros(height(delMe),1);
for delMe2 = 1:height(delMe) % go through all subjects
    delMe.meanFinal(delMe2) = nanmean(delMe{delMe2, 2:(end-1)}); % average everything but the Subject and meanFinal columns
end
hist(delMe.meanFinal)
title(sprintf('Distribution of mean Final level for AC silo'));
xlabel(sprintf('Equally distributed groups of subjects'));
ylabel(sprintf('Mean Final level achieved'));

delMe = zACvis_levels_1B(:,'Subject');
delMe.Final1 = zACvis_levels_1B.Final1;
delMe.Final2 = zACvis_levels_1B.Final2;
delMe.Final3 = zACvis_levels_1B.Final3;
delMe.Final4 = zACvis_levels_1B.Final4;
delMe.Final5 = zACvis_levels_1B.Final5;
delMe.Final6 = zACvis_levels_1B.Final6;
delMe.Final7 = zACvis_levels_1B.Final7;
delMe.Final8 = zACvis_levels_1B.Final8;
delMe.Final9 = zACvis_levels_1B.Final9;
delMe.Final10 = zACvis_levels_1B.Final10;
delMe.Final11 = zACvis_levels_1B.Final11;
delMe.Final12 = zACvis_levels_1B.Final12;
delMe.meanFinal = zeros(height(delMe),1);
for delMe2 = 1:height(delMe) % go through all subjects
    delMe.meanFinal(delMe2) = nanmean(delMe{delMe2, 2:(end-1)}); % average everything but the Subject and meanFinal columns
end
hist(delMe.meanFinal)
title(sprintf('Distribution of mean Final level for AC visual search'));
xlabel(sprintf('Equally distributed groups of subjects'));
ylabel(sprintf('Mean Final level achieved'));

% ensure that all three have the same subjects, so we can combine them 
[delMe3, delMe4] = removeNonMatchingSubjects(zACthumb_levels_1B.Subject, zACthumb_levels_1B, zACsilo_levels_1B.Subject, zACsilo_levels_1B, true, false);
[delMe5, delMe4] = removeNonMatchingSubjects(zACvis_levels_1B.Subject, zACvis_levels_1B, delMe4.Subject, delMe4, true, false);
[delMe3, delMe5] = removeNonMatchingSubjects(delMe3.Subject, delMe3, delMe5.Subject, delMe5, true, false);

delMe = delMe3(:,'Subject');
delMe.FinalT1 = delMe3.Final1;
delMe.FinalT2 = delMe3.Final2;
delMe.FinalT3 = delMe3.Final3;
delMe.FinalT4 = delMe3.Final4;
delMe.FinalT5 = delMe3.Final5;
delMe.FinalT6 = delMe3.Final6;
delMe.FinalT7 = delMe3.Final7;
delMe.FinalT8 = delMe3.Final8;
delMe.FinalT9 = delMe3.Final9;
delMe.FinalT10 = delMe3.Final10;
delMe.FinalT11 = delMe3.Final11;
delMe.FinalT12 = delMe3.Final12;

delMe.FinalS1 = delMe4.Final1;
delMe.FinalS2 = delMe4.Final2;
delMe.FinalS3 = delMe4.Final3;
delMe.FinalS4 = delMe4.Final4;
delMe.FinalS5 = delMe4.Final5;
delMe.FinalS6 = delMe4.Final6;
delMe.FinalS7 = delMe4.Final7;
delMe.FinalS8 = delMe4.Final8;
delMe.FinalS9 = delMe4.Final9;
delMe.FinalS10 = delMe4.Final10;
delMe.FinalS11 = delMe4.Final11;
delMe.FinalS12 = delMe4.Final12;

delMe.FinalV1 = delMe5.Final1 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10)
delMe.FinalV2 = delMe5.Final2 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV3 = delMe5.Final3 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV4 = delMe5.Final4 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV5 = delMe5.Final5 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV6 = delMe5.Final6 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV7 = delMe5.Final7 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV8 = delMe5.Final8 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV9 = delMe5.Final9 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV10 = delMe5.Final10 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV11 = delMe5.Final11 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.FinalV12 = delMe5.Final12 * (21/10); % scale to be the same as the other two (Final for those is 21, Final for this is 10);
delMe.meanFinal = zeros(height(delMe),1);
for delMe2 = 1:height(delMe) % go through all subjects
    delMe.meanFinal(delMe2) = nanmean(delMe{delMe2, 2:(end-1)}); % average everything but the Subject and meanFinal columns
end
hist(delMe.meanFinal, 30)
title(sprintf('Distribution of mean Final level for AC, across all three tasks'));
xlabel(sprintf('Equally distributed groups of subjects'));
ylabel(sprintf('Mean Final level achieved'));

writetable(delMe, getFileNameForThisOS('2015_12_8 mean final_level_achieved for all AC tasks.csv', 'IntResults'))


