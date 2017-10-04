% Zephy McKanna
% 1/8/17
% getShiftNamefromShiftID()
% 
% This function takes the ID produced by getShiftIDfromShiftName() and
% returns the shift name and N value, if any. Note that IDs exist which
% make no sense (e.g., positive N values for an inhibit-only shift). This
% function will not alert you to nonsense inputs (GIGO).
% 
% Note if comparing to "ActualN", that this lists an N value (I think
% 1) for shifts that don't actually have an N-back component. 
%
function [shiftName, nVal] = getShiftNamefromShiftID(shiftID)
    if (nargin ~= nargin('getShiftNamefromShiftID'))
        error('getShiftNamefromShiftID expects %d inputs, but received %d. Please update any calling code.\n', nargin('getShiftNamefromShiftID'), nargin);
    end
    
    shiftName = ''; % assume unknown / error
    if (shiftID < 100)
        error('getShiftNamefromShiftID: unexpected shift ID: %d\n', shiftID);
    elseif (shiftID < 200)
        shiftName = 'Color Balancing (U)';
    elseif (shiftID < 300)
        shiftName = 'Duplicate Mitigation (U)';
    elseif (shiftID < 400)
        shiftName = 'Green Synergizing (I)';
    elseif (shiftID < 500)
        shiftName = 'Locomotive Training (I)';
    elseif (shiftID < 600)
        shiftName = 'Limb Management (I)';
    elseif (shiftID < 700)
        shiftName = 'Stereoizing (I)';
    elseif (shiftID < 800)
        shiftName = 'Special Orders (S)';
    elseif (shiftID < 900)
        shiftName = 'Monocular Inspection (S)';
    elseif (shiftID < 1000)
        shiftName = 'Part Number Balancing (S)';
    elseif (shiftID < 1100)
        shiftName = 'Altitude Viewing (S)';
    elseif (shiftID < 1200)
        shiftName = 'Eye Inspection (U/I)';
    elseif (shiftID < 1300)
        shiftName = 'Head and Shoulders (U/I)';
    elseif (shiftID < 1400)
        shiftName = 'Odditizing (U/I)';
    elseif (shiftID < 1500)
        shiftName = 'Cranial Equilibrium (U/I)';
    elseif (shiftID < 1600)
        shiftName = 'Arm Matching (U/I)';
    elseif (shiftID < 1700)
        shiftName = 'Arm Prioritization (S/I)';
    elseif (shiftID < 1800)
        shiftName = 'Part Calculation (S/I)';
    elseif (shiftID < 1900)
        shiftName = 'Head Removal (S/I)';
    elseif (shiftID < 2000)
        shiftName = 'Chromatic Manipulation (S/I)';
    elseif (shiftID < 2100)
        shiftName = 'Part ID Gleaning (U/S)';
    elseif (shiftID < 2200)
        shiftName = 'Eye Scrobbling (U/S)'; 
    elseif (shiftID < 2300)
        shiftName = 'Optical Positioning (U/S)';
    elseif (shiftID < 2400)
        shiftName = 'Achievement Hunting (U/S)'; 
    elseif (shiftID < 2500)
        shiftName = 'Eye Symmetrizing (U)'; 
    elseif (shiftID < 2600)
        shiftName = 'Hand Exemption (U)'; 
    elseif (shiftID < 2700)
        shiftName = 'Braincase Downsizing (I)';
    elseif (shiftID < 2800)
        shiftName = 'Eye Intermediation (I)'; 
    elseif (shiftID < 2900)
        shiftName = 'Sensor Peripheralizing (S)'; 
    elseif (shiftID < 3000)
        shiftName = 'Head Heuristics (S)'; 
    elseif (shiftID < 3100)
        shiftName = 'Digit Arrangment (U/I)';
    elseif (shiftID < 3200)
        shiftName = 'PIN Defraudment (U/I)'; 
    elseif (shiftID < 3300)
        shiftName = 'Ocular Orientation (S/I)'; 
    elseif (shiftID < 3400)
        shiftName = 'Limb Chromatizing (U/S)'; 
    elseif (shiftID < 3500)
        shiftName = 'Serial Verification (U/S)';
    elseif (shiftID < 3600)
        shiftName = 'Uniqueness Justification (U/S)'; 
    elseif (shiftID < 3700)
        shiftName = '4b T:1a - rm Prrtzng'; 
    elseif (shiftID < 3800)
        shiftName = '4b T:1c - AAAAAAAA'; 
    elseif (shiftID < 3900)
        shiftName = '4b T:1b - O_gan Failure?';
    elseif (shiftID < 4000)
        shiftName = '4b T:2a - Meat-Bag Edition'; 
    elseif (shiftID < 4100)
        shiftName = 'Simple Allocating'; 
    elseif (shiftID < 4200)
        shiftName = 'Basic Organizing'; 
    elseif (shiftID < 4300)
        shiftName = 'Mid-level Syngergizing';
    elseif (shiftID < 4400)
        shiftName = 'Advanced Allocating'; 
    elseif (shiftID < 4500)
        shiftName = 'Mega Clumpifying'; 
    elseif (shiftID < 4600)
        shiftName = 'Intense Glombing';
    elseif (shiftID < 4700)
        shiftName = 'Basic Fitting (U)'; 
    elseif (shiftID < 4800)
        shiftName = 'Symbolic Matching (U)'; 
    elseif (shiftID < 4900)
        shiftName = 'Green Synergizing 2 (I)'; 
    elseif (shiftID < 5000)
        shiftName = 'Fault Limitations (I)';
    elseif (shiftID < 5100)
        shiftName = 'Gamifying Medicine (I)'; 
    elseif (shiftID < 5200)
        shiftName = 'Colorizing Careers (I)'; 
    elseif (shiftID < 5300)
        shiftName = 'Head Hueing (S)'; 
    elseif (shiftID < 5400)
        shiftName = 'Fracture Mitigation (S)';
    elseif (shiftID < 5500)
        shiftName = 'Chestial Numbering (S)'; 
    elseif (shiftID < 5600)
        shiftName = 'Designation Tinting (S)'; 
    elseif (shiftID < 5700)
        shiftName = 'Chest Digitizing (U/I)'; 
    elseif (shiftID < 5800)
        shiftName = 'Limb Reparations (U/I)';
    elseif (shiftID < 5900)
        shiftName = 'Brain Deficiencies (U/I)'; 
    elseif (shiftID < 6000)
        shiftName = 'Iconography (S/I)'; 
    elseif (shiftID < 6100)
        shiftName = 'Failure Drilling (S/I)'; 
    elseif (shiftID < 6200)
        shiftName = 'Dangerous Gaming (S/I)';
    elseif (shiftID < 6300)
        shiftName = 'Battlefield Medicine (S/I)'; 
    elseif (shiftID < 6400)
        shiftName = 'Cross Checking (U/S)'; 
    elseif (shiftID < 6500)
        shiftName = 'Naturalized Decommissioning (U/S)';
    elseif (shiftID < 6600)
        shiftName = 'Advanced Categorization (U/S)';
    elseif (shiftID < 6700)
        shiftName = 'Compliance Distributing'; 
    elseif (shiftID < 6800)
        shiftName = 'Logistical Analyzing'; 
    elseif (shiftID < 6900)
        shiftName = 'Product Paradigming';
    elseif (shiftID < 7000)
        shiftName = 'Orchestrating Compliance'; 
    elseif (shiftID < 7100)
        shiftName = 'Assemblage Fabrication'; 
    elseif (shiftID < 7200)
        shiftName = 'Maximum Fingling';
    elseif (shiftID < 7300)
        shiftName = 'Organism Culling (U)'; 
    elseif (shiftID < 7400)
        shiftName = 'Count Quantizing (U)'; 
    elseif (shiftID < 7500)
        shiftName = 'Memory Management(U)'; 
    elseif (shiftID < 7600)
        shiftName = 'Snake Identification (I)';
    elseif (shiftID < 7700)
        shiftName = 'Transportationization (I)'; 
    elseif (shiftID < 7800)
        shiftName = 'Emotional Imprinting (I)'; 
    elseif (shiftID < 7900)
        shiftName = 'Map Orgling (I)'; 
    elseif (shiftID < 8000)
        shiftName = 'Genderization (S)';
    elseif (shiftID < 8100)
        shiftName = 'Lesson Planning (S)'; 
    elseif (shiftID < 8200)
        shiftName = 'Job Differentiation (S)'; 
    elseif (shiftID < 8300)
        shiftName = 'Face Numbering (U/I)'; 
    elseif (shiftID < 8400)
        shiftName = 'Terrestrial Tiering (U/I)';
    elseif (shiftID < 8500)
        shiftName = 'Aeronautical Categorization (S/I)'; 
    elseif (shiftID < 8600)
        shiftName = 'Craftsmans Critiquing (S/I)'; 
    elseif (shiftID < 8700)
        shiftName = 'Avoidance Training (S/I)';
    elseif (shiftID < 8800)
        shiftName = 'Aviation Aspectizing (U/S)'; 
    elseif (shiftID < 8900)
        shiftName = 'Intent Estimation (U/S)'; 
    elseif (shiftID < 9000)
        shiftName = 'Verbal Repetition (U)'; 
    elseif (shiftID < 9100)
        shiftName = 'Primetizing (U)';
    elseif (shiftID < 9200)
        shiftName = 'ATC Prioritizing (I)'; 
    elseif (shiftID < 9300)
        shiftName = 'Serpentinian Exclusion (I)'; 
    elseif (shiftID < 9400)
        shiftName = 'Emotionalizing Literature (S)';
    elseif (shiftID < 9500)
        shiftName = 'Avionic Sequentializing (S)'; 
    elseif (shiftID < 9600)
        shiftName = 'PI Memorization (U/I)'; 
    elseif (shiftID < 9700)
        shiftName = 'Cartography Catharsis (S/I)';
    elseif (shiftID < 9800)
        shiftName = 'Genus Logistics (U/S)'; 
    elseif (shiftID < 9900)
        shiftName = 'Culinary Itemization (U/S)'; 
    elseif (shiftID < 10000)
        shiftName = 'Arithmetic Training (U/S)';
    elseif (shiftID < 10100)
        shiftName = 'Word/Number Partitioning (U/S)'; 
    elseif (shiftID < 10200)
        shiftName = '4b T:3a - Specializations'; 
    elseif (shiftID < 10300)
        shiftName = '4b T:3c - Penultimations';
    elseif (shiftID < 10400)
        shiftName = '4b T:2b - For exceptional testers'; 
    elseif (shiftID < 10500)
        shiftName = '4b T:2c - Extended training'; 
    elseif (shiftID < 10600)
        shiftName = 'Sort Grouping'; 
    elseif (shiftID < 10700)
        shiftName = 'Input Processing';
    elseif (shiftID < 10800)
        shiftName = 'Defraggling';
    elseif (shiftID < 10900)
        shiftName = 'Localized Vision (U)'; 
    elseif (shiftID < 11000)
        shiftName = 'Spatial Troning (U)'; 
    elseif (shiftID < 11100)
        shiftName = 'Flipper Exception (I)'; 
    elseif (shiftID < 11200)
        shiftName = 'Complex Biodigitizing (I)';
    elseif (shiftID < 11300)
        shiftName = 'Area Allocation (S)'; 
    elseif (shiftID < 11400)
        shiftName = 'Conveyance Arithmetic (S)'; 
    elseif (shiftID < 11500)
        shiftName = 'Language Crunching (U/I)'; 
    elseif (shiftID < 11600)
        shiftName = 'Generational Gapping  (S/I)';
    elseif (shiftID < 11700)
        shiftName = 'Organizational Balancing (U/S)'; 
    elseif (shiftID < 11800)
        shiftName = 'Organism Grading (U/S)'; 
    elseif (shiftID < 11900)
        shiftName = 'Recognition Profiling (U/S)';
    elseif (shiftID < 12000)
        shiftName = 'Adv. Arithmetic Training (U/S)'; 
    elseif (shiftID < 12100)
        shiftName = '4b T:3b - Extreme Categorizing'; 
    elseif (shiftID < 12200)
        shiftName = 'Refractilating Reticulations';
    elseif (shiftID < 12300)
        shiftName = 'Classification Sensing'; 
    elseif (shiftID < 12400)
        shiftName = 'Complex Codifying';
    elseif (shiftID < 12500)
        shiftName = '4a Update Switch V1 (U/S)'; 
    elseif (shiftID < 12600)
        shiftName = '4a Update Switch V1 - 2 (U/S)'; 
    elseif (shiftID < 12700)
        shiftName = 'Biological Itemizing (U/S)';
    elseif (shiftID < 12800)
        shiftName = 'Reptile Plotting (U/S)'; 
    elseif (shiftID < 12900)
        shiftName = 'Algorithmic Comprehension (S/I)'; 
    elseif (shiftID < 13000)
        shiftName = 'Typographic Trigonometry (U/I)';
    elseif (shiftID < 13100)
        shiftName = 'Theoretical Aerodynamics (U/I)'; 
    elseif (shiftID < 13200)
        shiftName = 'Mammalian Maneuvering (U/I)'; 
    elseif (shiftID < 13300)
        shiftName = '4a Update Switch V2 (U/S)';
    elseif (shiftID < 13400)
        shiftName = '4a Update Switch V2 - 2 (U/S)'; 
    elseif (shiftID < 13500)
        shiftName = 'Dimensional Jargonization (U/S)'; 
    elseif (shiftID < 13600)
        shiftName = 'Proportional Sympathizing (U/S)';
    elseif (shiftID < 13700)
        shiftName = 'Computational Vocalizations (S/I)'; 
    elseif (shiftID < 13800)
        shiftName = 'Tetromino Groking (U/I)';
    else
        error('getShiftIDfromShiftName: unexpected shift name: %s\n', shiftName);
    end
    
    nVal = mod(shiftID, 100);
    if (nVal > 10)
        warning('getShiftNamefromShiftID: nVal is unusual (%d); make sure this ID (%d) is right!\n', nVal, shiftID);
    end
end

