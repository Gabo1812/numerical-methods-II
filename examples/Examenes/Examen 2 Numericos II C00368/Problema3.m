% Examen II Metodos numericos II
% Gabriel Alvarez Castrillo C00368
% Problema 3:
clearvars;
% Limites del dominio
xi = 0;
xf = 0.15; %m
yi = 0;
yf = 0.05;
% Partición del dominio
factor = 10;
n = factor*5; % Número de puntos en x
m = factor*15;  % Número de puntos en y

h = (xf-xi)/m;
k = (yf-yi)/n;

x = (xi:h:xf)'; 
y = (yi:k:yf)'; 
% Constantes físicas
sigma = 0;
epsilon_0 = 8.85e-12;
%Para resolver la ec. Laplace 
f = @(x,y) -sigma/epsilon_0;

% Inicialización de la matriz de solución
U = zeros(n+1, m+1);  

% Condiciones de frontera de Dirichlet
for i = 1 : n+1
   U(n+2-i,1) = 200*sin((pi/0.05)*y(i));
   U(n+2-i,end) = -200*sin((pi/0.05)*y(i));
end

% Coeficientes para el método numérico
beta = (h/k)^2;
alpha = 2 * (1 + (h/k)^2);
% .......... Matriz patrón con los coeficientes ..........
A = zeros(m-1,m-1); 
for i = 1:m-1
    A(i, i) = alpha; % Diagonal principal
end
for i = 1:m - 2
    A(i, i + 1) = -beta; % Diagonal superior
    A(i + 1, i) = -beta; % Diagonal inferior
end

% Conforma la matriz del Problema:
C = A; 
for i = 1:n
    C = blkdiag(C, A); % Agregar A a la matriz de bloques
end

% Ajustar la matriz C para las condiciones de Neumann
for i = 0:size(C, 1) - m
    C(m + i, i + 1) = -beta; 
    C(i + 1, m + i) = -beta;
end

% Condiciones de Neumann (derivada normal cero)
for i = 0 : m-2
   C(i+1,m+i) = -2*beta;
end
for i = size(C,1) - size(A,1): size(C,1) - m
   C(m+i,i+1) = -2*beta;
end

% Se crea el vector b:
b = zeros(size(C,1),1);
% Los llena por filas de los puntos a encontra:
l = 0;
for i = 1 : n+1
   for j = 2 : m
       l = l + 1;
       if i == 1
           b(l) = U(i+1,j) + beta*(U(i,j-1) + U(i,j+1));
       elseif i == n + 1
           b(l) = U(i-1,j) + beta*(U(i,j-1) + U(i,j+1));
       else
           b(l) = U(i-1,j) + U(i+1,j) + beta*(U(i,j-1) + U(i,j+1));
       end
      
   end
end

% Resolver el sistema
u = C \ b;
% Rellenar la matriz U con los valores calculados
l = 0;
for i = 1 : n+1
   for j = 2 : m
       l = l + 1;
       U(i,j) = u(l);
   end
end

% Graficando la solución
[X,Y] = meshgrid(x,y);

figure(1)
h1 = surf(X,Y,U);
colormap jet;
h1.EdgeColor = 'none';
xlabel('x');
ylabel('y');
zlabel('U(x,y)');
title('Solución de la ec. de Laplace');  
