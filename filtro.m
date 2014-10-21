clear all; close all; clc;

%% Dominio del tiempo
t = 0:0.0001:10;
x = 10 * cos (10 * t) - 5 * cos(0.001 * t) + 10 * sin(0.01 * t) + 10 * cos(100 * t);


%%%%%% Disenio del filtro
w_max = 100; % frecuencia angular mas alta
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

RC_min = sqrt( 1 / y_entre_x ^ 2 - 1) / w_max

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
b_min = sqrt( 10000^2 - (1-100^2)^2 )
