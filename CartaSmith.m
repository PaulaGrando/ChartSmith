clc;
clear;

%CÃ?RCULO REAL = 0 (Base da Carta)
theta=linspace(-pi,pi,180); %angulo(Graus) -> gera 180 numeros de -pi a pi
a=1; %Raio do circulo
m=0; %centro do circulo
n=0; %Centro do circulo
Re=a*cos(theta) + m; %Parte Real
Im=a*sin(theta) + n; %Parte Imaginaria
z=Re+j*Im; %Numero complexo
plot(z,'k'); 
axis('equal');
%axis('off') % Tira o fundo branco
hold on

plot([-1 1],[0 0], 'k'); % Adiciona o eixo x

%CIRCULOS REFERENTES Ã€ PARTE REAL(m=1/r+1 n=1) 
rvalues=[0.1:0.2:4]; % Tem que ser um vetor "infinito"
avalues= [0.1:0.2:4];% Tem que ser um vetor "infinito"
k= [1:360];
phi=1:1:360;
theta=(phi*pi/180);

for r=rvalues
    m(k)=r./(1+r);
    n=0;
    a(k)=1./(1+r);
    Re(k)=a(k).*cos(theta) + m;
    Im(k)=a(k).*sin(theta) + n;
    z(k)=Re(k)+j.*Im(k);
    plot(z(k),'k');
    hold on
    xpos=z2gamma(r);
    num=num2str(r);
    h=text(xpos, 0, num);
    set (h,'VerticalAlignment','top','HorizontalAlignment','right');
end
                        
%CIRCULOS REFERENTES A PARTE IMAGINARIA(m=1 n=1/r+1)
xvalues=[0.1:0.2:4]; % Tem que ser um vetor "infinito"
for x=xvalues
    imcirc(x);
    imcirc(-x);
    xpos=real(z2gamma(i*x));
    ypos=imag(z2gamma(i*x));
    h=text([xpos xpos], [ypos -ypos],[num2str(x); num2str(x);]);
     set(h(1),'VerticalAlignment', 'bottom');
     set(h(2),'VerticalAlignment', 'top');
      if xpos==0
          set(h, 'HorizontalAlignment', 'center');
      elseif xpos<0
          set (h, 'HorizontalAlignment', 'right');
      end  
end


 
