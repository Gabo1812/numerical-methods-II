% Tarea 3: Gabriel Alvarez Castrillo C00368
% Problema 4: Esfera y plano, en 3D
clearvars;
Ve = 100; %V potencial de la esfera
Vp = 75; %V potencial del plano
epsilon_r1 = 1; % permitividad relativa espacio
epsilon_0 = 8.85e-12;
epsilon1 = epsilon_0*epsilon_r1;
%.............Se carga la geometria stl...............
gm = fegeometry("plate_sphere_3D.stl");
figure(1)
pdegplot(gm, FaceLabels="on",FaceAlpha=0.5);
%..........Crea el objeto del modelo.........
model = createpde();
importGeometry(model,'plate_sphere_3D.stl');
%............

%Se ingresan los coeficientes para resolver el problema
%Para todo el espacio alrededor :
specifyCoefficients(model,'m',0,'d',0,'c',epsilon1,'a',0,'f',0);
%Aplica las condiciones de Dirchilet
% h*u = r
applyBoundaryCondition(model,"dirichlet", 'Face',7:12, 'r',Vp,'h',1);
applyBoundaryCondition(model,"dirichlet", 'Face',13, 'r',Ve,'h',1);
%Aplica condiciones de Neumann
% n*(c x nabla(u)) + q*u = g
applyBoundaryCondition(model,"neumann","Face",1:6,"g",0,"q",0)
%.....Crear la malla.....
mesh = generateMesh(model,Hmax=15); % Si no le sirve Hmax=15, probar con=20
%Graficar la malla
figure(2)
pdemesh(mesh,'FaceAlpha',0.2);

%Resuelve el sistema model
R = solvepde(model);
U = R.NodalSolution;%solución de los nodos

%Graficar en 3D
figure(3)
pdeplot3D(mesh, ColorMapData=U,FaceAlpha=0.7);
axis equal
xlabel('x(m)')
ylabel('y(m)')
zlabel('z(m)')
title('Potencial eléctrico V')
% Extra, me apeteció sacar campo electrico
%Gradiente
Ex = -R.XGradients;
Ey = -R.YGradients;
Ez = -R.ZGradients;
figure(4)
pdeplot3D(mesh,FlowData=[Ex,Ey,Ez]);
hold on;
pdegplot(gm,FaceLabels='off',FaceAlpha=0.5);
hold off;
axis equal
xlabel('x(m)')
ylabel('y(m)')
zlabel('z(m)')
title('Campo eléctrico E')