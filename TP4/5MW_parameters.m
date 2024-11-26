clc
clear

%% Asynchronous Machine
G.Vsn = 400;                     %% Tensión de estator nominal (Vef)
G.fsn = 50;                      %% Frecuencia eléctrica de estator nominal (Hz)
G.we = 2*pi*G.fsn;               %% Frecuencia eléctrica de estator nominal (rad/s)
G.P = 2;                         %% Número de pares de polos
G.wsn= G.we/G.P;                 %% Frecuencia de sincronismo (rad/s)
G.nsinc = 60/(2*pi)*G.wsn;       %% Frecuencia de sincronismo (rpm)
G.Rr = 0.01;%1.3e-2;             %% Resistencia de rotor (Ohms)
G.Rs = 0.015;                    %% Resistencia de estator (Ohms)
G.J= 550;                        %% Inercia del generador (kg.m^2)

%% Eolic Turbine
T.tsr_0 = 7.5586;                %% TSR óptimo
T.pitch_0 = 0;                   %% Ángulo de pitch óptimo (°)
T.Cpmax = 0.487;                 %% Valor máximo del coeficiente de potencia
T.N = 3;                         %% Número de palas
T.R = 126/2;                     %% Radio de las palas (m)
T.rho = 1.2244;                  %% Densidad del aire (kg/m^3)
T.J= 40e6;                       %% Inercia de la turbina (kg.m^2)

load('5MW.mat','Cp_table',...    %% Carga del coeficiente de potencia
    'pitch_axis','tsr_axis');    

T.tsr = min(tsr_axis):0.01:max(tsr_axis)';
T.pitch = min(pitch_axis):0.1:max(pitch_axis);
[tsr_g, pitch_g]  = meshgrid(T.tsr',T.pitch);
T.Cp = interp2(tsr_axis,pitch_axis,Cp_table,tsr_g,pitch_g,'spline');
T.Ct = T.Cp./T.tsr;
clear Cp_table pitch_axis tsr_axis tsr_g pitch_g

%% Resource
V.cin = 3;                       %% Velocidad del viento cut-in (m/s)
V.cout = 25;                     %% Velocidad del viento cut-out (m/s)