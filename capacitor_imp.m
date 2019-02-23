function [C] = capacitor_imp(z0,freq,xc)
w=2*pi*freq;
denominador=w*(-1*xc)*z0;
C=1/denominador; % -j/z0*w*c
end