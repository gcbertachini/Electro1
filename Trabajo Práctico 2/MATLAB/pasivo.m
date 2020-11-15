clc
% Parámetros independientes:

    % Componentes Externos
RB = 1e3;
RE = .9e3;
Ci = 100e-9;
CL = 100e-9;
RL = 100e3;
Vcc= 9;
RS = 50;
    % Transistores BJT
Vbe= 0.6;
hFE1= 150;
hFE2= 290;

% Ccb cambia respecto a VCB
Ccb1 = 5.0e-12;
Ccb2 = 3.5e-12;

% Cálculos de Polarización
IE2 = (Vcc-2*Vbe)/(RE + RB/((1+hFE1)*(1+hFE2)));
IC2 = IE2 * hFE2/(hFE2+1);
IC1 = IE2 * hFE1/(hFE1+1)/(hFE2+1);

VCE2 = Vcc - IE2*RE;
VCE1 = Vcc - IE2*RE - Vbe;

IB1 = IC1/hFE1;
IB2 = IC2/hFE2;

% Importante para Ccb
VB1 = Vcc-IB1*RB;
VCB1 = Vcc-VB1;

VB2 = VB1-Vbe;
VCB2 = Vcc-VB2;

% Potencia del Transistor
PW1 = VCE1*IC1;
PW2 = VCE2*IC2;
% Verificar Zona Segura

VT = 25.5e-3;
VA = 60;
% Parámetros Híbridos
hfe1 = 150;
hie1 = (hfe1+1)*VT/IC1;
hoe1 = IC1/VA;
rce1 = 1/hoe1;

hfe2 = 290;
hie2 = (hfe2+1)*VT/IC2;
hoe2 = IC2/VA;
rce2 = 1/hoe2;

% Circuito Incremental
Rd = 1/(1/RE + 1/RL);

    % Ganancias e impedancias de entrada
Av = 1/(1 + (hie1+hie2*(1+hfe2))/(Rd*(1+hfe1)*(1+hfe2)));

Av2= 1/(1 +  hie2/(Rd*(1+hfe2)));
ri2 = hie2 + (1+hfe2)*Rd;

Av1= 1/(1 +  hie1/(ri2*(1+hfe1)));
ri1 = hie1 + (1+hfe1)*ri2;
ri = ri1;

ria = 1/(1/ri + 1/RB);

Ai = (1+hfe1)*(1+hfe2);
Avs = Av*ria/(ria+RS);

    % Impedancias de Salida

ro1s = (1/(1/RS+1/RB) + hie1)/(1+hfe1);
ro1  = 1/(1/ro1s + 1/rce1);
ro2s = (ro1+hie2)/(1+hfe2);
ro2  = 1/(1/ro2s + 1/rce2);

ro = ro2;
roa = 1/(1/ro + 1/RE);

% Respuesta en Frecuencia
t1 = Ci*(RS+ria);
t2 = CL*(RL+roa);

fL = 1/(2*pi)*(1/t1+1/t2);

t3 = Ccb1 * (1/(1/RS + 1/ria));
t4 = Ccb2 * (1/(1/ro1 + 1/ri2));

fH = 1/(2*pi*(t3+t4));
