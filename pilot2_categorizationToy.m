% Zephy McKanna
% pilot2_categorizationToy()
% 6/22/16
% 
% This is a toy function intended to give Presentation coders an idea of
% how we expect to end the Categorization task for Pilot 2.
%
% It expects a StimulusList, a table with two columns:
% Stimulus = a filename string, indicating the stimulus screenshot
% Category = a binary indicating that this Stimulus is in category 0 or 1
%       NOTE: we assume that the "correct" and "incorrect" filenames are
%       based on the stimulus filename, e.g. with "_correct" appended
%
% It returns the internal data table, just so you can see what the random
% play generated in terms of responses.
% It also returns the number of trials it took for the random play to
% categorize this.
%
function [internalDataTable, totalTrials] = pilot2_categorizationToy(stimulusList)
    % first, load the stimulus list into some internal structure
    internalDataTable = table({'placeholder'},0,0,0,0,'VariableNames',{'FileName', 'Category', 'SeenCount', 'NumCorrect','SelectThisNext'});
    for i = 1:height(stimulusList)
        insertThis = table(stimulusList.Stimulus(i),stimulusList.Category(i),0,0,1,'VariableNames',{'FileName', 'Category', 'SeenCount', 'NumCorrect','SelectThisNext'});
        internalDataTable(i,:) = insertThis;
    end
    
    
    REMEMBER: HAVE TO KNOW WHERE YOU ARE FROM DAY TO DAY
    
    
    % now run the experiment
    experimentFinished = false;
    totalTrials = 0; % just to simulate a timer
    while (experimentFinished == false)
        % pick the next stimulus (note: there are much more efficient ways to do all of this, just trying to make the goal clear) 
        nextStim = 0;
        while (nextStim == 0)
            tryThisOne = ceil(rand() * 16); % pick a number from 1-16
            if (internalDataTable.SelectThisNext(tryThisOne) == 1) % this is in the list of stimuli appropriate for displaying next
                nextStim = tryThisOne; % so select it
            end
        end
        
        % now display the stimulus and let the player pick its category
            % NOTE: just simulated as a random play for now, for speed
        playerResponse = floor(rand() * 2); % random 0 or 1
        if (playerResponse == internalDataTable.Category(nextStim))
            playerCorrect = 1;
        else
            playerCorrect = 0;
        end
        
        % update the internal data table due to correct or incorrect
        if (playerCorrect == 1)
            internalDataTable.NumCorrect(nextStim) = internalDataTable.NumCorrect(nextStim) + 1; % inc the number of times they got this right in a row
        else
            internalDataTable.NumCorrect(nextStim) = 0; % reset the number of times they got this right in a row
        end
        internalDataTable.SeenCount(nextStim) = internalDataTable.SeenCount(nextStim) + 1; % regardless, they saw it
            
        % now update the list of appropriate stims to choose as the next one presented
        tempDataTable = internalDataTable;
        tempDataTable(tempDataTable.NumCorrect >= 2, :) = []; % ignore anything that they've already gotten right twice in a row
        if (isempty(tempDataTable) == 1) % there's nothing left to pick; everything has been gotten right twice in a row
            experimentFinished = true;
        else % we still have some stimuli from which to choose
            for i = 1:height(internalDataTable)
                if (ismember(internalDataTable.FileName(i),tempDataTable.FileName) == 1) % this stim hasn't been completed yet
                    if (length(unique(tempDataTable.SeenCount)) == 1) % everything has been seen the same number of times
                        internalDataTable.SelectThisNext(i) = 1; % so everything should be able to be picked next
                    else % things have been seen different numbers of times; pick one of the less-frequently-seen ones
                        if (internalDataTable.SeenCount(i) < max(internalDataTable.SeenCount)) % this hasn't been seen as many times as some
                            internalDataTable.SelectThisNext(i) = 1; % so so it could be picked next
                        else % it has been seen more times than anything else
                            internalDataTable.SelectThisNext(i) = 0; % so don't choose it next
                        end
                    end
                else % this stim isn't in tempDataTable, so the player must have gotten it correct twice in a row already
                    internalDataTable.SelectThisNext(i) = 0; % don't select it ever again
                end
            end
        end
        
        % just to avoid any potential infinite loops, check to see if we're done again
        if (length(unique(internalDataTable.SelectThisNext)) == 1) % there's only one number in SelectThisNext
            if (internalDataTable.SelectThisNext(1) == 0) % and it's zero
                experimentFinished = true; % so we're done
            end
        end
        
        % just to simulate a timer (I'd use actual time rather than trials in Presentation)
        totalTrials = totalTrials + 1; % simulate a timer continuing to run in the background        
        if (totalTrials > 150) % 2s minimum trial time, 5 min total
            experimentFinished = true; % so we're done
        end
    end



end


% delMe9 = table({'Stim1';'Stim2';'Stim3';'Stim4';'Stim5';'Stim6';'Stim7'; ...
%    'Stim8';'Stim9';'Stim10';'Stim11';'Stim12';'Stim13';'Stim14';'Stim15';'Stim16'}, ...
%    [0;0;0;0;0;0;0;0;1;1;1;1;1;1;1;1],'VariableNames',{'Stimulus', 'Category'});
