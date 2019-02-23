function varargout = interface(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Diz que o botão selecionado é o 1
handles.freq=0;
handles.estado = 0;
set(handles.radiobutton1,'Value',0); %posição dos butons iniciais
set(handles.radiobutton3,'Value',0); %posição dos butons iniciais
set(handles.radiobutton2,'Value',0); %posição dos butons iniciais

axes(handles.axes1);
base_carta; %Chama projeto que desenha a carta

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles) %Z0

handles.z0= str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles) 

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles) %Stub em paralelo Curto
%diz que o botão 1 é o selecionado 
handles.estado = 1;
set(handles.radiobutton1,'Value',1); %posição dos butons iniciais
set(handles.radiobutton3,'Value',0); %posição dos butons iniciais
set(handles.radiobutton2,'Value',0); %posição dos butons iniciais

%Traca o circulo da impedancia
theta = linspace(0,2*pi);
x1 =  handles.rho*cos(theta) + 0;
y1 =  handles.rho*sin(theta) + 0;
plot(x1,y1, 'red', 'linewidth', 0.5)
axis('equal')

% Achar admitancia
[yl_1,yl_2]=admitancia(handles.angulo,handles.rho);
plot(yl_1,yl_2, 'r*', 'linewidth', 1);
text(yl_1+0.009,yl_2+0.009, '2-YL');

% Tracar o circulo 1+-jb
a_1=0.5; %Raio do circulo
m_1=0.5; %centro do circulo
n_1=0; %Centro do circulo

theta2 = linspace(0,2*pi); %Angulo(Graus) -> gera 180 numeros de -pi a pi
circ_Re=a_1*cos(theta2) + m_1;
circ_Im=a_1*sin(theta2) + n_1;
circ_z=circ_Re+j*circ_Im;
plot(circ_z, 'blue')
axis('equal') 
hold on

% Achar intersecao dos circulos
[x_inter,y1_inter,y2_inter]=interseccao(handles.rho);
plot(x_inter,y1_inter, '*b');
text(x_inter+0.009,y1_inter+0.009, '3')
plot(x_inter,y2_inter, '*b');
text(x_inter+0.009,y2_inter+0.009, '3')

p1=x_inter+y1_inter*j;
p2=x_inter+y2_inter*j;
angulo_ponto1=angle(p1);
angulo_toco_rad=mod(angulo_ponto1*(180/pi),360);

angulo_ponto2=angle(p2);
angulo_ponto2_rad=mod(angulo_ponto2*(180/pi),360);

% Escala CODG
[d1,d2] = escala_CODG(handles.angulo,angulo_toco_rad,angulo_ponto2_rad);
d1=mod(d1,0.5);
d2=mod(d2,0.5);

if d1<0
    d1=d1+0.5;
end

if d2<0
    d2=d2+0.5;
end

set(handles.uipanel4, 'Visible', 'on');
set(handles.text44, 'String', ['1. Achar a impedância normalizada', ' ZL=', num2str(handles.imp_normal),'?','(ponto 1)']);
set(handles.text45, 'String', ['2. Traçar o círculo de coef. constante']);
set(handles.text46, 'String', ['3. Achar a admitância normalizada', ' YL=', num2str(handles.adm_normal), '(ponto 2)']);
set(handles.text47, 'String', ['4. Achar a intesecção entre os círculos de coef. reflexão e 1±j (pontos 3)']);
set(handles.text48, 'String', ['5. Mensurar a distância entre YL e um dos pontos de intersecção, com base na escala CODG (distância d)']);
set(handles.text50, 'String', ['6. Localizar o ponto que anula a parte real do ponto de intersecção (ponto 4)']);
set(handles.text51, 'String', ['7. Mensurar a distância entre o ponto 4 e o ponto refenrente ao circuito aberto (tamanho do stub)']);

set(handles.uipanel3, 'Visible', 'on');
set(handles.text18, 'String', [num2str(d1)]);
set(handles.text30, 'String', [num2str(d2)]);

%% Achar Tamanho do toco
B1=-(2*y1_inter)/((x_inter^2)-2*x_inter+1+(y1_inter)^2);
B2=(2*y1_inter)/((x_inter^2)-2*x_inter+1+(y1_inter)^2);

p1_toco=B1*j; %só tem parte imaginária
[x_2, y_2, angulo_2, rho_2]=imag_cartesiano(p1_toco);
plot(x_2,y_2, 'r*', 'linewidth', 1)
text(x_2+0.02,y_2+0.009, '4');

p2_toco=B2*j; %só tem parte imaginária
[x_3, y_3, angulo_3, rho_3]=imag_cartesiano(p2_toco);
plot(x_3,y_3, 'r*', 'linewidth', 1)
text(x_3+0.02,y_3+0.009, '4');

angulo_toco_graus=mod(angulo_2+360,360);
angulo_toco_rad=angulo_toco_graus*(180/pi);

if angulo_toco_graus>=0 && angulo_toco_graus<=180 %na parte de cima do grafico
        ajuste_angulo1=180-angulo_toco_graus;
        tam_toco=(((ajuste_angulo1*0.5)/360)+0.5);
        
end % parte de baixo do grafico

if angulo_toco_graus>=180 && angulo_toco_graus<=360
    ajuste_angulo_1=360-angulo_toco_graus+180;
    tam_toco=-1*(((ajuste_angulo_1*0.5)/360)-0.5);
end

angulo_toco_graus_2=mod(angulo_3+360,360);
angulo_toco_rad_2=angulo_toco_graus*(180/pi);

if angulo_toco_graus_2>=0 && angulo_toco_graus_2<=180 %na parte de cima do grafico
        ajuste_angulo2=180-angulo_toco_graus_2;
        tam_toco2=-1*(((ajuste_angulo2*0.5)/360)-0.5);
        
end % parte de baixo do grafico

if angulo_toco_graus_2>=180 && angulo_toco_graus_2<=360
    ajuste_angulo_2=360-angulo_toco_graus_2+180;
    tam_toco2=(((ajuste_angulo_1*0.5)/360)+0.5);
end

set(handles.text20,'String', num2str(tam_toco));
set(handles.text32,'String', num2str(tam_toco2));

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles) %Stub em paralelo Aberto
%diz que o botão 2 é o selecionado 
handles.estado = 2;
set(handles.radiobutton1,'Value',0); %posição dos butons iniciais
set(handles.radiobutton2,'Value',1); %posição dos butons iniciais
set(handles.radiobutton3,'Value',0); %posição dos butons iniciais

%Traca o circulo da impedancia
theta = linspace(0,2*pi);
x1 = handles.rho*cos(theta) + 0;
y1 = handles.rho*sin(theta) + 0;
plot(x1,y1, 'red', 'linewidth', 0.5)
axis('equal')

% Achar admitancia
[yl_1,yl_2]=admitancia(handles.angulo,handles.rho);
plot(yl_1,yl_2, 'r*', 'linewidth', 1);
text(yl_1+0.009,yl_2+0.009, '2-YL');

% Tracar o circulo 1+-jb
a_1=0.5; %Raio do circulo
m_1=0.5; %centro do circulo
n_1=0; %Centro do circulo

theta2 = linspace(0,2*pi); %Angulo(Graus) -> gera 180 numeros de -pi a pi
circ_Re=a_1*cos(theta2) + m_1;
circ_Im=a_1*sin(theta2) + n_1;
circ_z=circ_Re+j*circ_Im;
plot(circ_z, 'blue')
axis('equal') 
hold on

% Achar intersecao dos circulos
[x_inter,y1_inter,y2_inter]=interseccao(handles.rho);
plot(x_inter,y1_inter, '*b');
text(x_inter+0.009,y1_inter+0.009, '3')
plot(x_inter,y2_inter, '*b');
text(x_inter+0.009,y2_inter+0.009, '3')

p1=x_inter+y1_inter*j;
p2=x_inter+y2_inter*j;
angulo_ponto1=angle(p1);
angulo_toco_rad=mod(angulo_ponto1*(180/pi),360);

angulo_ponto2=angle(p2);
angulo_ponto2_rad=mod(angulo_ponto2*(180/pi),360);

% Escala CODG
[d1,d2] = escala_CODG(handles.angulo,angulo_toco_rad,angulo_ponto2_rad)
d1=mod(d1,0.5);
d2=mod(d2,0.5);

if d1<0
    d1=d1+0.5;
end

if d2<0
    d2=d2+0.5;
end

set(handles.uipanel5, 'Visible', 'on');
set(handles.text54, 'String', ['1. Achar a impedância normalizada', ' ZL=', num2str(handles.imp_normal),'(ponto 1)']);
set(handles.text55, 'String', ['2. Traçar o círculo de coef. constante']);
set(handles.text56, 'String', ['3. Achar a admitância normalizada', ' YL=', num2str(handles.adm_normal), '(ponto 2)']);
set(handles.text57, 'String', ['4. Achar a intesecção entre os círculos de coef. reflexão e 1±j (pontos 3)']);
set(handles.text58, 'String', ['5. Mensurar a distância entre YL e um dos pontos de intersecção, com base na escala CODG (distância d)']);
set(handles.text59, 'String', ['6. Localizar o ponto que anula a parte real do ponto de intersecção (ponto 4)']);
set(handles.text60, 'String', ['7. Mensurar a distância entre o ponto 4 e o ponto refenrente ao circuito em curto (tamanho do stub)']);

set(handles.uipanel3, 'Visible', 'on');
set(handles.text18, 'String', num2str(d1));
set(handles.text30, 'String', num2str(d2));

%% Achar Tamanho do toco
B1=-(2*y1_inter)/((x_inter^2)-2*x_inter+1+(y1_inter)^2);
B2=(2*y1_inter)/((x_inter^2)-2*x_inter+1+(y1_inter)^2);

p1_toco=B1*j; %só tem parte imaginária
[x_2, y_2, angulo_2, rho_2]=imag_cartesiano(p1_toco);
plot(x_2,y_2, 'r*', 'linewidth', 1)
text(x_2+0.02,y_2+0.009, '4');

p2_toco=B2*j; %só tem parte imaginária
[x_3, y_3, angulo_3, rho_3]=imag_cartesiano(p2_toco);
plot(x_3,y_3, 'r*', 'linewidth', 1)
text(x_3+0.02,y_3+0.009, '4');

angulo_toco_graus=mod(angulo_2+360,360);
angulo_toco_rad=angulo_toco_graus*(180/pi);

if angulo_toco_graus>=0 && angulo_toco_graus<=180 %na parte de cima do grafico
        ajuste_angulo1=180-angulo_toco_graus;
        tam_toco=(ajuste_angulo1*0.5)/360;
        
end % parte de baixo do grafico

if angulo_toco_graus>=180 && angulo_toco_graus<=360
    ajuste_angulo_1=360-angulo_toco_graus+180;
    tam_toco=(ajuste_angulo_1*0.5)/360;
end

angulo_toco_graus_2=mod(angulo_3+360,360);
angulo_toco_rad_2=angulo_toco_graus*(180/pi);

if angulo_toco_graus_2>=0 && angulo_toco_graus_2<=180 %na parte de cima do grafico
        ajuste_angulo2=180-angulo_toco_graus_2;
        tam_toco2=(ajuste_angulo2*0.5)/360;
        
end % parte de baixo do grafico

if angulo_toco_graus_2>=180 && angulo_toco_graus_2<=360
    ajuste_angulo_2=360-angulo_toco_graus_2+180;
    tam_toco2=(ajuste_angulo_1*0.5)/360;
end

set(handles.text20,'String', num2str(tam_toco));
set(handles.text32,'String', num2str(tam_toco2));


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles) %Elemento Concentrado L
%diz que o botão 3 é o selecionado 
handles.estado = 3;
set(handles.radiobutton1,'Value',0); %posição dos butons iniciais
set(handles.radiobutton2,'Value',0); %posição dos butons iniciais
set(handles.radiobutton3,'Value',1); %posição dos butons iniciais

% Tracar o circulo 1+-jb
a_1=0.5; %Raio do circulo
m_1=0.5; %centro do circulo
n_1=0; %Centro do circulo

theta3 = linspace(0,2*pi); %Angulo(Graus) -> gera 180 numeros de -pi a pi
circ_Re=a_1*cos(theta3) + m_1;
circ_Im=a_1*sin(theta3) + n_1;
circ_z=circ_Re+j*circ_Im;
plot(circ_z, 'blue')
axis('equal') 
hold on
      
% Traçar o circulo girado 1+-jb
a_1=0.5; %Raio do circulo
m_1=-0.5; %centro do circulo
n_1=0; %Centro do circulo

theta4 = linspace(0,2*pi); %Angulo(Graus) -> gera 180 numeros de -pi a pi
circ_Re=a_1*cos(theta4) + m_1;
circ_Im=a_1*sin(theta4) + n_1;
circ_z=circ_Re+j*circ_Im;
plot(circ_z, 'blue');
axis('equal'); 
hold on        

if (real(handles.imp_normal)>=1)%ver a parte real é maior 1, se for tá no circulo 1+-j
% Achar admitancia
[xl_2,yl_2]=admitancia(handles.angulo,handles.rho);
plot(xl_2,yl_2, 'r*', 'linewidth', 1);
text(xl_2+0.009,yl_2+0.009, '2-YL');

%plotar admitância no circulo girado
[x_inter,y_inter]=interseccao_L(real(1/handles.imp_normal)); %achar parte real;

%Calcular a menor distância menor_distancia
distancia_1 = sqrt((x_inter-xl_2).^2 + (y_inter-yl_2).^2);
distancia_2 = sqrt((x_inter-xl_2).^2 + ((-y_inter)-yl_2).^2);

if (distancia_1<distancia_2)

plot(x_inter,y_inter, 'r*', 'linewidth', 1); %interseccao parte de cima do circulo girado
text(x_inter+0.009,y_inter+0.009, '3'); %plot 

%achar a admitância do ponto 3
ponto1_interseccao=x_inter+y_inter*j;
angulo_interseccao=angle(ponto1_interseccao);
angulo_interseccao_1_graus=angulo_interseccao*(180/pi); %rad pra graus
rho_interseccao_1=abs(ponto1_interseccao);

[xl_4,yl_4]=admitancia(angulo_interseccao_1_graus,rho_interseccao_1);
plot(xl_4,yl_4, 'r*', 'linewidth', 1);
text(xl_4+0.009,yl_4+0.009, '4');

%Diferença da admitancia até a intersecção  (na parte de cima do círculo)
[real_inter_sup,imag_inter_sup]=cartesiano_imag(x_inter,y_inter, rho_interseccao_1); %Parte real e imaginária do ponto 3
[real_adm_ponto2,imag_adm_ponto2]=cartesiano_imag(xl_2,yl_2, handles.rho); %Parte real e imaginaria da impedância
difer1= imag_inter_sup-imag_adm_ponto2; %diferença adm - interseccao parte de cima circulo']);

%PARALELO
if difer1 < 0 %Se a diferença entre os pontos for negativa é um indutor em admitancia
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_admit(handles.z0,handles.freq,difer1);
    set(handles.text22,'String',['L=' ,num2str(indutor),' H - Paralelo']);
else
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_admint(handles.z0,handles.freq,difer1);
    set(handles.text22,'String',['C=' ,num2str(capacitor),' F - Paralelo']);
end

%diferença entre a admitancia da interseccao e o centro da carta
[real_adm_ponto4,imag_adm_ponto4]=cartesiano_imag(xl_4,yl_4, handles.rho);
difer2=imag_adm_ponto4; %diferença da interseccao e centro da carta

%SERIE
if difer2 < 0 %Se a diferença entre os pontos for negativa é um indutor em admitancia
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_imp(handles.z0,handles.freq,difer2);
    set(handles.text28,'String',['C=' ,num2str(capacitor),' F - Série']);
else
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_imp(handles.z0,handles.freq,difer2);
    set(handles.text28,'String',['L= ' num2str(indutor) ' H - Série']);
end

else %distancia2<distancia1
plot(x_inter,-y_inter, 'r*', 'linewidth', 1); %interseccao parte de baixo do circulo girado   
text(x_inter+0.009,-y_inter+0.009, '3'); 

%achar admitancia do ponto 3
ponto2_interseccao=x_inter-y_inter*j;
angulo2_interseccao=angle(ponto2_interseccao);
angulo2_interseccao_graus=angulo2_interseccao*(180/pi); %rad pra graus
rho_interseccao_2=abs(ponto2_interseccao);

[xl_4,yl_4]=admitancia(angulo2_interseccao_graus,rho_interseccao_2);
plot(xl_4,yl_4, 'r*', 'linewidth', 1);
text(xl_4+0.009,yl_4+0.009, '4');

%diferencia entre admitancia e intersecção (na parte de baixo do círculo)
[real_inter_inf,imag_inter_inf]=cartesiano_imag(x_inter,-y_inter, rho_interseccao_2); %Parte real e imaginária do ponto 3
[real_adm,imag_adm]=cartesiano_imag(xl_2,yl_2, handles.angulo); %Parte real e imaginaria da impedância
difer1= imag_inter_inf-imag_adm; %difer entre admin e interseccao parte de baixo do circulo

%PARALELO
if difer1 < 0
     set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_admit(handles.z0,handles.freq,difer1);
    set(handles.text22,'String',['L= ' num2str(indutor),' H - Paralelo']);
else
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_admint(handles.z0,handles.freq,difer1);
    set(handles.text22,'String',['C= ' num2str(capacitor) ' F - Paralelo']);
end

%diferenca entre a admitancia da intersecção e o centro da carta
[real_adm_ponto4,imag_adm_ponto4]=cartesiano_imag(xl_4,yl_4, handles.rho);
difer2=imag_adm_ponto4;%difer ad da interseccao e centro da carta
%Serie
if difer2 < 0
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_imp(handles.z0,handles.freq,difer2);
    set(handles.text28,'String',['C= ' num2str(capacitor) ' F - Série']);
else
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_imp(handles.z0,handles.freq,difer2);
    set(handles.text28,'String',['L= ' num2str(indutor) ' H - Série']);
end

end

elseif (real(1/handles.imp_normal)>1)  %se a a admitancia é maior q 1, tá no circulo girado

x_real=real(handles.imp_normal);
imp=(x_real + j*0.0001)/1;
[x_cart,y_cart,angulo,handles.rho] = imag_cartesiano(imp);
[x_inter,y_inter] = interseccao_L(real(handles.imp_normal));
plot(x_inter,y_inter, '*b');
plot(x_inter,-y_inter, '*b');

%Calcular a menor distância menor distancia
distancia_1 = sqrt((x_inter-handles.x_1).^2 + (y_inter-handles.y_1).^2); %distancia 1 intersecccao do circulo girado
distancia_2 = sqrt((x_inter-handles.x_1).^2 + (-1*(y_inter)-handles.y_1).^2); %distancia 2 intersecccao do circulo girado

if (distancia_1<distancia_2)
    
plot(x_inter,y_inter, 'r*', 'linewidth', 1); %interseccao parte de cima do circulo girado
text(x_inter+0.009,y_inter+0.009, '2'); %plot ponto2

ponto__inter=x_inter+y_inter*j;
angulo_inter=angle(ponto__inter);
angulo_ponto_1_graus=angulo_inter*(180/pi); %rad pra graus
rho_ponto_1=abs(ponto__inter);
 
% Achar admitancia
[yl_1,yl_2]=admitancia(angulo_ponto_1_graus,rho_ponto_1);
plot(yl_1,yl_2, 'r*', 'linewidth', 1);
text(yl_1+0.009,yl_2+0.009, '3-YL');

%distancia entre admitancia e interseccao
[real1,imag1]=cartesiano_imag(x_inter,y_inter, angulo_ponto_1_graus);
difer1= imag1 - imag(handles.imp_normal); %difer entre admitancia e interseccao
%SERIE
if difer1 < 0
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_imp(handles.z0,handles.freq,difer1); 
    set(handles.text28,'String',['C= ' num2str(capacitor) ' F - Série']);
else
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_imp(handles.z0,handles.freq,difer1);
    set(handles.text28,'String',['L= ' num2str(indutor) ' H - Série']);
end

ponto_2=-yl_1+yl_2*j;
angulo_ponto_2=angle(ponto_2);
angulo_ponto_2_graus=angulo_ponto_2*(180/pi); %rad pra graus
rho_ponto_2=abs(ponto_2);

%diferenca entre a interseccao e o centro da carta
[real2,imag2]=cartesiano_imag(yl_1,yl_2, angulo_ponto_2_graus);
difer2= - imag2; %diferenca entre intersecao e centro da carta
%PARALELO
if difer2 < 0
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_admit(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['L= ', num2str(indutor) ' H - Paralelo']);
else
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_admint(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['C= ', num2str(capacitor) ' F - Paralelo']);
end

else 
plot(x_inter,-y_inter, 'r*', 'linewidth', 1); %interseccao parte de baixo do circulo girado
text(x_inter+0.009,-y_inter+0.009, '2'); %plot ponto 2
 
ponto_2=-x_inter-y_inter*j;
angulo_ponto_2=angle(ponto_2);
angulo_ponto_2_graus=angulo_ponto_2*(180/pi); %rad pra graus
rho_ponto_2=abs(ponto_2);
 
% Achar admitancia
[xl_3,xl_3]=admitancia(angulo_ponto_2_graus,rho_ponto_2);
plot(xl_3,yl_3, 'r*', 'linewidth', 1);
text(xl_3+0.009,yl_3+0.009, '3-YL');

%diferenca entre a admitancia e a interseccao
[real_inter2,imag_inter3]=cartesiano_imag(-x_inter,-y_inter, angulo_ponto_1_graus); %ponto1
difer1= imag_inter3-imag(handles.imp_normal);%diferença entre admitancia e interseccao

%SERIE
if difer1 < 0
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_imp(handles.z0,handles.freq,difer1);
    set(handles.text28,'String',['C= ',num2str(capacitor),' F - Série']);
else
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_imp(handles.z0,handles.freq,difer1);
    set(handles.text28,'String',['L= ', num2str(indutor),' H - Série']);
end

ponto_2=-yl_1+yl_2*j;
angulo_ponto_2=angle(ponto_2);
angulo_ponto_2_graus=angulo_ponto_2*(180/pi); %rad pra graus
rho_ponto_2=abs(ponto_2);

%diferenca entre a intersseccao e o centro da carta
[real_adm3,imag_adm3]=cartesiano_imag(yl_1,yl_2, angulo_ponto_2_graus);
difer2= - imag_adm3;%diferenca da intercesscao ate o centro da carta
%PARALELO
if difer2 < 0
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_admit(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['L= ' num2str(indutor),' H - Paralelo']);
else
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_admint(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['C= ' ,num2str(capacitor),' F - Paralelo']);
end
end

else %cair fora dos círculos 
[x_inter,y_inter] = interseccao_L(real(handles.imp_normal));
plot(x_inter,y_inter, '*b');
plot(x_inter,-y_inter, '*b');
    
%Calcular a menor distância menor_distancia
    distancia_1 = sqrt((x_inter-handles.x_1).^2 + (y_inter-handles.y_1).^2);  %distancia do ponto fora do circulo ate circ. girado
    distancia_2 = sqrt((x_inter-handles.x_1).^2 + (-1*y_inter-handles.y_1).^2);%distancia do ponto fora do circulo ate circ. girado
if (distancia_1<distancia_2)
text(x_inter+0.009,y_inter+0.009, '2');
    
%admitancia do ponto 2
ponto_inter=x_inter+y_inter*j;
angulo_inter=angle(ponto_inter);
angulo_ponto_1_graus=angulo_inter*(180/pi); %rad pra graus
rho_ponto_1=abs(ponto_inter);
 
% Achar admitancia
[yl_1,yl_2]=admitancia(angulo_ponto_1_graus,rho_ponto_1);
plot(yl_1,yl_2, 'r*', 'linewidth', 1);
text(yl_1+0.009,yl_2+0.009, '3');

%achar angulo interseccao
ponto_inter=x_inter+y_inter*j;
angulo_inter=angle(ponto_inter);
angulo_inter_graus=angulo_inter*(180/pi); %rad pra graus

%diferenca entre interseccao e a impedancia
[real_inter,imag_inter]=cartesiano_imag(x_inter,y_inter, angulo_inter_graus);
difer1= imag_inter - imag(handles.imp_normal);%diferenca da interseccao e até a impedancia
%SERIE
if difer1 < 0
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_imp(handles.z0,handles.freq,difer1);
    set(handles.text28,'String',['C= ', num2str(capacitor),' F - Série']);

else
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_imp(handles.z0,handles.freq,difer1);
    set(handles.text28,'String',['L= ', num2str(indutor),' H - Série']);
end

%achar angulo admitancia ponto 2
ponto_adm=yl_1+yl_2*j;
angulo_adm=angle(ponto_inter);
angulo_adm_graus=angulo_adm*(180/pi); %rad pra graus

%diferenca entre a admitancia da interseccao e o centro da carta
[real_adm4,imag_adm4]=cartesiano_imag(yl_1,yl_2, angulo_adm_graus);
difer2= - imag_adm4;%diferenca da interseccao até o centro da carta
%PARALELO
if difer2 < 0
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_admit(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['L=' ,num2str(indutor),' H - Paralelo']);
else
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_admint(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['C=',num2str(capacitor),' F - Paralelo']);
end

else%(distacia_1>distancia_2)
text(x_inter+0.009,-y_inter+0.009, '2');
    
%admitancia do ponto 2
ponto_inter=x_inter-y_inter*j;
angulo_inter=angle(ponto_inter);
angulo_inter_2_graus=angulo_inter*(180/pi); %rad pra graus
rho_inter_2=abs(ponto_inter);
 
% Achar admitancia
[yl_1,yl_2]=admitancia(angulo_inter_2_graus,rho_inter_2);
plot(yl_1,yl_2, 'r*', 'linewidth', 1);
text(yl_1+0.009,yl_2+0.009, '3-zl');

%achar angulo interseccao
ponto_inter_2=x_inter-y_inter*j;
angulo_inter_2=angle(ponto_inter_2);
angulo_inter_graus_2=angulo_inter*(180/pi); %rad pra graus

%diferenca entre entre intersecao e impedancia 
[real_inter,imag_inter]=cartesiano_imag(x_inter,-y_inter, angulo_inter_graus_2);
difer1= imag_inter - imag(handles.imp_normal);%diferenca da interseccao ate a impedancia']);
%SERIE
if difer1 < 0
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_imp(handles.z0,handles.freq,difer1);
    set(handles.text28,'String', ['C= ', num2str(capacitor),' F - Série']);
else
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_imp(handles.z0,handles.freq,difer1);
    set(handles.text28,'String', ['L= ', num2str(indutor),' H - Série']);
end

%achar angulo admitancia ponto 2

ponto_adm=yl_1+yl_2*j;
angulo_adm=angle(ponto_inter);
angulo_adm_graus=angulo_adm*(180/pi); %rad pra graus

%diferenca entre a admitancia da interseccao e o centro da carta
[real_adm3,imag_adm3]=cartesiano_imag(yl_1,yl_2, angulo_inter_2_graus);
difer2= - imag_adm3;%diferenca da admitancia ate o centro da carta
%PARALELO
if difer2 < 0
    set(handles.uipanel1, 'Visible', 'on');
    indutor=indutor_admit(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['L= ', num2str(indutor), ' H - Paralelo']);
else
    set(handles.uipanel1, 'Visible', 'on');
    capacitor=capacitor_admint(handles.z0,handles.freq,difer2);
    set(handles.text22,'String',['C= ' num2str(capacitor), ' F - Paralelo']);
end
end
end

if (real(handles.imp_normal)>=1)%ver a parte real é maior 1, se for tá no circulo 1+-j
set(handles.uipanel7, 'Visible', 'on');
set(handles.text74, 'String', ['1. Traçar o círculo 1±j e o círculo girado']);
set(handles.text73, 'String', ['2. Achar a impedância normalizada', ' ZL=', num2str(handles.imp_normal),' (ponto 1)']);
set(handles.text72, 'String', ['3. Achar o ponto admitante a impedância', ' YL=', num2str(handles.adm_normal),' (ponto 2)']);
set(handles.text71, 'String', ['4. Caminhar pelas linhas da carta até encontrar a borda do círculo girado (ponto 3)']);
set(handles.text70, 'String', ['5. Achar o ponto admitante ao ponto 3 (ponto 4)']);
set(handles.text69, 'String', ['6. Caminhar pelas linhas da carta até chegar os centro da carta']);
else
set(handles.uipanel7, 'Visible', 'on');
set(handles.text74, 'String', ['1. Traçar o círculo 11±j e o círculo girado']);
set(handles.text73, 'String', ['2. Achar a impedância normalizada', ' ZL=', num2str(handles.imp_normal),' (ponto 1)']);
set(handles.text72, 'String', ['3. Caminhar pelas linhas da carta até encontrar a borda do círculo girado (ponto 2)']);
set(handles.text71, 'String', ['4. Achar o ponto admitante ao ponto 2 (ponto 3)']);
set(handles.text70, 'String', ['5. Caminhar pelas linhas da carta até chegar os centro da carta']);
end    

function edit2_Callback(hObject, eventdata, handles)

handles.zl = str2double(get(hObject,'String'))
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles) %Roda o software

CartaSmithImpedancia;

function edit3_Callback(hObject, eventdata, handles) % freq

handles.freq = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)%reinicia o software
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(interface);
interface;
