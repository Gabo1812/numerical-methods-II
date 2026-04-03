%Tarea 1 Numericos II
% José Gabriel Alvarez Castrillo C00368
% Problema 1:

clearvars;
N = 1000;
%..................................
%     Condiciones de frontera
%..................................
a = 2;
b = 3;
h = (b-a)/(N+1);
x = (a:h:b)';
y0 = 0; %y(2)
yN = 0; %y(3)

% Sea la siguiente ecuación diferencial a resolver: x^2 y'' - 2y + x = 0
% Exprandola de esta forma y'' = (2*y)/x^2 - 1/x
% Donde:

p = @(x) 0; % es lo que acompanaña a y'
q = @(x) 2/x^2; % es lo que acompanaña a y
r = @(x) - 1/x; % termino sin y

% a) Deduzca la matriz general por diferencias finitas especifica, para la ecuacion
% diferencial dada considerando una particion h.

%Completar la matriz A:

A = zeros(N,N);
for i=1:N
    A(i,i) = (2+h^2*q(x(i+1))); % diagonal principal
end

for i=1:N-1
    A(i,i+1) = -(1-(h/2)*p(x(i+1))); % diagonal superior
    A(i+1,i) = -(1+(h/2)*p(x(i+1))); % diagonal inferior
end

% b) Escriba el sistema matricial general Ay = b a resolver para el problema de
% frontera en un intervalo [a, b] donde y(a) = α y y(b) = β.

%Completar el vector b
b = zeros(N,1);
b(1) = (1+(h/2)*p(x(2)))*y0-h^2*r(x(2));

for i=2:N-1
    b(i) = -h^2*r(x(i+1));
end

b(N) = (1-(h/2)*p(x(N+1)))*yN-h^2*r(x(N+1));

%Resolver el sistema A*y = b
y = A\b;
y = [y0;y;yN]; %Para incluir las condiciones iniciales
figure(1)
plot(x,y,'or')
ylabel('y(x)');
xlabel('x')
