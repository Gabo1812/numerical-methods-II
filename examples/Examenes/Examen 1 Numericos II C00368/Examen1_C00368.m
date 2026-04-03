%Examen I metodos numericos 
%Gabriel Alvarez Castrillo C00368
%Problema 1:
% Sea la ecuación diferencial a resolver
% y'' = (2/7)*y' + (1/7)*y - (1/7)x
N = 1000;
%........Condiciones de Frontera....
x_i = 0;
x_f = 20;
h = (x_f-x_i)/(N+1);
x = (x_i:h:x_f)';
y0 = 5; %y(0)
yN = 8; %y(20)

% Donde:

p = @(x) 2/7; % es lo que acompanaña a y'
q = @(x) 1/7; % es lo que acompanaña a y
r = @(x) - x/7; % termino sin y

%La solución mediante diferencias finitas es la siguiente: (ver función)

yt = finite_differences(x_i,x_f,N,y0,yN,p,q,r);
figure(1)
plot(x,yt,'or')
title('Solución por diferencias finitas')
ylabel('y(x)');
xlabel('x')
%......................................................................

%Problema 2:
% Sea la ecuación diferencial a resolver
% y'' = y + x
% Donde:

p = @(x) 0; % es lo que acompanaña a y'
q = @(x) 1; % es lo que acompanaña a y
r = @(x) x; % termino sin y

%........Condiciones de Frontera....
x_i = 0;
x_f = 1;
h = (x_f-x_i)/(N+1);
x = (x_i:h:x_f)';
y0 = 0; %y(0)
yN = 1; %y(1)


%La solución mediante diferencias finitas es la siguiente: (ver función)

yt2 = finite_differences(x_i,x_f,N,y0,yN,p,q,r);
figure(2)
plot(x,yt2,'ob')
title('Solución por diferencias finitas')
ylabel('y(x)');
xlabel('x')

%......................................................................

%Problema 3:
% Sea la ecuación diferencial a resolver
% y'' = -(1+x^2)y - 1
% Donde:

p = @(x) 0; % es lo que acompanaña a y'
q = @(x) -(1+x^2); % es lo que acompanaña a y
r = @(x) -1; % termino sin y

%........Condiciones de Frontera....
x_i = -1;
x_f = 1;
h = (x_f-x_i)/(N+1);
x = (x_i:h:x_f)';
y0 = 0; %y(-1)
yN = 0; %y(1)


%La solución mediante diferencias finitas es la siguiente: (ver función)

yt3 = finite_differences(x_i,x_f,N,y0,yN,p,q,r);
figure(3)
plot(x,yt3,'og')
title('Solución por diferencias finitas')
ylabel('y(x)');
xlabel('x')

%......................................................................

%Problema 4:
% Sea la ecuación diferencial a resolver
% y'' = (-1/x)*y' -(x^2 - 1)y/x^2
% Donde:

p = @(x) -1/x; % es lo que acompanaña a y'
q = @(x) -(x^2 - 1)/x^2; % es lo que acompanaña a y
r = @(x) 0; % termino sin y

%........Condiciones de Frontera....
x_i = 1;
x_f = 2;
h = (x_f-x_i)/(N+1);
x = (x_i:h:x_f)';
y0 = 1; %y(1)
yN = 2; %y(2)


%La solución mediante diferencias finitas es la siguiente: (ver función)

yt4 = finite_differences(x_i,x_f,N,y0,yN,p,q,r);
figure(4)
plot(x,yt4,'om')
title('Solución por diferencias finitas')
ylabel('y(x)');
xlabel('x')