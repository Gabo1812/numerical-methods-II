%Tarea II Metodos numericos II
%Gabriel Alvarez Castrillo C00368
%Problema 3:
clearvars;

% Limites del dominio
xi = 0;
xf = 0.10;%m
yi = 0;
yf = 0.10;

% Partición del dominio
factor = 10;
m = factor * 5; % Número de puntos en x
n = factor * 5; % Número de puntos en y

h = (xf - xi)/m;
k = (yf - yi)/n;

x = (xi:h:xf)'; 
y = (yi:k:yf)'; 
U = zeros(m+1, n+1);

%Para resolver la ec. Laplace 
f = @(x,y) 0;

% Condiciones de frontera Dirichlet

U(:,1)=100;  % Condición de frontera inferior U(0,y)
U(:,end)=25; % Condición de frontera superior U(xf,y)
% Condiciones de frontera de Neumann (derivada normal cero)
U(1,2:m)=U(2,2:m);%Tasa de variación nula en y=0, Neumann
U(end,2:m)=U(end-1,2:m);   

% Coeficientes para el método numérico
beta = (h/k)^2;
alpha = 2 * (1 + (h/k)^2);
% .......... Matriz patrón con los coeficientes ..........
A = zeros(m - 1, n - 1);
for i = 1:m-1
    A(i, i) = alpha; % Diagonal principal
end
for i = 1:m-2
    A(i, i + 1) = -beta;% Diagonal superior
    A(i + 1, i) = -beta;% Diagonal inferior
end
% Conforma la matriz del Problema:
C = A;
for i = 1:n-2
    C = blkdiag(C, A);% Agregar A a la matriz de bloques
end

for i = 0:size(C, 1)-m
    C(i + 1, m + i) = -beta;
    C(m + i, i + 1) = -beta;
end

% Se crea el vector b:
b = zeros(size(C, 1), 1);
l = 0;
for i = 2:n
    for j = 2:m
        l = l + 1;
        b(l) = U(i - 1, j) + U(i + 1, j) + beta * (U(i, j - 1) + U(i, j + 1))- (h^2)*f(x(i), y(j));
    end
end

%Resolver el sistema
u = C \ b;
% Rellenar la matriz U con los valores calculados
l = 0;
for i = 2:n
    for j = 2:m
        l = l + 1;
        U(i, j) = u(l);
    end
end

% Graficando la solución tenemos
[X,Y] = meshgrid(x,y);
figure(1)
h1 = surf(X,Y,U);
colormap jet;
h1.EdgeColor = 'none';
xlabel('x');
ylabel('y');
zlabel('U(x,y)');
title('Solución de la ec. de Laplace');