function ix = misha_findstrcell(zcell, word)
% ix = findstrcell(zcell, word)  Returns pointers to cells that contain 
% the input string
% zcell is array of cells containing strings
% word is a string to be found in zcell
% M. Pavel
ix = [];
for i=1:length(zcell)
    if (strcmp(zcell{i},word))
        ix = [ix i];
    end
end