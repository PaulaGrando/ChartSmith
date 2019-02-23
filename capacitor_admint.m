function [C] = capacitor_admint(z0,freq,xc)
w=2*pi*freq;
denominador=w*z0;
C=xc/denominador;
end