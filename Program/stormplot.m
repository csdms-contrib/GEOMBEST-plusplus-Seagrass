function stormplot

% Plots the frequency distribution of different storms

plot (1:5,sum(stormsnorm),'o-r')

hold on

plot (1:5,sum(stormsskewed),'o-b')