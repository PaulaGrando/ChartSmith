zl = handles.zl;
z0= handles.z0;

%% Impedancia Normalizada 
handles.imp_normal=zl/z0;
%disp(['Impedancia Normalizada= ', num2str(imp_normal)]);
set(handles.text11, 'String', num2str(handles.imp_normal));
guidata(hObject, handles);


%% Admitancia normaliza
handles.adm_normal= 1/handles.imp_normal;

%% Calculo do Coeficiente de Reflexao
handles.coef_reflex=(zl-z0)/(zl+z0);
    handles.rho=abs(handles.coef_reflex);
    handles.theta=angle(handles.coef_reflex);
    handles.angulo=handles.theta*(180/pi); %rad pra graus
set(handles.text15, 'String', num2str(handles.rho));
set(handles.text16, 'String', [num2str(handles.angulo),'°']);

guidata(hObject, handles);
%% VSWR imp_normal
VSWR=(1+abs(handles.coef_reflex))/(1-abs(handles.coef_reflex));
set(handles.text14, 'String', num2str(VSWR));

%% Valor de maximo
set(handles.text13, 'String', num2str(VSWR));

%% Valor de minimo 
vswr_deslocado=VSWR*pi;
val_min=(1+abs(vswr_deslocado))/(1-abs(vswr_deslocado));
set(handles.text12, 'String', num2str(abs(val_min)));

%%%%%%%%%%%%%%%%%%%%%%% ENCONTRA PARAMETROS BASICOS %%%%%%%%%%%%%%%%%%%%%%
%% Localiza a impedancia
[handles.x_1, handles.y_1, handles.angulo, handles.rho]=imag_cartesiano(handles.imp_normal);
plot(handles.x_1,handles.y_1, 'r*', 'linewidth', 1)
text(handles.x_1+0.009,handles.y_1+0.009, '1-zl')

guidata(hObject, handles);

%% mostra o valor de maximo
plot(handles.rho,0, 'rx')
text(handles.rho,0.09, 'VSWR')

%% Mostra o valor de minimo
plot(-1*handles.rho,0, 'rx')
text(-1*handles.rho,0.09, 'min')