function [yt,x,J,F] = Newton_Raphson_diff_finites(x_i,x_f,y0,yN,f,fy,fyp,N,tol)
h = (x_f-x_i)/(N+1);
x = (x_i:h:x_f)';

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
for k = 1:100
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
end