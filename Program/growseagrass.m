 function [seagrass] = growseagrass(icrest,tempgrid,t,j)
% Grows seagrass in specified bay cells

% Loops through each cell in estuary, finds depth, grows seagrass
% using lookup table, and returns seagrass array with each bay cell 
% containing a shoot density

% Ian Reeves 
% Version of 27-March-2017

global bay;
global L;
global SL;
global celldim;
global zcentroids;
global PriorSeagrass;
global lookup;
global growyear;


seagrass = zeros(1,L); % Initialize array to indicate which cells along x-axis have seagrass or bare sed bed
SG = getseagrass(t,j); % SG of 1 will grow seagrass, SG of 0 will not grow seagrass under any condition

if t == 1
    PriorSeagrass = seagrass;
end

yrcol = growyear*2; % Column in table associated with selected grow year


rbay = bay(1); % Right (island) edge of bay
lbay = bay(length(bay)); % Left (mainland) edge of bay

PBC = getPBC(t,j); % Percent Bay Cover

% Define spatial limits of seagrass habitat according to PBC
islandlimit = rbay + round(length(bay)*((1-PBC)/2));
mainlandlimit = lbay - round(length(bay)*((1-PBC)/2));

if SG == 1
    if (length(bay)) > 3 % If bay becomes too small (3 cells or less), don't grow any seagrass
        for ii = icrest:L % Loop through each cell in bay

            % Find depth of the cell
            realratio = sum(tempgrid(ii,:,:),3); % The amount of sediment in a cell
            topcell = max(find(realratio == 0));
            topcell = topcell + 1; % The first cell with sediment
            k = topcell;
            realratio = sum(tempgrid(ii,k,:),3); % The amount of sediment in the topcell
            H =(zcentroids(k) - celldim(3,j) ./ 2) + realratio*celldim(3,j);
            depth = SL(t,j)-H; %(m) Calculate depth

            % Grow seagrass if bay cell is in depth and spatial range for seagrass growth
            dindex = 0:0.05:10;
            d = round(depth/0.05)*0.05; % Round depth to nearest 0.05

            if ii <= mainlandlimit && ii >= islandlimit % Constrain location within bay of where seagrass can potentially grow 
                if PriorSeagrass(ii) > 0 % If cell contained seagrass in prior time step
                    if d > 4 || d == 0
                        shootdensity = 0;
                    else
                        shootdensity = lookup(find(dindex==d),yrcol); % Use lookup table to find density at specific depth for prior seagrass
                    end

                    if shootdensity ~= 0
                        seagrass(ii) = shootdensity; 
                    end  
                else % If cell did not contain seagrass in prior time step
                    if d > 4 || d == 0
                        shootdensity = 0;
                    else
                        shootdensity = lookup(find(dindex==d),(yrcol+1)); % Use lookup table to find density at specific depth for prior bare bed
                    end

                    if shootdensity ~= 0
                        seagrass(ii) = shootdensity;
                    end
                end
            end  
        end
    end
else
    seagrass(:) = 0;% Don't grow seagrass
end


PriorSeagrass = seagrass;

end

