function [q_ow,overwashlength,overwashthickness,stormcount] = stormgen(ts,q_ow,stormcount,t,j)

% StormGen stochastically generates storm deposits for a given time step
% (ts), as a function of the storm climate, which is defined by the
% parameters for storm intensity (OWi) and frequency (OWf). It is a
% probability-based function, that will calculate the likelihood of a storm
% of a certain size occurring over the period for the time step, based on
% the parameters. Then the function "rolls the dice" to determine if the 
% storm happens or not.

% created by David Walters 2/14/2013


OWi = getoverwashrate(t,j);
OWf = getbbwidth(t,j);
artificialdunes = q_ow; % Denotes if dunes are natural (0) or maintained artificially

% The initial probability (storms/year) of each level of storm, with
% increasing intensity

if artificialdunes == 0
    stormprob = [0.01 0.1 0.5 0.1 0.01];
elseif artificialdunes == 1
    stormprob = [0 0 0 0.1 0.01];
end

% Calculate the change in probability for storm intensity regime
intensitycoefficient = ones(1,5);

if OWi == 1
    intensitycoefficient = [1.2 1.1 1 0.9 0.8]; % Scenario 1 increases low intensity storms with a proportional decrease in high intensity storms
elseif OWi == 3
    intensitycoefficient = [0.8 0.9 1 1.1 1.2]; % Scenario 3 increases high intensity storms with a proportional decrease in low intensity storms
end

% Adjust the probabilies according to the storm intensity scenario
stormprob = stormprob .* intensitycoefficient;

% Calculate the change in probability due to storm frequency
stormprob = stormprob*OWf;


% Roll the dice for every year of the time step
for t = 1:ts
    for n = 1:5
        if rand > 1 - stormprob(n)
            stormcount(n) = stormcount(n)+1;
        end
    end
    t = t + 1;
end

% stormcount

% Deposit the sand from the storms into the backbarrier

stormdeposit = [0.05 0.5 2.5 10 50]; %Average volume of deposit for each level of storm (m^3/m)

q_ow = 0; % Initiate total overwash volume

maxstorm = 1;
% Sum the volume of overwash from all storms
for n = 1:5
    if stormcount(n) > 0 
        q_ow = q_ow + stormcount(n) * stormdeposit(n);
        maxstorm = n; % The most intense storm of the time step
    end
end


% Calculate the average width of overwash for a storm of a given intensity
% by taking the square root of the product of the volume deposited by a 
% single storm and the aspect ratio between deposit extent and thickness
overwashlength = sqrt(stormdeposit(maxstorm) .* 7500)*2;


% In simplest case, imagining overwash deposit as a rectangle, thickness of
% total deposits will be determined by total overwash volume divided by the
% overwash length of the most intense storm in the time step
overwashthickness = q_ow / overwashlength;
