%Tarea II Metodos numericos II
%Gabriel Alvarez Castrillo C00368
%Problema 1:
clearvars;
% La ecuación diferencial a resolver es ddu/dxx + ddu/dyy = 0
% Limites del dominio
xi = 0;
xf = 1;%m
yi = 0;
yf = 1;
%Partición del dominio
factor = 10;
n = factor*4; % Número de puntos en y
m = factor*4; % Número de puntos en x

h = (xf - xi) / (m - 1);
k = (yf - yi) / (n - 1);

x = (xi:h:xf)'; 
y = (yi:k:yf)'; 
% Inicialización de la matriz de solución
U = zeros(n, m);

%Para resolver la ec. Laplace 
f = @(x,y) 0;

% Aplicar condiciones de frontera
for j = 1:m
    U(j, 1) = 0;   % Condición de frontera izquierda
    U(j, n) = x(j);% Condición de frontera derecha
end
for i = 1:n
    U(1, i) = 0;   % Condición de frontera inferior
    U(m, i) = y(i);% Condición de frontera superior
end

% Coeficientes para el método numérico
alpha = 2 * (1 + (h / k)^2);
beta = (h / k)^2;

% .......... Matriz patrón con los coeficientes ..........
A = zeros(m - 2, m - 2);
for i = 1:m-2
    A(i, i) = alpha;
end
for i = 1:m-3
    A(i, i + 1) = -beta;
    A(i + 1, i) = -beta;
end
% Conforma la matriz del Problema:
C = A;
for i = 1:n-3
    C = blkdiag(C, A);% Agregar A a la matriz de bloques
end

for i = 0:size(C, 1) - (m - 1)
    C(i + 1, m - 1 + i) = -beta;
    C(m - 1 + i, i + 1) = -beta;
end

% Se crea el vector b:
b = zeros(size(C, 1), 1);
l = 0;
for i = 2:n-1
    for j = 2:m-1
        l = l + 1;
        b(l) = U(i,j) + U(i - 1, j) + U(i + 1, j) + beta * (U(i, j - 1) + U(i, j + 1))- (h^2)*f(x(j), y(i));
    end
end

% Resolver el sistema
u = C \ b;
% Rellenar la matriz U con los valores calculados
l = 0;
for i = 2:n-1
    for j = 2:m-1
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







