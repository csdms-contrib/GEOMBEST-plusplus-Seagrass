function [dunevol,tempgrid,ii] = backbarrierinfill (tempgrid,t,j,icrest,shorewidth)

% Backbarrierinfill --
% 1) Infills the backbarrier via overwash, riverine input, and marsh accretion
% 2) Updates tempgrid

% Dr David Stolper dstolper@usgs.gov

% Version of 02-Jan-2003 10:47
% Updated    08-Apr-2003 4:47
% Updated DW 22-Jun-2012
% Updated RL 13-Nov-2014
% Updated IR 29-Jan-2017

global TP;
global SL;
global stormcount;

% Build the back-half of the dune up to the equilibrium morphology
[dunevol,tempgrid] = dunebuild (tempgrid,icrest,t,j,shorewidth);
    
% Update the bay surface and calculate volume of sediment eroded
[tempgrid,marshvol,icrest,targetDepth] = bayevolution(icrest,tempgrid,t,j,TP);

% Erode the marsh edge due to wind waves, and add % of that sediment to sed available from bay erosion
[tempgrid,redepvol,maxDeq,icrest] = erodemarsh (icrest,tempgrid,t,j,t,TP,targetDepth);

% Grow the marsh at the left and right boundaries of the bay
[tempgrid] = growmarsh (tempgrid,marshvol,t,j,t,redepvol,maxDeq,icrest);

stormcount = zeros(1,5);

[tempgrid,ii] = overwash(tempgrid,j,t);


end
