function [y,A,b] = finite_differences(x_i,x_f,N,y0,yN,p,q,r) 
    h = (x_f-x_i)/(N+1);
    x = (x_i:h:x_f)';

    %Completar la matriz A:
    
    A = zeros(N,N);
    for i=1:N
        A(i,i) = (2+h^2*q(x(i+1)));
    end
    
    for i=1:N-1
        A(i,i+1) = -(1-(h/2)*p(x(i+1)));
        A(i+1,i) = -(1+(h/2)*p(x(i+1)));
    end
    
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
end