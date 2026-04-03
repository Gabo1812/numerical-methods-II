%Examen 3, Gabriel Alvarez Castrillo C00368
%{
Problema 1: Resuelva el potencial electrico para todo el espacio si las placas estan a los siguientes potenciales
electricos:
%}
clearvars;
%Se carga la geometria stl
gm = fegeometry('ion_canon.stl');
figure(1)
pdegplot(gm, EdgeLabels="on",FaceAlpha=0.5);
%........... Se crea el modelo...................
model = createpde();
importGeometry(model,'ion_canon.stl');
%Se ingresan los coeficientes para resolver el problema
%
epsilon_0 = 8.85e-12;
specifyCoefficients(model, 'm',0,'d',0,'c',epsilon_0,'a',0,'f',0);
%Aplica las condiciones de Dirchilet
% h*u = r
V = [100, 80, 70, 50, 20, 0]; % volts

applyBoundaryCondition(model,"dirichlet", 'Edge',[1,3,6,7], 'r',V(1),'h',1);
applyBoundaryCondition(model,"dirichlet", 'Edge',[4,5,10,11,12,13,17,21], 'r',V(2),'h',1);
applyBoundaryCondition(model,"dirichlet", 'Edge',[8,9,16,20,22,24,28,29], 'r',V(3),'h',1);
applyBoundaryCondition(model,"dirichlet", 'Edge',[15,19,23,25,27,30,32,35], 'r',V(4),'h',1);
applyBoundaryCondition(model,"dirichlet", 'Edge',[26,31,33,36,37,38,41,42], 'r',V(5),'h',1);
applyBoundaryCondition(model,"dirichlet", 'Edge',[34,39,40,43,44,46,47,48], 'r',V(6),'h',1);

%Aplica condiciones de Neumann
% n*(c x nabla(u)) + q*u = g
applyBoundaryCondition(model,"neumann","Edge",[2,14,18,45],"g",0,"q",0)

%.....Crear la malla.....
mesh = generateMesh(model,Hmax=0.6);
%Graficar la malla
figure(2)
pdemesh(mesh,'FaceAlpha',0.2);

%Resuelve el sistema model
R = solvepde(model);
U = R.NodalSolution;%solución de los nodos

% Graficar el potencial electrico
figure(3)
pdeplot(model, 'XYData', U, 'FaceAlpha', 0.7,ColorMap='jet');
title('Potencial Eléctrico');
xlabel('x (m)');
ylabel('y (m)');
colorbar;

%Gradiente
Ex = -R.XGradients;
Ey = -R.YGradients;
figure(4)
pdeplot(mesh,FlowData=[Ex,Ey]);
hold on;
pdegplot(gm,FaceLabels='off',FaceAlpha=0.5);
hold off;
axis equal
xlabel('x(m)')
ylabel('y(m)')
title('Campo Electrico');
