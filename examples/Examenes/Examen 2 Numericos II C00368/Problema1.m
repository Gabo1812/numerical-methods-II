% Examen II Metodos numericos II
% Gabriel Alvarez Castrillo C00368
% Problema 1:
clearvars;
% Limites del dominio
xi = 0;
xf = 0.15; %m
yi = 0;
yf = 0.05;

% Partición del dominio
factor = 10;
m = factor * 15; % Número de puntos en x
n = factor * 5;  % Número de puntos en y

h = (xf - xi) /m;
k = (yf - yi) /n;

x = (xi:h:xf)'; 
y = (yi:k:yf)'; 
% Constantes físicas
sigma = 1.5e-6;
epsilon_0 = 8.85e-12;
% Para resolver la ec. Poisson con f(x,y) 
f = @(x,y) -sigma/epsilon_0;

% Inicialización de la matriz de solución
U = zeros(n+1, m+1);  

% Condiciones de frontera
U(:,1)     = 0;  % Condición de frontera izquierda U(x,0)     
U(:,m+1)   = 0;  % Condición de frontera derecha U(x,yf)      
U(1,1:m+1) = 0;  % Condición de frontera inferior U(0,y)
U(n+1,2:m) = 0;  % Condición de frontera superior U(xf,y)

% spy(U); Para ver la formación correcta de U

beta = (h/k)^2;
alpha = 2 * (1 + (h/k)^2);

% ..........Matriz patrón con los coeficientes..........
A = zeros(m-1,m-1);  
for i = 1:m-1
    A(i,i) = alpha;
end
for i = 1:m-2
    A(i,i+1) = -beta;
    A(i+1,i) = -beta;
end

% Conforma la matriz del Problema:
C = A;
for i = 1:n-2  
    C = blkdiag(C,A);% Agregar A a la matriz de bloques
end

for i = 0:size(C,1)-m
    C(m+i,i+1) = -beta;
    C(i+1,m+i) = -beta;
end

% Se crea el vector b:
b = zeros(size(C,1),1);
l = 0;
for i = 2:n  
    for j = 2:m  
        l = l + 1;
        b(l) = U(i-1,j) + U(i+1,j) + beta*(U(i,j-1) + U(i,j+1)) - h^2 * f(x(j), y(i));
    end
end

% Resolver el sistema
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





