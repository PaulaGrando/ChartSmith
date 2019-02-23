%%entro com impedância, me dá x e y (cartesiano) e o angulo.
function [x_1,y_1,angulo,rho] = imag_cartesiano(imp_normal)
coef_reflex=(imp_normal-1)/(imp_normal+1); %z1 impedância valor normalizado
    rho=abs(coef_reflex);
    theta=angle(coef_reflex);
    angulo=theta*(180/pi); %rad pra graus

angulo_rad=angulo*(pi/180); % graus pra rad

if (angulo>=0)
    x_1= cos(angulo_rad) * rho;
    y_1= sin(angulo_rad) * rho;
else
    angulo_positivo= angulo_rad+6.2831;
    angulo_graus=angulo+360;
    x_1= cos(angulo_positivo) * rho;
    y_1= sin(angulo_positivo) * rho;
end