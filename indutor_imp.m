function [L] = indutor_imp(z0, freq, xl)
w=2*pi*freq;
L= (xl*z0)/w; % jwL/z0
end