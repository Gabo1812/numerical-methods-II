% Tarea 3: Gabriel Alvarez Castrillo C00368
% Problema 1: Esfera entre placas paralelas, en 2D
clearvars;
V = 100;         %V potencial de las placas
epsilon_r1 = 25; % permitividad relativa esfera
epsilon_r2 = 1;  % permitividad relativa espacio
epsilon_0 = 8.85e-12;
epsilon1 = epsilon_0*epsilon_r1;
epsilon2 = epsilon_0*epsilon_r2;
%............... Creo los objetos ........................

% Note que como estamos trabajando en 2D, envés de una esfera tendriamos un
% circulo

% Posición del centro del circulo
% Vamos a hacer un circulo centrado
x0 = 0;
y0 = 0;
r = 0.03; %m radio de la esfera
C1 = [1;x0;y0;r;0;0;0;0;0;0];

%Ahora vamos a modelar las placas paralelas como un solo rectangulo
L = 0.3; % Longitud de las placas
H = 0.3; % Altura de las placas
R1 = [3;4;-L/2;L/2;L/2;-L/2;-H/2;-H/2;H/2;H/2]; %centrado

%figura = [tipo_Fig;#lados;x1;x2;x3;x4;y1;y2;y3;y4]

gd = [C1,R1];
ns = char('C1','R1'); %funciona como etiqueta
ns = ns';
sf = 'C1+R1';
[dl, bt] = decsg(gd,sf,ns); % decomposition geometry

%ploteamos la figura
figure(1);
pdegplot(dl,'EdgeLabels','on','FaceLabels','on');
axis equal

%Crea el objeto del modelo
model = createpde(); % es un objeto 
%Se ingresa la geometria 
geometryFromEdges(model,dl);
% Note que este es un problema de multidominio por lo que hay que
% configurar los coeficientes para cada subdominio por separado

%Para la esfera:
specifyCoefficients(model,'m',0,'d',0,'c',epsilon1,'a',0,'f',0,'Face',2);

%Para todo el espacio alrededor (Las dos placas):
specifyCoefficients(model,'m',0,'d',0,'c',epsilon2,'a',0,'f',0,'Face',1);

% Definir condiciones de frontera
%Aplica las condiciones de Dirchilet
% h*u = r
applyBoundaryCondition(model,"dirichlet","Edge",2,'r',V,'h',1);  % Frontera superior a 100 V
applyBoundaryCondition(model,"dirichlet","Edge",4,'r',-V,'h',1); % Frontera superior a -100 V
%Aplica condiciones de Neumann
% n*(c x nabla(u)) + q*u = g
applyBoundaryCondition(model,"neumann","Edge",[1,3],"g",0,"q",0)
%Crear la malla
mesh = generateMesh(model,Hmax=0.005); %Crea los triangulo con esa altura maxima
%Plotea la malla
figure(2)
pdemesh(model);

%Ahora para resolver la PDE
R = solvepde(model);

%...
U = R.NodalSolution; %Solución U de los nodos
%Se grafica en 2D
figure(3)
%pdeplot(mesh,XYData=U,FaceAlpha=1,ColorMap='jet',ColorBar='on',Mesh='off');
pdeplot(model, 'XYData', U, 'FaceAlpha', 1, 'ColorMap', 'jet', 'ColorBar', 'on', 'Mesh', 'off','Contour','on');

axis equal
xlabel('x(m)');
ylabel('y(m)');
title('Potencial eléctrico V')
% Extra, me apeteció sacar campo electrico
%Gradiente
Ex = -R.XGradients;
Ey = -R.YGradients;
figure(4)
pdeplot(model, 'FlowData', [Ex, Ey]);
hold on;
pdegplot(model.Geometry,FaceLabels='off',FaceAlpha=0.5);
hold off;
axis equal
xlabel('x(m)')
ylabel('y(m)')
title('Campo eléctrico E')

