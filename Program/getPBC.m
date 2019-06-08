function [PBC] = getPBC(t,j)

% getshearcrit -- reads runfiles and returns the percent bay cover entry appropriate for the timestep (t). 
% This function is necessary beacuse runfiles considers only 
% whole steps while t is comprised of wholesteps(entered by the user)
% and a number of substeps specified by the user 

% IR - Mar-2017



global T;
global runfiles;

substeps = T ./ size(runfiles(j).PBC,2);

for a = 1:T ./ substeps    
    if t <= a .* substeps
        PBC = runfiles(j).PBC(a);
        break;
    end    
end