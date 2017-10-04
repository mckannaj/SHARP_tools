% Zephy McKanna
% initial Insight stuff
% 9/7/17
% 

% before this, I saved a file from PyrAmes and removed the first few lines
% (not in table format), and saved it as Insight_zMess1.csv
delMe = readtable(getFileNameForThisOS('Insight_zMess1.csv', 'ParsedData'));

% DO THIS ON THE COMMAND LINE!!!
%   (takes forever in any programming language; need to use sed)

% First: copy each file to one named [id]tmp.csv
cp ./Z9_F18_044142_37585_II_V1_ABP_scaled.csv Z9tmp.csv
cp ./Z6_F12_043256_36865_II_V2_ABP_scaled.csv Z6tmp.csv
cp ./Z5_F11_024057_37350_II_V1_ABP_scaled.csv Z5tmp.csv
cp ./Z3_E26_081809_36604_II_V1_ABP_scaled.csv Z3tmp.csv
cp ./Z2_E19_082727_36188_II_V1_ABP_scaled.csv Z2tmp.csv
cp ./Z1_E19_034134_36111_II_V1_ABP_scaled.csv Z1tmp.csv

cp ./Z17_G24_041138_39449_II_V_ABP_scaled.csv Z17tmp.csv
cp ./Z16_G22_091643_39446_II_V2_ABP_scaled.csv Z16tmp.csv
cp ./Z15_G21_035646_39294_II_V_ABP_scaled.csv Z15tmp.csv
cp ./Z14_F38_072347_38349_II_V2_ABP_X_scaled.csv Z14tmp.csv
cp ./Y6_F39_074808_38749_II_ABP_X_PPG_scaled.csv Y6tmp.csv
cp ./Y4_F36_053025_38576_I_ABP_PPG_scaled.csv Y4tmp.csv

cp ./Y36_I41_090440_43601_II_ABP_X_PPG_scaled.csv Y36tmp.csv
cp ./Y35_I41_063003_43647_II_ABP_PPG_scaled.csv Y35tmp.csv
cp ./Y34_I41_044419_43557_II_ABP_X_PPG_scaled.csv Y34tmp.csv
cp ./Y33_I41_072430_43554_II_ABP_PPG_scaled.csv Y33tmp.csv
cp ./Y32_I33_061014_43233_II_ABP_PPG_scaled.csv Y32tmp.csv
cp ./Y31_I32_051154_43120_II_ABP_PPG_scaled.csv Y31tmp.csv
cp ./Y30_I21_071503_41977_II_ABP_PPG_scaled.csv Y30tmp.csv
cp ./Y29_I21_043442_42500_II_ABP_PPG_scaled.csv Y29tmp.csv

cp ./Y28_I21_030407_42407_II_ABP_PPG_scaled.csv Y28tmp.csv
cp ./Y27_I19_054229_42404_II_ABP_PPG_scaled.csv Y27tmp.csv
cp ./Y26_I19_063240_42418_II_ABP_PAP_PPG_scaled.csv Y26tmp.csv
cp ./Y25_I14_094829_42145_II_ABP_PPG_scaled.csv Y25tmp.csv
cp ./Y24_I14_044746_42053_I_ABP_PPG_scaled.csv Y24tmp.csv
cp ./Y23_I12_073443_42041_II_ABP_PPG_scaled.csv Y23tmp.csv
cp ./Y21_H31_092052_41505_II_ABP_PPG_scaled.csv Y21tmp.csv
cp ./Y20_H28_082912_41406_II_ABP_PPG_scaled.csv Y20tmp.csv
cp ./Y1_F27_083558_37389_II_ABP_X_PPG_scaled.csv Y1tmp.csv

cp ./Y19_G37_040004_39525_I_ABP_X_PPG_scaled.csv Y19tmp.csv
cp ./Y17_G28_063707_39795_II_ABP_X_PPG_scaled.csv Y17tmp.csv
cp ./Y15_G27_055700_39305_II_ABP_X_PPG_scaled.csv Y15tmp.csv
cp ./Y13_G23_070641_39581_I_ABP_X_PPG_scaled.csv Y13tmp.csv
cp ./Y11_G16_012257_38944_II_ABP_PAP_PPG_scaled.csv Y11tmp.csv
cp ./W9_F32_065658_38427_II_aVR_ABP_PPG_scaled.csv W9tmp.csv

cp ./W8_F31_071705_35791_II_V_ABP_PPG_scaled.csv W8tmp.csv
cp ./W7_F31_064718_38222_I_V_ABP_PPG_scaled.csv W7tmp.csv
cp ./W5_F31_035058_38315_II_V_ABP_PPG_scaled.csv W5tmp.csv
cp ./W51_I32_050142_41510_II_V_ABP_PPG_scaled.csv W51tmp.csv
cp ./W49_H31_055504_41548_II_V_ABP_PPG_scaled.csv W49tmp.csv

cp ./W48_H28_064849_41421_II_V_ABP_PPG_scaled.csv W48tmp.csv
cp ./W47_H26_071836_41211_II_V_ABP_PPG_scaled.csv W47tmp.csv
cp ./W45_H21_075746_41018_II_V_ABP_PPG_scaled.csv W45tmp.csv
cp ./W42_H12_085412_40523_II_V_ABP_PPG_scaled.csv W42tmp.csv
cp ./W41_H12_094448_40273_II_V_ABP_PPG_scaled.csv W41tmp.csv
cp ./W40_G34_095226_39997_II_V_ABP_PPG_scaled.csv W40tmp.csv
cp ./W39_G34_071712_40084_II_V_ABP_PPG_scaled.csv W39tmp.csv

cp ./W38_G30_071756_39908_II_V_ABP_PPG_scaled.csv W38tmp.csv
cp ./W37_G30_052230_39910_II_V_ABP_PPG_scaled.csv W37tmp.csv
cp ./W34_G28_035656_39697_II_V_ABP_PPG_scaled.csv W34tmp.csv
cp ./W33_G27_075300_39752_II_V_ABP_PPG_scaled.csv W33tmp.csv
cp ./W32_G24_110052_39369_II_MCL_ABP_PPG_scaled.csv W32tmp.csv
cp ./W31_G24_101039_39592_II_V_ABP_PPG_scaled.csv W31tmp.csv
cp ./W30_G24_074033_39654_II_V_ABP_PPG_scaled.csv W30tmp.csv
cp ./W29_G23_053639_39488_II_V_ABP_PPG_scaled.csv W29tmp.csv

cp ./W28_G23_085652_39595_II_V_ABP_PPG_scaled.csv W28tmp.csv
cp ./W27_G22_060732_39484_II_V_ABP_PPG_scaled.csv W27tmp.csv
cp ./W26_G21_040212_39370_II_V_ABP_PPG_scaled.csv W26tmp.csv
cp ./W25_G21_025735_39158_aVR_II_ABP_PPG_scaled.csv W25tmp.csv
cp ./W24_G21_032259_39368_II_V_ABP_PPG_scaled.csv W24tmp.csv
cp ./W23_G16_054918_39157_II_V_ABP_PPG_scaled.csv W23tmp.csv
cp ./W22_G15_023354_39100_II_V_ABP_PPG_scaled.csv W22tmp.csv
cp ./W21_G15_021411_39105_II_V_ABP_PPG_scaled.csv W21tmp.csv
cp ./W19_G14_014540_39047_II_V_ABP_PPG_scaled.csv W19tmp.csv

cp ./W18_G14_085120_39099_II_V_ABP_PPG_scaled.csv W18tmp.csv
cp ./W17_G12_072454_38854_II_V_ABP_PPG_scaled.csv W17tmp.csv
cp ./W16_G12_023924_38951_II_V_ABP_PPG_scaled.csv W16tmp.csv
cp ./W15_G12_021904_38949_II_V_ABP_PPG_scaled.csv W15tmp.csv
cp ./W13_F39_075749_38715_II_V_ABP_PPG_scaled.csv W13tmp.csv
cp ./W12_F38_075539_38758_II_V_ABP_PPG_scaled.csv W12tmp.csv
cp ./W11_F38_075012_38759_II_V_ABP_PPG_scaled.csv W11tmp.csv
cp ./W10_F36_041027_38586_II_V_ABP_PPG_scaled.csv W10tmp.csv

% Then: by hand (really?) open each
%       find out slope & intercept
%       create the 3 sed/cp lines for that file
%       delete the top 8 lines



% NO LONGER USING THIS!!! SEE BELOW FOR NEW sed LINES!
% Then run... 
% First line: removes all lines beginning with #
% Second line: replaces all " ," with "," (read as NULL) - can put into SQL float col
% Third line (NO LONGER USING!): replaces final "," with subjID, slope, intercept
% Fourth line: saves zTMP2.csv as pyr[id].csv
sed '/^#/ d' W10tmp.csv > zTMP3.csv
sed 's/ ,/,/g' zTMP3.csv > zTMP.csv
sed 's/\(.*\),/\1,W10,0.312500,34.062500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW10.csv
cp ./zTMP.csv pyrW10.csv

sed 's/ ,/,/g' W12tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W12,0.260413,50.052547/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW12.csv

sed 's/ ,/,/g' W13tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W13,0.260414,45.052327/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW13.csv

sed 's/ ,/,/g' W15tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W15,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW15.csv


sed 's/ ,/,/g' W16tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W16,0.468750,41.093750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW16.csv

sed 's/ ,/,/g' W17tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W17,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW17.csv

sed 's/ ,/,/g' W18tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W18,0.416670,42.083073/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW18.csv

sed 's/ ,/,/g' W19tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W19,0.156250,42.031250/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW19.csv


sed 's/ ,/,/g' W21tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W21,0.468750,26.093750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW21.csv

sed 's/ ,/,/g' W22tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W22,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW22.csv

sed 's/ ,/,/g' W23tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W23,0.208344,31.039985/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW23.csv

sed 's/ ,/,/g' W24tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W24,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW24.csv


sed 's/ ,/,/g' W25tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W25,0.364584,38.072831/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW25.csv

sed 's/ ,/,/g' W26tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W26,0.520833,50.104155/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW26.csv

sed 's/ ,/,/g' W27tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W27,0.520830,50.104374/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW27.csv

sed 's/ ,/,/g' W28tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W28,0.416667,47.083270/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW28.csv

sed 's/ ,/,/g' W29tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W29,0.312500,44.062500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW29.csv

sed 's/ ,/,/g' W30tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W30,0.364584,43.072774/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW30.csv


sed 's/ ,/,/g' W5tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W5,0.260414,30.052306/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW5.csv

sed 's/ ,/,/g' W7tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W7,0.729169,16.145698/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW7.csv

sed 's/ ,/,/g' W8tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W8,0.625000,-11.875000/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW8.csv

sed 's/ ,/,/g' W9tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W9,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW9.csv


sed 's/ ,/,/g' W31tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W31,0.416666,37.083219/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW31.csv

sed 's/ ,/,/g' W32tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W32,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW32.csv

sed 's/ ,/,/g' W33tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W33,0.312500,44.062500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW33.csv

sed 's/ ,/,/g' W34tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W34,0.260415,45.052123/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW34.csv

sed 's/ ,/,/g' W37tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W37,0.208337,51.041474/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW37.csv

sed 's/ ,/,/g' W38tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W38,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW38.csv

sed 's/ ,/,/g' W39tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W39,0.260423,50.051470/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW39.csv

sed 's/ ,/,/g' W40tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W40,0.312500,54.062500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW40.csv


sed 's/ ,/,/g' W41tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W41,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW41.csv

sed 's/ ,/,/g' W42tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W42,0.937500,-17.812500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW42.csv

sed 's/ ,/,/g' W45tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W45,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW45.csv

sed 's/ ,/,/g' W47tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W47,0.260416,50.052050/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW47.csv

sed 's/ ,/,/g' W48tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W48,0.572918,-10.885582/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW48.csv

sed 's/ ,/,/g' W49tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W49,0.572916,-10.885340/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW49.csv

sed 's/ ,/,/g' W51tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,W51,0.416667,52.083220/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrW51.csv


sed 's/ ,/,/g' Y1tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y1,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY1.csv

sed 's/ ,/,/g' Y4tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y4,0.937500,-17.812500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY4.csv

sed 's/ ,/,/g' Y6tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y6,0.937500,-17.812500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY6.csv

sed 's/ ,/,/g' Y11tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y11,0.312500,59.062500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY11.csv

sed 's/ ,/,/g' Y13tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y13,0.937500,-17.812500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY13.csv

sed 's/ ,/,/g' Y15tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y15,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY15.csv

sed 's/ ,/,/g' Y17tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y17,0.572917,-10.885509/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY17.csv

sed 's/ ,/,/g' Y19tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y19,0.312500,44.062500/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY19.csv

sed 's/ ,/,/g' Y20tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y20,0.468750,31.093750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY20.csv


sed 's/ ,/,/g' Y21tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y21,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY21.csv

sed 's/ ,/,/g' Y23tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y23,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY23.csv

sed 's/ ,/,/g' Y24tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y24,0.416667,62.083184/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY24.csv

sed 's/ ,/,/g' Y25tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y25,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY25.csv

sed 's/ ,/,/g' Y26tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y26,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY26.csv

sed 's/ ,/,/g' Y27tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y27,1.041663,-19.791301/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY27.csv

sed 's/ ,/,/g' Y28tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y28,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY28.csv

sed 's/ ,/,/g' Y29tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y29,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY29.csv

sed 's/ ,/,/g' Y30tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y30,1.041670,-19.792044/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY30.csv

sed 's/ ,/,/g' Y31tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y31,0.156250,42.031250/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY31.csv

sed 's/ ,/,/g' Y32tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y32,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY32.csv

sed 's/ ,/,/g' Y33tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y33,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY33.csv

sed 's/ ,/,/g' Y34tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y34,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY34.csv

sed 's/ ,/,/g' Y35tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y35,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY35.csv

sed 's/ ,/,/g' Y36tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Y36,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrY36.csv


sed 's/ ,/,/g' Z1tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z1,0.625000,-11.875000/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ1.csv

sed 's/ ,/,/g' Z2tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z2,0.468750,-8.906250/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ2.csv

sed 's/ ,/,/g' Z3tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z3,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ3.csv

sed 's/ ,/,/g' Z5tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z5,0.625000,-11.875000/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ5.csv

sed 's/ ,/,/g' Z6tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z6,0.364583,53.072996/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ6.csv

sed 's/ ,/,/g' Z9tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z9,0.364585,33.072793/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ9.csv

sed 's/ ,/,/g' Z14tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z14,0.468750,51.093750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ14.csv

sed 's/ ,/,/g' Z15tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z15,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ15.csv

sed 's/ ,/,/g' Z16tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z16,0.781250,-14.843750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ16.csv

sed 's/ ,/,/g' Z17tmp.csv > zTMP.csv
sed 's/\(.*\),/\1,Z17,0.468750,51.093750/g' zTMP.csv > zTMP2.csv
cp ./zTMP2.csv pyrZ17.csv





% NEW sed lines!
% Then run...
% First line: removes all lines beginning with #
% Second and third line: replaces all " ," and ", " with "," (read as NULL) - can put into SQL float col
% Fourth line: saves zTMP3.csv as pyr[id].csv

% first pass: W10-19, all Z
sed '/^#/ d' W5tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW5.csv

sed '/^#/ d' W7tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW7.csv

sed '/^#/ d' W8tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW8.csv

sed '/^#/ d' W9tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW9.csv

sed '/^#/ d' W10tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW10.csv

sed '/^#/ d' W11tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW11.csv

sed '/^#/ d' W12tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW12.csv

sed '/^#/ d' W13tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW13.csv

sed '/^#/ d' W15tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW15.csv

sed '/^#/ d' W16tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW16.csv

sed '/^#/ d' W17tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW17.csv

sed '/^#/ d' W18tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW18.csv

sed '/^#/ d' W19tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW19.csv

sed '/^#/ d' W21tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW21.csv

sed '/^#/ d' W22tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW22.csv

sed '/^#/ d' W23tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW23.csv

sed '/^#/ d' W24tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW24.csv

sed '/^#/ d' W25tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW25.csv

sed '/^#/ d' W26tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW26.csv

sed '/^#/ d' W27tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW27.csv

sed '/^#/ d' W28tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW28.csv

sed '/^#/ d' W29tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW29.csv

sed '/^#/ d' W30tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW30.csv

sed '/^#/ d' W31tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW31.csv

sed '/^#/ d' W32tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW32.csv

sed '/^#/ d' W33tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW33.csv

sed '/^#/ d' W34tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW34.csv

sed '/^#/ d' W37tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW37.csv

sed '/^#/ d' W38tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW38.csv

sed '/^#/ d' W39tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW39.csv

sed '/^#/ d' W40tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW40.csv

sed '/^#/ d' W41tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW41.csv

sed '/^#/ d' W42tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW42.csv

sed '/^#/ d' W45tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW45.csv

sed '/^#/ d' W47tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW47.csv

sed '/^#/ d' W48tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW48.csv

sed '/^#/ d' W49tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW49.csv

sed '/^#/ d' W51tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrW51.csv


sed '/^#/ d' Y1tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY1.csv

sed '/^#/ d' Y4tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY4.csv

sed '/^#/ d' Y6tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY6.csv

sed '/^#/ d' Y20tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY20.csv

sed '/^#/ d' Y21tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY21.csv

sed '/^#/ d' Y23tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY23.csv

sed '/^#/ d' Y24tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY24.csv

sed '/^#/ d' Y25tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY25.csv

sed '/^#/ d' Y26tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY26.csv

sed '/^#/ d' Y27tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY27.csv

sed '/^#/ d' Y28tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY28.csv

sed '/^#/ d' Y29tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY29.csv

sed '/^#/ d' Y30tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY30.csv

sed '/^#/ d' Y31tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY31.csv

sed '/^#/ d' Y32tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY32.csv

sed '/^#/ d' Y33tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY33.csv

sed '/^#/ d' Y34tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY34.csv

sed '/^#/ d' Y35tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY35.csv

sed '/^#/ d' Y36tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrY36.csv


sed '/^#/ d' Z1tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ1.csv

sed '/^#/ d' Z2tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ2.csv

sed '/^#/ d' Z3tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ3.csv

sed '/^#/ d' Z5tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ5.csv

sed '/^#/ d' Z6tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ6.csv

sed '/^#/ d' Z9tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ9.csv

sed '/^#/ d' Z14tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ14.csv

sed '/^#/ d' Z15tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ15.csv

sed '/^#/ d' Z16tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ16.csv

sed '/^#/ d' Z17tmp.csv > zTMP.csv
sed 's/ ,/,/g' zTMP.csv > zTMP2.csv
sed 's/, /,/g' zTMP2.csv > zTMP3.csv
cp ./zTMP3.csv pyrZ17.csv






ticksPerSecond = 1/125; % 125 Hz measurement (put back into seconds)
hold on
plot([1:20000]*ticksPerSecond,delMe.unscaledABP(1:20000),'DisplayName','UnscaledABP')
plot([1:20000]*ticksPerSecond,delMe.scaledABP(1:20000),'DisplayName','ScaledABP') 
plot([1:20000]*ticksPerSecond,delMe.scaledDBP_valley_(1:20000),'ro','DisplayName','estDBP')
plot([1:20000]*ticksPerSecond,delMe.scaledSBP_peak_(1:20000),'rx','DisplayName','estSBP')
%legend('Unscaled_ABP','Scaled_ABP','estSBP','estDBP')
legend('Location','northeast')
%legend('UnscaledABP','ScaledABP','estSBP','estDBP')
xlabel('Seconds')
ylabel('mm Hg')
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',24)
hold off

figure
hold on
plot([5962000:5964000]*ticksPerSecond,delMe.unscaledABP(5962000:5964000),'DisplayName','UnscaledABP')
plot([5962000:5964000]*ticksPerSecond,delMe.scaledABP(5962000:5964000),'DisplayName','ScaledABP') 
plot([5962000:5964000]*ticksPerSecond,delMe.scaledDBP_valley_(5962000:5964000),'ro','DisplayName','estDBP')
plot([5962000:5964000]*ticksPerSecond,delMe.scaledSBP_peak_(5962000:5964000),'rx','DisplayName','estSBP')
%legend('Unscaled_ABP','Scaled_ABP','estSBP','estDBP')
%legend('Location','northeast')
%legend('UnscaledABP','ScaledABP','estSBP','estDBP')
%xlim(5962000, 5964000)
xlabel('Seconds')
ylabel('mm Hg')
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',24)
hold off

5963300
3705000

figure
hold on
plot([3690000:3707000]*ticksPerSecond,delMe5.unscaledABP(3690000:3707000),'DisplayName','UnscaledABP')
plot([3690000:3707000]*ticksPerSecond,delMe5.scaledABP(3690000:3707000),'DisplayName','ScaledABP') 
plot([3690000:3707000]*ticksPerSecond,delMe5.scaledDBP_valley_(3690000:3707000),'ro','DisplayName','estDBP')
plot([3690000:3707000]*ticksPerSecond,delMe5.scaledSBP_peak_(3690000:3707000),'rx','DisplayName','estSBP')
%legend('Unscaled_ABP','Scaled_ABP','estSBP','estDBP')
%legend('Location','northeast')
%legend('UnscaledABP','ScaledABP','estSBP','estDBP')
%xlim(5962000, 5964000)
xlabel('Seconds')
ylabel('mm Hg')
set(findall(gca,'type','text'),'FontSize',24)
set(findall(gca,'type','axes'),'FontSize',24)
hold off


% let's try to write these data out in a better format for SQL import
subjID = 'W49';
slope = '0.572916';
intercept = '-10.885340';
fileID = fopen('/Users/z_home/Downloads/PyrAmesData/zTry2.csv','w');
tic
for i = 1:height(delMe)
%fprintf(fileID,'%s,%d,%f,%f,%f,%f',delMe.x_Time{1},delMe.unscaledABP(1),delMe.scaledABP(1),delMe.scaledSBP_peak_(1),delMe.scaledDBP_valley_(1),delMe.clippedABP(1));
    fprintf(fileID,'%s,%s,%d,',subjID,delMe.x_Time{i},delMe.unscaledABP(i));
    if (isnan(delMe.scaledSBP_peak_(i)))
        fprintf(fileID,'NULL,');
    else
        fprintf(fileID,'%f,',delMe.scaledSBP_peak_(i));
    end
    if (isnan(delMe.scaledDBP_valley_(i)))
        fprintf(fileID,'NULL,');
    else
        fprintf(fileID,'%f,',delMe.scaledDBP_valley_(i));
    end
    if (isnan(delMe.clippedABP(i)))
        fprintf(fileID,'NULL,');
    else
        fprintf(fileID,'%f,',delMe.clippedABP(i));
    end
    fprintf(fileID,'%s,%s\n',slope,intercept);
end
fclose(fileID);
toc
