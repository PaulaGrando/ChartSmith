function [yl_1,yl_2] = admitancia(angulo,rho)

angulo_rad=angulo*(pi/180);
if (angulo>0)

        yl_1= -(cos(angulo_rad) * rho);
        yl_2= -(sin(angulo_rad) * rho);

else
    angulo_positivo= angulo_rad+6.2831;
    angulo_graus=angulo+360;
    
        yl_1= -(cos(angulo_positivo) * rho);
        yl_2= -(sin(angulo_positivo) * rho);
end 

end