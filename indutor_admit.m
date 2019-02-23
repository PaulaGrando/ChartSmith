function [L] = indutor_admit(z0, freq, xl)
w=2*pi*freq;
denominador= w*(-1*xl);
L=z0/denominador; % -jz0/wL
end