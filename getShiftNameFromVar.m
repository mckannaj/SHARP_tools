% Zephy McKanna
% getShiftNameFromVar()
% 4/19/16
%
% This function is intended to take a variable name produced by
% getVarNameFromShift() and return the original shift name. If there is an
% N value on the end of the shift, it will also return that value.
% NOTE: it assumes the Nval is only a single char! (1-9)
%   ZEPH: fix this when you have time.
%
% If given a char, it will return a char. 
% If given a cell, it will return a cell.
% 
%
function [shiftName, nVal] = getShiftNameFromVar(variableName, verbose)
    varIsCell = 0; % first, check to see if we were given a cell
    if (iscell(variableName)) % the comparing needs to be done in a non-cell, so make sure shiftName isn't a cell
        modName = variableName{1}; % make it not a cell anymore
        varIsCell = 1; % note that it was one, so we can put it back before returning
    else
        modName = variableName;
    end

    % now remove the nValue, if any
    nVal = 0; % assume there is none
    if (strcmpi(modName(end-2:end-1),'_N') == 1) % there is '_N' on it
        nVal = str2double(modName(end));
        modName = modName(1:end-3); % remove the _N#
    end

    switch modName
        case 'rmPrrtzng'
            shiftName = '4b T:1a - rm Prrtzng';
        case 'OganFailure'
            shiftName = '4b T:1b - O_gan Failure?';
        case 'Forexceptionaltesters'
            shiftName = '4b T:2b - For exceptional testers';
        case 'Extendedtraining'
            shiftName = '4b T:2c - Extended training';
        case 'ExtremeCategorizing'
            shiftName = '4b T:3b - Extreme Categorizing';
        case 'Penultimations'
            shiftName = '4b T:3c - Penultimations';
        case 'ATCPrioritizing'
            shiftName = 'ATC Prioritizing (I)';
        case 'AeronauticalCategorization'
            shiftName = 'Aeronautical Categorization (S/I)';
        case 'AltitudeViewing'
            shiftName = 'Altitude Viewing (S)';
        case 'AreaAllocation'
            shiftName = 'Area Allocation (S)';
        case 'ArmPrioritization'
            shiftName = 'Arm Prioritization (S/I)';
        case 'AvionicSequentializing'
            shiftName = 'Avionic Sequentializing (S)';
        case 'BattlefieldMedicine'
            shiftName = 'Battlefield Medicine (S/I)';
        case 'BraincaseDownsizing'
            shiftName = 'Braincase Downsizing (I)';
        case 'CartographyCatharsis'
            shiftName = 'Cartography Catharsis (S/I)';
        case 'ChestialNumbering'
            shiftName = 'Chestial Numbering (S)';
        case 'ChromaticManipulation'
            shiftName = 'Chromatic Manipulation (S/I)';
        case 'CraftsmansCritiquing'
            shiftName = 'Craftsmans Critiquing (S/I)';
        case 'DangerousGaming'
            shiftName = 'Dangerous Gaming (S/I)';
        case 'DesignationTinting'
            shiftName = 'Designation Tinting (S)';
        case 'EmotionalImprinting'
            shiftName = 'Emotional Imprinting (I)';
        case 'EmotionalizingLiterature'
            shiftName = 'Emotionalizing Literature (S)';
        case 'EyeIntermediation'
            shiftName = 'Eye Intermediation (I)';
        case 'FailureDrilling'
            shiftName = 'Failure Drilling (S/I)';
        case 'FaultLimitations'
            shiftName = 'Fault Limitations (I)';
        case 'FlipperException'
            shiftName = 'Flipper Exception (I)';
        case 'FractureMitigation'
            shiftName = 'Fracture Mitigation (S)';
        case 'Genderization'
            shiftName = 'Genderization (S)';
        case 'GreenSynergizing'
            shiftName = 'Green Synergizing (I)';
        case 'GreenSynergizing2'
            shiftName = 'Green Synergizing 2 (I)';
        case 'HeadHeuristics'
            shiftName = 'Head Heuristics (S)';
        case 'HeadHueing'
            shiftName = 'Head Hueing (S)';
        case 'HeadRemoval'
            shiftName = 'Head Removal (S/I)';
        case 'Iconography'
            shiftName = 'Iconography (S/I)';
        case 'JobDifferentiation'
            shiftName = 'Job Differentiation (S)';
        case 'LessonPlanning'
            shiftName = 'Lesson Planning (S)';
        case 'LocomotiveTraining'
            shiftName = 'Locomotive Training (I)';
        case 'MapOrgling'
            shiftName = 'Map Orgling (I)';
        case 'MonocularInspection'
            shiftName = 'Monocular Inspection (S)';
        case 'OcularOrientation'
            shiftName = 'Ocular Orientation (S/I)';
        case 'PartCalculation'
            shiftName = 'Part Calculation (S/I)';
        case 'PartNumberBalancing'
            shiftName = 'Part Number Balancing (S)';
        case 'SensorPeripheralizing'
            shiftName = 'Sensor Peripheralizing (S)';
        case 'SerpentinianExclusion'
            shiftName = 'Serpentinian Exclusion (I)';
        case 'SnakeIdentification'
            shiftName = 'Snake Identification (I)';
        case 'SpecialOrders'
            shiftName = 'Special Orders (S)';
        case 'Stereoizing'
            shiftName = 'Stereoizing (I)';
        case 'AAAAAAAA'
            shiftName = '4b T:1c - AAAAAAAA';
        case 'MeatBagEdition'
            shiftName = '4b T:2a - Meat-Bag Edition';
        case 'Specializations'
            shiftName = '4b T:3a - Specializations';
        case 'AchievementHunting'
            shiftName = 'Achievement Hunting (U/S)';
        case 'AlgorithmicComprehension'
            shiftName = 'Algorithmic Comprehension (S/I)';
        case 'ArmMatching'
            shiftName = 'Arm Matching (U/I)';
        case 'AviationAspectizing'
            shiftName = 'Aviation Aspectizing (U/S)';
        case 'BasicFitting'
            shiftName = 'Basic Fitting (U)';
        case 'BiologicalItemizing'
            shiftName = 'Biological Itemizing (U/S)';
        case 'BrainDeficiencies'
            shiftName = 'Brain Deficiencies (U/I)';
        case 'ChestDigitizing'
            shiftName = 'Chest Digitizing (U/I)';
        case 'ColorBalancing'
            shiftName = 'Color Balancing (U)';
        case 'ComputationalVocalizations'
            shiftName = 'Computational Vocalizations (S/I)';
        case 'CountQuantizing'
            shiftName = 'Count Quantizing (U)';
        case 'CranialEquilibrium'
            shiftName = 'Cranial Equilibrium (U/I)';
        case 'CrossChecking'
            shiftName = 'Cross Checking (U/S)';
        case 'CulinaryItemization'
            shiftName = 'Culinary Itemization (U/S)';
        case 'DigitArrangment'
            shiftName = 'Digit Arrangment (U/I)';
        case 'DimensionalJargonization'
            shiftName = 'Dimensional Jargonization (U/S)';
        case 'DuplicateMitigation'
            shiftName = 'Duplicate Mitigation (U)';
        case 'EyeInspection'
            shiftName = 'Eye Inspection (U/I)';
        case 'EyeScrobbling'
            shiftName = 'Eye Scrobbling (U/S)';
        case 'EyeSymmetrizing'
            shiftName = 'Eye Symmetrizing (U)';
        case 'FaceNumbering'
            shiftName = 'Face Numbering (U/I)';
        case 'GenusLogistics'
            shiftName = 'Genus Logistics (U/S)';
        case 'HandExemption'
            shiftName = 'Hand Exemption (U)';
        case 'HeadandShoulders'
            shiftName = 'Head and Shoulders (U/I)';
        case 'IntentEstimation'
            shiftName = 'Intent Estimation (U/S)';
        case 'LanguageCrunching'
            shiftName = 'Language Crunching (U/I)';
        case 'LimbChromatizing'
            shiftName = 'Limb Chromatizing (U/S)';
        case 'LimbReparations'
            shiftName = 'Limb Reparations (U/I)';
        case 'LocalizedVision'
            shiftName = 'Localized Vision (U)';
        case 'MemoryManagement'
            shiftName = 'Memory Management(U)';
        case 'NaturalizedDecommissioning'
            shiftName = 'Naturalized Decommissioning (U/S)';
        case 'Odditizing'
            shiftName = 'Odditizing (U/I)';
        case 'OpticalPositioning'
            shiftName = 'Optical Positioning (U/S)';
        case 'OrganismCulling'
            shiftName = 'Organism Culling (U)';
        case 'OrganismGrading'
            shiftName = 'Organism Grading (U/S)';
        case 'OrganizationalBalancing'
            shiftName = 'Organizational Balancing (U/S)';
        case 'PIMemorization'
            shiftName = 'PI Memorization (U/I)';
        case 'PartIDGleaning'
            shiftName = 'Part ID Gleaning (U/S)';
        case 'Primetizing'
            shiftName = 'Primetizing (U)';
        case 'ProportionalSympathizing'
            shiftName = 'Proportional Sympathizing (U/S)';
        case 'ReptilePlotting'
            shiftName = 'Reptile Plotting (U/S)';
        case 'SerialVerification'
            shiftName = 'Serial Verification (U/S)';
        case 'SymbolicMatching'
            shiftName = 'Symbolic Matching (U)';
        case 'TetrominoGroking'
            shiftName = 'Tetromino Groking (U/I)';
        case 'TheoreticalAerodynamics'
            shiftName = 'Theoretical Aerodynamics (U/I)';
        case 'TypographicTrigonometry'
            shiftName = 'Typographic Trigonometry (U/I)';
        case 'VerbalRepetition'
            shiftName = 'Verbal Repetition (U)';
        otherwise
            variableName % Z - there has to be a way to put strings into an error message, right? Figure it out.
            error('Unknown variable name (just above this line)');
    end
    
    if (varIsCell == 1) % we were given a cell; make it one again
        shiftName = {shiftName};
    end
end