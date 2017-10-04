% Zephy McKanna
% getShiftsNotSeenIn1A3()
% 5/25/15
% 
% This function takes a table of trials with a "Shift" column, which may or
% may not contain any of the following shifts (none of them seen in 1A-3).
% It then returns only those shifts. 
% Since some of these shifts are seen in 1B, this is meant as one test for
% 1B data (as opposed to 1A-3).
%
% Shifts not seen in 1A-3:
% Memory Management(U)
% Snake Identification (I)
% Stereoizing (I)
% Emotional Imprinting (I)
% Map Orgling (I)
% Job Differentiation (S)
% 4b T:3c - Penultimations
% 4b T:3b - Extreme Categorizing
%
% Serpentinian Exclusion (I)          &
% 4a Update Switch V1 (U/S)           +
% 4a Update Switch V1 - 2 (U/S)       +
% 4a Update Switch V2 (U/S)           +
% 4a Update Switch V2 - 2 (U/S)       +
%
% Transportationization (I)           *
% Gamifying Medicine (I)              *
% Colorizing Careers (I)              *
% Limb Management (I)                 *
% Terrestrial Tiering (U/I)           *
% Avoidance Training (S/I)            *
% Advanced Categorization (U/S)       *
% Spatial Troning (U)                 *
% Complex Biodigitizing (I)           *
% Conveyance Arithmetic (S)           *
% PIN Defraudment (U/I)               *
% Generational Gapping  (S/I)         *
% Recognition Profiling (U/S)         *
% Adv. Arithmetic Training (U/S)      *
% Mammalian Maneuvering (U/I)         *
% Word/Number Partitioning (U/S)      *
% 
% & = this shift was only seen by participant 1306 in 1A-3 (this
% participant should probably be excluded), but was seen by a few
% participants in 1B as well
% + = this shift was only seen by participant 1306 in 1A-3 (this
% participant should probably be excluded)
% * = this shift was not seen in either 1A-3 or 1B
%
function [only1306, non1A3shifts] = getShiftsNotSeenIn1A3(allShifts)
    only1306 = allShifts(strcmpi(allShifts.Shift, 'Serpentinian Exclusion (I)'), :);
    only1306 = [only1306; allShifts(strcmpi(allShifts.Shift, '4a Update Switch V1 (U/S)'), :)];
    only1306 = [only1306; allShifts(strcmpi(allShifts.Shift, '4a Update Switch V1 - 2 (U/S)'), :)];
    only1306 = [only1306; allShifts(strcmpi(allShifts.Shift, '4a Update Switch V2 (U/S)'), :)];
    only1306 = [only1306; allShifts(strcmpi(allShifts.Shift, '4a Update Switch V2 - 2 (U/S)'), :)];

    non1A3shifts = allShifts(strcmpi(allShifts.Shift, 'Memory Management(U)'), :);
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Snake Identification (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Stereoizing (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Emotional Imprinting (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Map Orgling (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Job Differentiation (S)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, '4b T:3c - Penultimations'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, '4b T:3b - Extreme Categorizing'), :)];
    
    % z: maybe give an indication if we see one of these? non-1b either...
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Transportationization (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Gamifying Medicine (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Colorizing Careers (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Limb Management (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Terrestrial Tiering (U/I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Avoidance Training (S/I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Advanced Categorization (U/S)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Spatial Troning (U)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Complex Biodigitizing (I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Conveyance Arithmetic (S)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'PIN Defraudment (U/I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Generational Gapping  (S/I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Recognition Profiling (U/S)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Adv. Arithmetic Training (U/S)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Mammalian Maneuvering (U/I)'), :)];
    non1A3shifts = [non1A3shifts; allShifts(strcmpi(allShifts.Shift, 'Word/Number Partitioning (U/S)'), :)];

    non1A3shifts(non1A3shifts.Subject == 1306, :) = []; % remove 1306 shifts from non1A3shifts, to avoid duplication
end

