function [sweptvolume,tempgrid] = Sweepshoreface (tempgrid,icrest,t,j);

% Sweepshoreface -- Scans the shoreface section of tempgrid to find cells
% that are below the surface and only partially filled with sediment. Cells
% with this condition are formed when overwash deposition only partially
% fills the most landwards cell of the barrier. These cells are then 
% completely filled with sand, tempgrid is updated and the resulting volume 
% returned by the function   

% Dr David Stolper dstolper@usgs.gov

% Version of 17-Jun-2003 10:29
% Updated    30-Jun-2003 13:03

global celldim;
global L;
global N;
global equil;
global surface;
global zcentroids;

for i = 1:icrest
    for k = 1:N
        cellfill = sum(tempgrid(i,k,:));
        if cellfill ~= 0
            surfcells(i) = k;
            break
        end
    end
end

sweptvolume = 0; % volume required to fill partially infilled cells on the shoreface

for i = 1:icrest    
    
    for k = surfcells(i) + 1:N
        cellratio = sum(tempgrid(i,k,:));        
        if cellratio < 0.99999                                 
            tempgrid(i,k,1) = tempgrid(i,k,1) + (1 - cellratio);
            sweptvolume = sweptvolume + ((1 - cellratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j));                
            flag = 0;
        else
            break
        end        
        
    if isnan(tempgrid(i,k,1))
        block = 0; % testing section
    end   
        
    end    
end