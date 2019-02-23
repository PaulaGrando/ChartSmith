function [x_inter,y_inter] = interseccao_L(r) %x cartesiado

x_inter=(1-r^2)/(-3*(r)^2-4*r-1);   
y_inter=sqrt(-(x_inter)^2 - x_inter);
end