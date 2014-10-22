clear all; close all; clc;

%% Dominio del tiempo
N = 1e5;
t = 0:1/N:10;
x = 10 * cos (10 * t) - 5 * cos(0.001 * t) + 10 * sin(0.01 * t) + 10 * cos(100 * t);
x1 = 10 * sin(0.01 * t);

%% frecuencias y fases iniciales

% frecuencias
w1 = 0.01;
w2 = 0.1;
w3 = 10;
w4 = 100; % frecuencia mas alta

% fases
phi1 = 0;
phi2 = -pi / 2;
phi3 = 0;
phi4 = -pi / 2;

%%%%%% Disenio del filtro
atenuacion_min = -80; % db
y_entre_x = 10 ^ (atenuacion_min / 20);

%% Probando para un filtro de orden 1
%
%    o----[ R ]------o
%                |    
%    +           ^   +
%    x           C   y
%    -           v   -
%                |   
%    ----------------o
%
%    Y           1
%   ---(s) = ---------
%    X        1 + R*C*s
%
%

RC_min = sqrt( 1 / y_entre_x ^ 2 - 1) / w4

% Lastimosasmente esto genera que la ganacia a w = 0.1 sea 0.5 a lo mucho
% por lo tanto no es una solución dable.

%% Probando para un filtro de oreden 2

%    o----[ R1 ]-----[ R2 ]-------o
%                 |          |
%    +            ^          ^    +
%    x           C1         C2    y
%    -            v          v    -
%                 |          |
%    o----------------------------o
%
%
%     Y                 1
%    ---(s) = -----------------------
%     X        a * s^2 + b * s + 1
%
%     Donde:
%       - a = R1 * R2 * C1 * C2
%       - b = R1 * C1 + R1 * C2 + R2 * C2
%

% Dado a que la atenuación es -80db a w=100
% entonces en w = 1 la atenuación es 1/2

% y en el bode asintótico se aprecia que w=1
% es una buena frecuencia de corte

% Con w = 1:
a = 1

% Para s = 100j
%
%  |              1               |                   1
%  | ---------------------------- | < y_entre_x = -------
%  |  (-100j*a)^2 + 100j * b + 1  |                10000
%
b_min = sqrt( 1 / y_entre_x^2 - (1-w4^2)^2 )

b = b_min;

%% Nuevas fases

% Los desfasajes son
delta_phi1 = angle(1 / (-(a*w1)^2 + 1 + w1*b*1j ))
delta_phi2 = angle(1 / (-(a*w2)^2 + 1 + w2*b*1j ))
delta_phi3 = angle(1 / (-(a*w3)^2 + 1 + w3*b*1j ))
delta_phi4 = angle(1 / (-(a*w4)^2 + 1 + w4*b*1j ))

phi1_f = phi1 + delta_phi1
phi2_f = phi2 + delta_phi2
phi3_f = phi3 + delta_phi3
phi4_f = phi4 + delta_phi4

%% Simulacion
sys = tf(1, [a b 1]);
[y,ty] = lsim(sys,x,t);

figure(2)
plot(t,x);
figure(3);
plot(ty,y);


%%%% Circuito RLC

%    o----[ L ]--------------o
%                 |     |
%    +            ^     ^    +
%    x            C     R    y
%    -            v     v    -
%                 |     |
%    o-----------------------o
%
%
%     Y                 R
%    ---(s) = -----------------------
%     X        RLC * s^2 + L * s + R
%

wc = 1; % frecuencia de corte

LC = 1 / w1 ^ 2;
% R = RLC

R = 1000;
L_min = sqrt( (R / y_entre_x)^2 - R^2*(1-w4^2 )^2 )
L = L_min

% Los desfasajes son
delta_phi1 = angle(R / ( R * (1 - w1^2) + 1j * L * w1 ) )
delta_phi2 = angle(R / ( R * (1 - w2^2) + 1j * L * w2 ) )
delta_phi3 = angle(R / ( R * (1 - w3^2) + 1j * L * w3 ) )
delta_phi4 = angle(R / ( R * (1 - w4^2) + 1j * L * w4 ) )

% fases finales en radianes
phi1_f = phi1 + delta_phi1
phi2_f = phi2 + delta_phi2
phi3_f = phi3 + delta_phi3
phi4_f = phi4 + delta_phi4

%% Simulacion
sys = tf(1, [R L 1]);
[y,ty] = lsim(sys,x,t);

figure(3);
plot(ty,y);
