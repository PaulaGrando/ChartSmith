function [real,imag] = cartesiano_imag(x,y,angulo)
if angulo<180
imag=(2*y)/((x^2)-2*x+1+(y)^2); %x e y são cartesianos
else
imag= -1*((2*y)/((x^2)-2*x+1+(y)^2));
end

if (angulo>0 && angulo<90) || (angulo>270 && angulo<360)
real=((y^2+x^2-4*x+4)^0.5-1)/(y^2+x^2-4*x+3);
else
real=-1*((y^2+x^2-4*x+4)^0.5-1)/(y^2+x^2-4*x+3);    
end
