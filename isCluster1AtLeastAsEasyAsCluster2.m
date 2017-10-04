% Zephy McKanna
% isCluster1EasierThanCluster2()
% 4/23/16
% 
% This is a utility function intended for making Partial Orderings easier
% to create between clusters. 
% 
% It returns 1 if Cluster1 is logically at least as easy as Cluster2 (e.g.,
% 'U' is logically easier than 'U/S' or 'U/Logic'). 
% Otherwise it returns 0.
%
function [logicalValue] = isCluster1AtLeastAsEasyAsCluster2(Cluster1, Cluster2)
    logicalValue = 0; % assume C1 is not easier than C2
    if (strcmpi(Cluster1, 'U'))
        if (strcmpi(Cluster2, 'U/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/Logic(xOR)')) % z - why does this still exist???
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/S'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/I'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/S/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'S'))
        if (strcmpi(Cluster2, 'S/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/S'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'S/I'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/S/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'S/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'I'))
        if (strcmpi(Cluster2, 'I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/I'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'S/I'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'S/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'U/Logic'))
        if (strcmpi(Cluster2, 'U/S/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'U/Logic(xOR)')) % why does this still exist?
        if (strcmpi(Cluster2, 'U/S/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'U/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'S/Logic'))
        if (strcmpi(Cluster2, 'U/S/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'S/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'I/Logic'))
        if (strcmpi(Cluster2, 'U/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'S/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'U/S'))
        if (strcmpi(Cluster2, 'U/S/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'U/I'))
        if (strcmpi(Cluster2, 'U/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'S/I'))
        if (strcmpi(Cluster2, 'S/I/Logic'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'U/S/Logic'))
        if (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'U/I/Logic'))
        if (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    elseif (strcmpi(Cluster1, 'S/I/Logic'))
        if (strcmpi(Cluster2, 'L4aV1'))
            logicalValue = 1;
        elseif (strcmpi(Cluster2, 'L4aV2'))
            logicalValue = 1;
        end
    end
        
end