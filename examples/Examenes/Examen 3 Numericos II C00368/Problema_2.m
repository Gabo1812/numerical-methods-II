%Examen 3, Gabriel Alvarez Castrillo C00368
%Problema 2:  Se tiene una membrana circular conformada por dos tipos de materiales
%{
Realice una simulacion por elemento finito de la propagacion de una onda en esta membrana compuesta
por dos medios de rapidez de propagacion distintas. Coloque la perturbacion en el punto P,
como fue vista en clase. Considere la condicion de Dirichlet en el borde externo de la membrana.
%}
clearvars;
%Se crea la geometria:
R1 = 0.08;%m
R2 = 0.03;%m
x0 = 0.0;%m
y0 = 0.0;%m
C1 = [1;x0;y0;R1;0;0;0;0;0;0];
C2 = [1;x0;y0;R2;0;0;0;0;0;0];

%----------------------------------------------
gd = [C1,C2];
ns = char('C1','C2');
ns = ns';
sf = 'C1+C2';
[dl,bt] = decsg(gd,sf,ns);
%------------------------------------------------
%..... Grafica de la composición.......
%Si hace falta se puede descomentar para ver las Faces y Edges necesarias

figure(1);
pdegplot(dl,'EdgeLabels','on','FaceLabels','on');
axis equal

% crear le objeto del modelo 
model = createpde();
geometryFromEdges(model,dl);
% ec a resolver
% m*d^2U/dt^2 + d*dU/dt - Nabla.(c*Nabla U) + aU = f
% Coeficientes para las dos regiones
alpha1 = 1; % m/s
alpha2 = 0.5; % m/s
specifyCoefficients(model, 'm', 1, 'd', 0, 'c', alpha1^2, 'a', 0, 'f', 0, 'Face', 1);
specifyCoefficients(model, 'm', 1, 'd', 0, 'c', alpha2^2, 'a', 0, 'f', 0, 'Face', 2);
% Aplicar condiciones de Dirichlet(circulo externo)
applyBoundaryCondition(model,'dirichlet','Edge',1:4,'r',0,'h',1);
% Aplicar condiciones de Neumann(circulo interno)
applyBoundaryCondition(model,"neumann","Edge",5:8,"g",0,"q",0)

%Perturbación Inicial
a = -0.05;
b = 1e-5;
xp = 0.04;
u0 = @(location) a*exp((-(location.x-xp).^2-(location.y).^2)/b);
du0 = @(location) 0*(location.x+location.y);

setInitialConditions(model,u0,du0);

% Crear la malla
mesh = generateMesh(model,Hmax=0.005);
%graficar el mesh y ver la calidad
figure(2);
pdemesh(model,"FaceAlpha",0.2);
% Resolver el sistema model y crear un objeto con la solucion

t = (0:0.01:0.75);
R = solvepde(model,t);
u = R.NodalSolution;

% graficar la solucion en 3D
umax = max(max(u));
umin = min(min(u));
for i=1:size(t,2)
    figure(3);
    pdeplot(mesh,XYData=u(:,i),ZData=u(:,i),ZStyle='continuous',Mesh='off', ColorMap='winter');
    string = ['t =', num2str(t(i)),'s'];
    title(string);
    axis equal
    xlabel('x(m)');
    ylabel('y(m)');
    zlabel('z(m)');
    zlim([-0.01 0.02]);
    clim([-0.01, 0.01]);
    pause(0.001) %mejorar velocidad animación
end
