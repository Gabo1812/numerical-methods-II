%Tarea II Metodos numericos II
%Gabriel Alvarez Castrillo C00368
%Problema 4:
clearvars;

% Limites del dominio
L = 0.25;%m
xi = 0;
xf = L; 
ti = 0;
tf = 40;

% Particiones
n = 1000;
m = 500;

h = (xf-xi)/n;
k = (tf-ti)/m;

x = (xi:h:xf)';
t = (ti:k:tf)';
%Difusividad térmica
a  = 97e-6;
% Condiciones de frontera de Neumann 
c1 = 0; %en i = 1
c2 = 0; %en i = n+1
%.............Coeficientes de la Matriz
r = a*k/h^2;

% Llenar la matriz
A = zeros(n-1,n-1);

for i=1:n-1
    A(i,i) = (1+2*r);
end

for i=1:n-2
    A(i,i+1) = -r;
    A(i+1,i) = -r;
end
A(1,2) = -2*r;
A(n-1,n-2) = -2*r;
% Se invierte la matriz
B = inv(A);
% Condición inicial
T0 = 0*zeros(size(x,1)-2,1);
for i=1:size(T0,1)
   T0(i) = 150*sin(pi/0.25 * x(i));
end
Txi = 0;
Txf = 0;
q = @(x) 0;
% Resolver para cada paso temporal
Tt = T0;
for j=1:m
  
   Tt = Tt + k*q(x(2:end-1));
   T = B*Tt;
   Txi = T(1) + 2*h*c1;
   Txf = T(end) + 2*h*c2;
   area(x,[Txi;T;Txf],'FaceColor','r')
   ylim([0 150])
   str = ['t = ', num2str(t(j)), 's'];
   text(0.06,95,str)
   Tt = T;
   pause(0)
end

