function [x_inter,y1_inter,y2_inter] = interseccao(rho)
x_inter=(rho)^2; %x da intersecao da circunferencia
y1_inter= sqrt((-x_inter^2)+(rho^2)); %y1 da intersecao da circunferencia (x+y1)
y2_inter= -1*(sqrt((-x_inter^2)+(rho^2))); %y2 da intersecao da circunferencia(x+y2 ou x-y1)
end