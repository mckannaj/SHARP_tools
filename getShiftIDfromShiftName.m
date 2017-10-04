% Zephy McKanna
% 1/5/17
% getShiftIDfromShiftName()
% 
% This function takes a shift name and returns a unique identifier. If
% nVal is a number (>0), it will add nVal to this ID, making a different
% unique identifier. None of these will overlap.
% 
% Note if using "ActualN" as the input, that this lists an N value (I think
% 1) for shifts that don't actually have an N-back component. 
%
function [shiftID] = getShiftIDfromShiftName(shiftName, nVal, verbose)
    if (nargin ~= nargin('getShiftIDfromShiftName'))
        error('getShiftIDfromShiftName expects %d inputs, but received %d. Please update any calling code.\n', nargin('getShiftIDfromShiftName'), nargin);
    end
    
    shiftID = 0; % assume unknown / error
    switch shiftName
        case {'Color Balancing (U)','Color Balancing','ColorBalancing','ColorBalancingU'} 
            shiftID = 100;
        case {'Duplicate Mitigation (U)','Duplicate Mitigation','DuplicateMitigation','DuplicateMitigationU'} 
            shiftID = 200;
        case {'Green Synergizing (I)','Green Synergizing','GreenSynergizing','GreenSynergizingI'}
            shiftID = 300;
        case {'Locomotive Training (I)','Locomotive Training','LocomotiveTraining','LocomotiveTrainingI'}
            shiftID = 400;
        case {'Limb Management (I)','Limb Management','LimbManagement','LimbManagementI'} 
            shiftID = 500;
        case {'Stereoizing (I)','Stereoizing','StereoizingI'} 
            shiftID = 600;
        case {'Special Orders (S)','Special Orders','SpecialOrders','SpecialOrdersS'} 
            shiftID = 700;
        case {'Monocular Inspection (S)','Monocular Inspection','MonocularInspection','MonocularInspectionS'}
            shiftID = 800;
        case {'Part Number Balancing (S)','Part Number Balancing','PartNumberBalancing','PartNumberBalancingS'} 
            shiftID = 900;
        case {'Altitude Viewing (S)','Altitude Viewing','AltitudeViewing','AltitudeViewingS'} 
            shiftID = 1000;
        case {'Eye Inspection (U/I)','Eye Inspection','EyeInspection','EyeInspectionUI'} 
            shiftID = 1100;
        case {'Head and Shoulders (U/I)','Head and Shoulders','HeadandShoulders','HeadandShouldersUI'}
            shiftID = 1200;
        case {'Odditizing (U/I)','Odditizing','OdditizingUI'} 
            shiftID = 1300;
        case {'Cranial Equilibrium (U/I)','Cranial Equilibrium','CranialEquilibrium','CranialEquilibriumUI'} 
            shiftID = 1400;
        case {'Arm Matching (U/I)','Arm Matching','ArmMatching','ArmMatchingUI'}
            shiftID = 1500;
        case {'Arm Prioritization (S/I)','Arm Prioritization','ArmPrioritization','ArmPrioritizationSI'}
            shiftID = 1600;
        case {'Part Calculation (S/I)','Part Calculation','PartCalculation','PartCalculationSI'} 
            shiftID = 1700;
        case {'Head Removal (S/I)','Head Removal','HeadRemoval','HeadRemovalSI'} 
            shiftID = 1800;
        case {'Chromatic Manipulation (S/I)','Chromatic Manipulation','ChromaticManipulation','ChromaticManipulationSI'}
            shiftID = 1900;
        case {'Part ID Gleaning (U/S)','Part ID Gleaning','PartIDGleaning','PartIDGleaningUS'} 
            shiftID = 2000;
        case {'Eye Scrobbling (U/S)','Eye Scrobbling','EyeScrobbling','EyeScrobblingUS'} 
            shiftID = 2100;
        case {'Optical Positioning (U/S)','OpticalPositioning','Optical Positioning','OpticalPositioningUS'}
            shiftID = 2200;
        case {'Achievement Hunting (U/S)','Achievement Hunting','AchievementHunting','AchievementHuntingUS'} 
            shiftID = 2300;
        case {'Eye Symmetrizing (U)','Eye Symmetrizing','EyeSymmetrizing','EyeSymmetrizingU'} 
            shiftID = 2400;
        case {'Hand Exemption (U)','Hand Exemption','HandExemption','HandExemptionU'} 
            shiftID = 2500;
        case {'Braincase Downsizing (I)','Braincase Downsizing','BraincaseDownsizing','BraincaseDownsizingI'}
            shiftID = 2600;
        case {'Eye Intermediation (I)','Eye Intermediation','EyeIntermediation','EyeIntermediationI'} 
            shiftID = 2700;
        case {'Sensor Peripheralizing (S)','Sensor Peripheralizing','SensorPeripheralizing','SensorPeripheralizingS'} 
            shiftID = 2800;
        case {'Head Heuristics (S)','Head Heuristics','HeadHeuristics','HeadHeuristicsS'} 
            shiftID = 2900;
        case {'Digit Arrangment (U/I)','Digit Arrangment','DigitArrangment','DigitArrangmentUI'}
            shiftID = 3000;
        case {'PIN Defraudment (U/I)','PIN Defraudment','PINDefraudment','PINDefraudmentUI'} 
            shiftID = 3100;
        case {'Ocular Orientation (S/I)','Ocular Orientation','OcularOrientation','OcularOrientationSI'} 
            shiftID = 3200;
        case {'Limb Chromatizing (U/S)','Limb Chromatizing','LimbChromatizing','LimbChromatizingUS'} 
            shiftID = 3300;
        case {'Serial Verification (U/S)','Serial Verification','SerialVerification','SerialVerificationUS'}
            shiftID = 3400;
        case {'Uniqueness Justification (U/S)','Uniqueness Justification','UniquenessJustification','UniquenessJustificationUS'} 
            shiftID = 3500;
        case {'4b T:1a - rm Prrtzng','4bT:1a-rmPrrtzng','rmPrrtzng'} 
            shiftID = 3600;
        case {'4b T:1c - AAAAAAAA','AAAAAAAA','4bT:1c-AAAAAAAA'} 
            shiftID = 3700;
        case {'4b T:1b - O_gan Failure?','O_gan Failure?','O_ganFailure','OganFailure','O+ganFailure','O/ganFailure','Ogan Failure','4bT:1b-O_gan Failure?'}
            shiftID = 3800;
        case {'4b T:2a - Meat-Bag Edition','MeatBagEdition','Meat-Bag Edition','4bT:2a-Meat-BagEdition'} 
            shiftID = 3900;
        case {'Simple Allocating','SimpleAllocating'} 
            shiftID = 4000;
        case {'Basic Organizing','BasicOrganizing'} 
            shiftID = 4100;
        case {'Mid-level Syngergizing','Mid-levelSyngergizing','MidlevelSyngergizing'}
            shiftID = 4200;
        case {'Advanced Allocating','AdvancedAllocating'} 
            shiftID = 4300;
        case {'Mega Clumpifying','MegaClumpifying'} 
            shiftID = 4400;
        case {'Intense Glombing','IntenseGlombing'}
            shiftID = 4500;
        case {'Basic Fitting (U)','BasicFittingU','Basic Fitting','BasicFitting'} 
            shiftID = 4600;
        case {'Symbolic Matching (U)','SymbolicMatchingU','SymbolicMatching','Symbolic Matching'} 
            shiftID = 4700;
        case {'Green Synergizing 2 (I)','GreenSynergizing2I','GreenSynergizing2','Green Synergizing 2'} 
            shiftID = 4800;
        case {'Fault Limitations (I)','FaultLimitations','Fault Limitations','FaultLimitationsI'}
            shiftID = 4900;
        case {'Gamifying Medicine (I)','GamifyingMedicine','Gamifying Medicine','GamifyingMedicineI'} 
            shiftID = 5000;
        case {'Colorizing Careers (I)','ColorizingCareers','Colorizing Careers','ColorizingCareersI'} 
            shiftID = 5100;
        case {'Head Hueing (S)','HeadHueing','Head Hueing','HeadHueingS'} 
            shiftID = 5200;
        case {'Fracture Mitigation (S)','FractureMitigation','Fracture Mitigation','FractureMitigationS'}
            shiftID = 5300;
        case {'Chestial Numbering (S)','ChestialNumbering','Chestial Numbering','ChestialNumberingS'} 
            shiftID = 5400;
        case {'Designation Tinting (S)','Designation Tinting','DesignationTinting','DesignationTintingS'} 
            shiftID = 5500;
        case {'Chest Digitizing (U/I)','ChestDigitizing','Chest Digitizing','ChestDigitizingUI'} 
            shiftID = 5600;
        case {'Limb Reparations (U/I)','LimbReparations','Limb Reparations','LimbReparationsUI'}
            shiftID = 5700;
        case {'Brain Deficiencies (U/I)','Brain Deficiencies','BrainDeficiencies','BrainDeficienciesUI'} 
            shiftID = 5800;
        case {'Iconography (S/I)','Iconography','IconographySI'} 
            shiftID = 5900;
        case {'Failure Drilling (S/I)','FailureDrilling','Failure Drilling','FailureDrillingSI'} 
            shiftID = 6000;
        case {'Dangerous Gaming (S/I)','DangerousGaming','Dangerous Gaming','DangerousGamingSI'}
            shiftID = 6100;
        case {'Battlefield Medicine (S/I)','BattlefieldMedicine','Battlefield Medicine','BattlefieldMedicineSI'} 
            shiftID = 6200;
        case {'Cross Checking (U/S)','CrossChecking','Cross Checking','CrossCheckingUS'} 
            shiftID = 6300;
        case {'Naturalized Decommissioning (U/S)','NaturalizedDecommissioning','Naturalized Decommissioning','NaturalizedDecommissioningUS'}
            shiftID = 6400;
        case {'Advanced Categorization (U/S)','AdvancedCategorization','Advanced Categorization','AdvancedCategorizationUS'}
            shiftID = 6500;
        case {'Compliance Distributing','ComplianceDistributing'} 
            shiftID = 6600;
        case {'Logistical Analyzing','LogisticalAnalyzing'} 
            shiftID = 6700;
        case {'Product Paradigming','ProductParadigming'}
            shiftID = 6800;
        case {'Orchestrating Compliance','OrchestratingCompliance'} 
            shiftID = 6900;
        case {'Assemblage Fabrication','AssemblageFabrication'} 
            shiftID = 7000;
        case {'Maximum Fingling','MaximumFingling'}
            shiftID = 7100;
        case {'Organism Culling (U)','OrganismCulling','Organism Culling','OrganismCullingU'} 
            shiftID = 7200;
        case {'Count Quantizing (U)','CountQuantizing','Count Quantizing','CountQuantizingU'} 
            shiftID = 7300;
        case {'Memory Management(U)','MemoryManagement','Memory Management','MemoryManagementU'} 
            shiftID = 7400;
        case {'Snake Identification (I)','Snake Identification','SnakeIdentification','SnakeIdentificationI'}
            shiftID = 7500;
        case {'Transportationization (I)','Transportationization','TransportationizationI'} 
            shiftID = 7600;
        case {'Emotional Imprinting (I)','EmotionalImprinting','Emotional Imprinting','EmotionalImprintingI'} 
            shiftID = 7700;
        case {'Map Orgling (I)','MapOrgling','Map Orgling','MapOrglingI'} 
            shiftID = 7800;
        case {'Genderization (S)','Genderization','GenderizationS'}
            shiftID = 7900;
        case {'Lesson Planning (S)','LessonPlanning','Lesson Planning','LessonPlanningS'} 
            shiftID = 8000;
        case {'Job Differentiation (S)','JobDifferentiation','Job Differentiation','JobDifferentiationS'} 
            shiftID = 8100;
        case {'Face Numbering (U/I)','FaceNumbering','Face Numbering','FaceNumberingUI'} 
            shiftID = 8200;
        case {'Terrestrial Tiering (U/I)','Terrestrial Tiering','TerrestrialTiering','TerrestrialTieringUI'}
            shiftID = 8300;
        case {'Aeronautical Categorization (S/I)','Aeronautical Categorization','AeronauticalCategorization','AeronauticalCategorizationSI'} 
            shiftID = 8400;
        case {'Craftsmans Critiquing (S/I)','Craftsmans Critiquing','CraftsmansCritiquing','CraftsmansCritiquingSI'} 
            shiftID = 8500;
        case {'Avoidance Training (S/I)','AvoidanceTraining','Avoidance Training','AvoidanceTrainingSI'}
            shiftID = 8600;
        case {'Aviation Aspectizing (U/S)','Aviation Aspectizing','AviationAspectizing','AviationAspectizingUS'} 
            shiftID = 8700;
        case {'Intent Estimation (U/S)','Intent Estimation','IntentEstimation','IntentEstimationUS'} 
            shiftID = 8800;
        case {'Verbal Repetition (U)','Verbal Repetition','VerbalRepetition','VerbalRepetitionU'} 
            shiftID = 8900;
        case {'Primetizing (U)','Primetizing','PrimetizingU'}
            shiftID = 9000;
        case {'ATC Prioritizing (I)','ATC Prioritizing','ATCPrioritizing','ATCPrioritizingI'} 
            shiftID = 9100;
        case {'Serpentinian Exclusion (I)','Serpentinian Exclusion','SerpentinianExclusion','SerpentinianExclusionI'} 
            shiftID = 9200;
        case {'Emotionalizing Literature (S)','Emotionalizing Literature','EmotionalizingLiterature','EmotionalizingLiteratureS'}
            shiftID = 9300;
        case {'Avionic Sequentializing (S)','Avionic Sequentializing','AvionicSequentializing','AvionicSequentializingS'} 
            shiftID = 9400;
        case {'PI Memorization (U/I)','PI Memorization','PIMemorization','PIMemorizationUI'} 
            shiftID = 9500;
        case {'Cartography Catharsis (S/I)','Cartography Catharsis','CartographyCatharsis','CartographyCatharsisSI'}
            shiftID = 9600;
        case {'Genus Logistics (U/S)','Genus Logistics','GenusLogistics','GenusLogisticsUS'} 
            shiftID = 9700;
        case {'Culinary Itemization (U/S)','Culinary Itemization','CulinaryItemization','CulinaryItemizationUS'} 
            shiftID = 9800;
        case {'Arithmetic Training (U/S)','Arithmetic Training','ArithmeticTraining','ArithmeticTrainingUS'}
            shiftID = 9900;
        case {'Word/Number Partitioning (U/S)','Word/Number Partitioning','WordNumber Partitioning','WordNumberPartitioning','Word/NumberPartitioningUS'} 
            shiftID = 10000;
        case {'4b T:3a - Specializations','4bT3aSpecializations','4bT:3a-Specializations','Specializations'} 
            shiftID = 10100;
        case {'4b T:3c - Penultimations','4bT3cPenultimations','4bT:3c-Penultimations','Penultimations'}
            shiftID = 10200;
        case {'4b T:2b - For exceptional testers','4bT:2b-Forexceptionaltesters','4bT2bForexceptionaltesters','For exceptional testers','Forexceptionaltesters'} 
            shiftID = 10300;
        case {'4b T:2c - Extended training','4bT:2c-Extendedtraining','4bT2cExtendedtraining','Extended training','Extendedtraining'} 
            shiftID = 10400;
        case {'Sort Grouping','SortGrouping'} 
            shiftID = 10500;
        case {'Input Processing','InputProcessing'}
            shiftID = 10600;
        case{'Defraggling'}
            shiftID = 10700;
        case {'Localized Vision (U)','Localized Vision','LocalizedVision','LocalizedVisionU'} 
            shiftID = 10800;
        case {'Spatial Troning (U)','Spatial Troning','SpatialTroning','SpatialTroningU'} 
            shiftID = 10900;
        case {'Flipper Exception (I)','Flipper Exception','FlipperException','FlipperExceptionI'} 
            shiftID = 11000;
        case {'Complex Biodigitizing (I)','Complex Biodigitizing','ComplexBiodigitizing','ComplexBiodigitizingI'}
            shiftID = 11100;
        case {'Area Allocation (S)','Area Allocation','AreaAllocation','AreaAllocationS'} 
            shiftID = 11200;
        case {'Conveyance Arithmetic (S)','Conveyance Arithmetic','ConveyanceArithmetic','ConveyanceArithmeticS'} 
            shiftID = 11300;
        case {'Language Crunching (U/I)','Language Crunching','LanguageCrunching','LanguageCrunchingUI'} 
            shiftID = 11400;
        case {'Generational Gapping  (S/I)','Generational Gapping','GenerationalGapping','GenerationalGappingSI'}
            shiftID = 11500;
        case {'Organizational Balancing (U/S)','Organizational Balancing','OrganizationalBalancing','OrganizationalBalancingUS'} 
            shiftID = 11600;
        case {'Organism Grading (U/S)','Organism Grading','OrganismGrading','OrganismGradingUS'} 
            shiftID = 11700;
        case {'Recognition Profiling (U/S)','Recognition Profiling','RecognitionProfiling','RecognitionProfilingUS'}
            shiftID = 11800;
        case {'Adv. Arithmetic Training (U/S)','Adv. Arithmetic Training','Adv Arithmetic Training','AdvArithmeticTraining','Adv.ArithmeticTrainingUS'} 
            shiftID = 11900;
        case {'4b T:3b - Extreme Categorizing','4bT3bExtremeCategorizing','4bT:3b-ExtremeCategorizing','Extreme Categorizing','ExtremeCategorizing'} 
            shiftID = 12000;
        case {'Refractilating Reticulations','RefractilatingReticulations'}
            shiftID = 12100;
        case {'Classification Sensing','ClassificationSensing'} 
            shiftID = 12200;
        case {'Complex Codifying','ComplexCodifying'}
            shiftID = 12300;
        case {'4a Update Switch V1 (U/S)','4a Update Switch V1','4aUpdateSwitchV1','4aUpdateSwitchV1US'} 
            shiftID = 12400;
        case {'4a Update Switch V1 - 2 (U/S)','4a Update Switch V1 - 2','4aUpdateSwitchV1-2','4aUpdateSwitchV12','4aUpdateSwitchV1-2US'} 
            shiftID = 12500;
        case {'Biological Itemizing (U/S)','Biological Itemizing','BiologicalItemizing','BiologicalItemizingUS'}
            shiftID = 12600;
        case {'Reptile Plotting (U/S)','Reptile Plotting','ReptilePlotting','ReptilePlottingUS'} 
            shiftID = 12700;
        case {'Algorithmic Comprehension (S/I)','Algorithmic Comprehension','AlgorithmicComprehension','AlgorithmicComprehensionSI'} 
            shiftID = 12800;
        case {'Typographic Trigonometry (U/I)','Typographic Trigonometry','TypographicTrigonometry','TypographicTrigonometryUI'}
            shiftID = 12900;
        case {'Theoretical Aerodynamics (U/I)','Theoretical Aerodynamics','TheoreticalAerodynamics','TheoreticalAerodynamicsUI'} 
            shiftID = 13000;
        case {'Mammalian Maneuvering (U/I)','Mammalian Maneuvering','MammalianManeuvering','MammalianManeuveringUI'} 
            shiftID = 13100;
        case {'4a Update Switch V2 (U/S)','4aUpdateSwitchV2','4a Update Switch V2','4aUpdateSwitchV2US'}
            shiftID = 13200;
        case {'4a Update Switch V2 - 2 (U/S)','4 UpdateSwitchV22','4aUpdateSwitchV2-2','4aUpdateSwitchV2-2US'} 
            shiftID = 13300;
        case {'Dimensional Jargonization (U/S)','Dimensional Jargonization','DimensionalJargonization','DimensionalJargonizationUS'} 
            shiftID = 13400;
        case {'Proportional Sympathizing (U/S)','Proportional Sympathizing','ProportionalSympathizing','ProportionalSympathizingUS'}
            shiftID = 13500;
        case {'Computational Vocalizations (S/I)','Computational Vocalizations','ComputationalVocalizations','ComputationalVocalizationsSI'} 
            shiftID = 13600;
        case {'Tetromino Groking (U/I)','Tetromino Groking','TetrominoGroking','TetrominoGrokingUI'}
            shiftID = 13700;
        otherwise
            error('getShiftIDfromShiftName: unexpected shift name: %s\n', shiftName);
    end
    
    if (nVal < 0) || (nVal > 99)
         warning('getShiftIDfromShiftName: nVal is unusual (%d); returned ID is likely to collide!\n', nVal);
    end
    if (nVal == 0)
        if (verbose == true)
            printf('Ignoring N values (nVal = 0).');
        end
    end

       
    shiftID = shiftID + nVal;
end

