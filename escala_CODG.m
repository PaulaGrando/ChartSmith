function [d1,d2] = escala_CODG(angulo,angulo_toco_rad,angulo_ponto2_rad)

angulo_admitancia=angulo+180; %calculo do angulo da admitancia

if angulo_admitancia<=180 %se o angulo_admitancia ta na parte de cima do grafico
    ajuste_angulo=180-angulo_admitancia;
    tam=(ajuste_angulo*0.5)/360;

    if angulo_toco_rad<=180 %se a interseccao esta na parte de cima do grafico
        ajuste_angulo1=180-angulo_toco_rad;
        tam1=(ajuste_angulo1*0.5)/360;
        d1=tam1-tam;
        else %se a intersecao esta na parte de baixo do grafico
            ajuste_angulo_1=360-angulo_toco_rad+180;
            tam_1=(ajuste_angulo_1*0.5)/360;
            d1=tam_1-tam;
    end
    if angulo_ponto2_rad<=180 %se a intersecao esta¡ na parte de cima do grafico
        ajuste_angulo2=180-angulo_ponto2_rad;
        tam2=(ajuste_angulo2*0.5)/360;
        d2=tam2-tam;
        else %se a interseccao esta¡ na parte de baixo do grafico
            ajuste_angulo_2=360-angulo_ponto2_rad+180;
            tam_2=(ajuste_angulo_2*0.5)/360;
            d2=tam_2-tam;
    end

else %se o angulo_admitancia ta na parte de baixo do grafico
    ajuste_angulo_admitancia=360-angulo_admitancia+180;
    tam_admitancia_1=(ajuste_angulo_admitancia*0.5)/360;
    
    if angulo_toco_rad<=180 %se a interseccao esta na parte de cima do grafico
        ajuste_angulo1=180-angulo_toco_rad;
        tam1=(ajuste_angulo1*0.5)/360;
        d1=tam1-tam_admitancia_1;
        else %se a interseccao esta na parte de baixo do grafico
            ajuste_angulo_1=360-angulo_toco_rad+180;
            tam_1=(ajuste_angulo_1*0.5)/360;
            d1=tam_1-tam_admitancia_1;
    end
    if angulo_ponto2_rad<=180 %se a interseccao esta¡ na parte de cima do grafico
        ajuste_angulo2=180-angulo_ponto2_rad;
        tam2=(ajuste_angulo2*0.5)/360;
        d2=tam2-tam_admitancia_1;
        else %se a interseccao esta na parte de baixo do grafico
        ajuste_angulo_2=360-angulo_ponto2_rad+180;
        tam_2=(ajuste_angulo_2*0.5)/360;
        d2=tam_2-tam_admitancia_1;
    end
end

end