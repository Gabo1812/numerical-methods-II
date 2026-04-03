% Examen II Metodos numericos II
%Gabriel Alvarez Castrillo C00368
%Problema 4:
clearvars;
% Limites del dominio
L = 0.1;%m
xi = 0; 
xf = L; 
ti = 0; 
tf = 30; 
% Condiciones de frontera 
qx = 401e3; % Flujo de calor en x=0
Txf = 0; % Temperatura en x=L
Txi = 0;
% Partición del dominio
factor = 100;
n = factor * 1;  % Número de puntos en x
m = factor * 5;  % Número de puntos en t

h = (xf-xi)/n; 
k = (tf-ti)/m; 

x = (xi:h:xf)'; 
t = (ti:k:tf)'; 

% Difusividad térmica del cobre
a = 111.0e-6; % m^2/s
kappa = 401; % W/(m*K)

r = a*k/h^2; % Coeficiente

% Inicialización de la matriz de coeficientes
A = zeros(n-1,n-1); % Matriz de coeficientes

% Llenado de la matriz de coeficientes
for i=1:n-1
    A(i,i) = (1+2*r); % Diagonal principal
end

for i=1:n-2
    A(i,i+1) = -r; % Diagonal superior
    A(i+1,i) = -r; % Diagonal inferior
end

% Inversión de la matriz de coeficientes
B = inv(A); 

% Definición de la condición inicial
T0 = @(x) zeros(size(x(2:end-1))); % Temperatura inicial

Tt = T0(x); 
for j=1:m
    % Actualización de las condiciones de frontera
    Tt(1) = Tt(1) + r*Txi; % Condición de flujo de calor
    Tt(end) = Tt(end) + r*Txf; % Condición de temperatura fija
    
    % Cálculo de la nueva distribución de temperatura
    T = B*Tt; % Solución del sistema de ecuaciones
    
    Txi = T(1)+2*h*(qx/kappa);
    Txf = T(end);
    area(x,[Txi;T;Txf],'FaceColor','b');
    xlabel('L(m)');
    ylabel('T(c)');
    ylim([0 150]);
    xlim([0 0.1])
    str = ['t =', num2str(t(j)),' s'];
    text(0.05,95,str);
    Tt = T;
    pause(0.01);
end

