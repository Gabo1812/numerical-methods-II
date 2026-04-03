%Tarea 1 Numericos II
% José Gabriel Alvarez Castrillo C00368
% Problema 2:
clearvars;
N = 3000;
tol = 1e-11;
x_i = pi/4 ;
x_f = pi/3;
y0 = (1/2)^(1/4); %y(pi/4)
yN = ( (12)^(1/4) ) / 2; %y(pi/3)
h = (x_f-x_i)/(N+1);
x = (x_i:h:x_f)';

% Sea y'' = -2*sec(x)*(y')^3 - (y^2)*sec(x)*y' 
f = @(x,y,yp) -2.*sec(x).*yp.^3 - (y.^2).*sec(x).*yp;
%Derivadas
%Respecto a y
fy = @(x,y,yp) -2.*sec(x).*y.*yp;
%Respecto a y'
fyp = @(x,y,yp) -6.*sec(x).*yp.^2 -sec(x).*y.^2;

%Metodo de Newton-Raphson ====> vect(J)*v = vect(F)

%................................................
% Se crea la matriz Jacobiana, F y y
%................................................
J = zeros(N,N);
F = zeros(N,1);
y = 0.85*ones(N,1);

%................................
% Para llenar la matriz Jacobiana
%................................

% Método de Newton-Raphson
for k = 1:500% a conveniencia, depende de la tol
    % Construcción de la matriz Jacobiana
    J(1,1) = 2 + h^2 * fy(x(2), y(2), (y(2) - y0) / (2*h) ); % para i == 1
    for i = 2:N-1
        % Llena la diagonal principal
     J(i,i) = 2 + h^2 * fy(x(i+1), y(i+1), (y(i+1) - y(i-1)) / (2*h) ); %para i = i   
    end
    J(N,N) = 2 + h^2 * fy(x(N+1), yN, (yN - y(N-1)) / (2*h) ); % para i == N


    J(1,2) = -1 + (h/2) * fyp(x(2), y(2), (y(2) - y0) / (2*h)); % para i == 1
    J(2,1) = -1 - (h/2) * fyp(x(2), y(2), (y(2) - y0) / (2*h)); % para i == 1
    for i = 2:N-2 
    % Llena la diagonal superior 
    J(i,i+1) = -1 + (h/2) * fyp(x(i+1), y(i+1), (y(i+1) - y(i-1)) / (2*h));
    % Llena la diagonal inferior 
    J(i+1,i) = -1 - (h/2) * fyp(x(i+1), y(i+1), (y(i+1) - y(i-1)) / (2*h)); 
    end    
    J(N-1,N) = -1 + (h/2) * fyp(x(N+1), y(N), (yN - y(N-1)) / (2*h)); % para i == N
    J(N,N-1) = -1 - (h/2) * fyp(x(N+1), y(N), (yN - y(N-1)) / (2*h)); % para i == N
%...............................
% Ahora se llena el vector F
%...............................
    F(1) = -y0 + 2*y(1) - y(2) + h^2 * f(x(1), y(1), (y(2) - y0)/(2*h));
    for i = 2:N-1
        F(i) = -y(i-1) + 2*y(i) - y(i+1) + h^2 * f(x(i), y(i), (y(i+1) - y(i-1)) / (2*h));
    end
    F(N) = -y(N-1) + 2*y(N) -yN  + h^2 * f(x(N), y(N), (yN - y(N-1)) / (2*h));

    % Resolver el sistema lineal
    v = J\(-F);
    y = y + v;
    % Criterio de parada
    if norm(v)<=tol
        break;
    end
    yt = [y0;y;yN];
    pause(1)
end
figure(1);
plot(x,yt,'ob')
ylabel('y(x)');
xlabel('x')
