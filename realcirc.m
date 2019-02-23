function [h] = realcirc(r)

phi=1:1:360;
theta=phi*pi/180;
a=1/(1+r);
m=r/(r+1);
n=0;
Re=a*cos(theta)+m;
Im=a*sin(tehta)+n;
z=Re+j*Im;
h=plot(z,'k');
axis('equal')
end