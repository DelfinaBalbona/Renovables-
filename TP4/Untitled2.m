% TPN4 Balbona Delfina 

clear
clc
load('5MW.mat')
R = 36.8000;
rho = 1.2200;
A = pi * (R^2);

%% Ejercicio 1
% Representacion de las curvas características de par y potencia de la
% turbina en función de la velocidad de rotación para diferentes 
% velocidades de viento.

v = 5:1:15;
w_max_vals = [];
P_max_vals = [];

figure(1)
hold on 
for i = 1:11
    P = (0.5 * rho * A *(v(i)^3).*Cp_table(1,:))/1000;
    omega_r = tsr_axis.*v(i)/R;
    
    % Interpolación spline
    omega_r_dense = linspace(min(omega_r), max(omega_r), 500); % Densidad alta
    P_dense = spline(omega_r, P, omega_r_dense); % Interpolar con spline
    
    % Graficar curvas suavizadas
    plot(omega_r_dense, P_dense, 'LineWidth', 1);
    
    [P_max, idx_max] = max(P_dense);
    w_max = omega_r_dense(idx_max);
    w_max_vals = [w_max_vals, w_max];
    P_max_vals = [P_max_vals, P_max];
   
end 

plot(w_max_vals, P_max_vals, 'm', 'LineWidth', 1.5);
legend('v = 5 m/s','v = 6 m/s', 'v = 7 m/s', 'v = 8 m/s','v = 9 m/s', 'v = 10 m/s', 'v = 11 m/s', 'v = 12 m/s', 'v = 13 m/s', 'v = 14 m/s', 'v = 15 m/s', '$\lambda_{opt}$','Interpreter', 'latex')

title('Curvas Potencia-Velocidad ($\beta = 0$)','Interpreter', 'latex')
xlabel('$\Omega [r/s]$','Interpreter', 'latex');
ylabel('$Potencia [kW]$','Interpreter', 'latex');
hold off

w_max_vals = [];
P_max_vals = [];

figure(2)
hold on 
for i = 1:11
    P = (0.5 * rho * A *(v(i)^3).*Cp_table(1,:))/1000;
    omega_r = tsr_axis.*v(i)/R;
    tau = P ./ omega_r; % Cupla mecánica
    
    % Interpolación spline
    omega_r_dense = linspace(min(omega_r), max(omega_r), 500); % Densidad alta
    tau_dense = spline(omega_r, tau, omega_r_dense); % Interpolar con spline
    P_dense = spline(omega_r, P, omega_r_dense); % Interpolar con spline

    % Graficar curvas suavizadas
    plot(omega_r_dense, tau_dense, 'LineWidth', 1);
    
    [P_max, idx_max] = max(P_dense*18/45);
    w_max = omega_r_dense(idx_max);
    w_max_vals = [w_max_vals, w_max];
    P_max_vals = [P_max_vals, P_max];
   
end 

plot(w_max_vals, P_max_vals, 'm', 'LineWidth', 1.2);
legend('v = 5 m/s','v = 6 m/s', 'v = 7 m/s', 'v = 8 m/s','v = 9 m/s', 'v = 10 m/s', 'v = 11 m/s', 'v = 12 m/s', 'v = 13 m/s', 'v = 14 m/s', 'v = 15 m/s', '$\lambda_{opt}$','Interpreter', 'latex')

title('Curvas Cupla-Velocidad ($\beta = 0$)','Interpreter', 'latex')
xlabel('$\Omega [r/s]$','Interpreter', 'latex');
ylabel('$Torque [kNm]$','Interpreter', 'latex');

%plot(out.wt,out.Tg/1000)
plot(out.wt,out.Tt/1000)

hold off 

%% Ejercicio 2
% Diseño del valor de la relación de engranajes Nv para que el sistema
% realice una limitación de potencia pasiva (control por frente de stall) a 5MW

%curva de la turbina para tener Pmax en 5 MW
v = 16.3;

f = 50;
omega_s = 2*pi*f/4;
omega_g = omega_s;

P = (0.5 * rho * A *(v^3).*Cp_table(1,:))/1000;
omega_r = tsr_axis.*v/R;
    
plot(omega_r, P, 'LineWidth', 1);

[P_max, idx_max] = max(P);
omega_t = omega_r(idx_max);

Nv = omega_g/omega_t;

%curvas del generador escaladas por el Nv

Vs = 400;
Rr = 1.3e-3; 
k = (3/Rr)*(Vs/omega_s)^2;
omega_r = 0:0.01:(omega_s*1.2);
f = [35,40,45,50,55,60,65];

for i = 1:length(f)
    figure(1)
    omega_s = 2*pi*f(i)/4;
    Tg =k*(omega_s-omega_r)/Nv;
    plot(omega_r, Tg);
    hold on
    ylim([0e5,2.5e5])
end 

%% Ejercicio 3

T.Cp = Cp_table; 
T.pitch = pitch_axis;
T.tsr = tsr_axis;
T.rho = rho;
T.R = R;
T.Nv = Nv;
T.Jeq = 40e6; 

G.P = 5e6;
G.Vsn = Vs;
G.wsn = 2*pi*50/4;
G.Rr = Rr;

