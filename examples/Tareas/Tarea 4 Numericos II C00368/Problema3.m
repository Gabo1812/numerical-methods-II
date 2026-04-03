%Tarea 4, Gabriel Alvarez Castrillo C00368
%Problema 3:

%{
Modifique la geometria del Problema 3, eliminando los objetos circulares, 
con las mismas condiciones de frontera.
%}
clearvars;
%-----------------------------------------------
%Se crea la geometria:
x0 = 0.0;%m
y0 = 0.0;%m
%Rectangulo 1:
L = 0.50;%m
H = 0.30;%m
R1 = [3;4;-L/2;L/2;L/2;-L/2;-H/2;-H/2;H/2;H/2];
%----------------------------------------------
gd = R1;
ns = char('R1');
ns = ns';
sf = 'R1';
[dl,bt] = decsg(gd,sf,ns);
%------------------------------------------------
%..... Grafica de la composición.......
%Si hace falta se puede descomentar para ver las Faces y Edges necesarias
%{
figure(1);
pdegplot(dl,'EdgeLabels','on','FaceLabels','on');
axis equal
%}
% crear le objeto del modelo 
model = createpde();
geometryFromEdges(model,dl);
% ec a resolver
% m*d^2U/dt^2 + d*dU/dt - Nabla.(c*Nabla U) + aU = f
alpha = 1; % rapidez de la onda en ese medio 
% coeficientes de dominio 
specifyCoefficients(model,'m',1,'d',0,'c',alpha^2, 'a',0,'f',0,'Face',1);
% Aplicar condiciones de Dirichlet
applyBoundaryCondition(model,'dirichlet','Edge',1:4,'r',0,'h',1);

a = -0.05;
b = 1e-5;
xp = 0.04;
u0 = @(location) a*exp((-(location.x-xp).^2-(location.y).^2)/b);
du0 = @(location) 0*(location.x+location.y);

setInitialConditions(model,u0,du0);

% Crear la malla
mesh = generateMesh(model,Hmax=0.02);

%graficar el mesh y ver la calidad
figure(2);
pdemesh(model,"FaceAlpha",0.2);

% Resolver el sistema model y crear un objeto con la solucion

t = (0:0.01:0.60);
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
    pause(0.001); %mejorar velocidad animación
end
%A diferencia del problema anterior, se puede ver que como no hay agujeros
%la onda se mueve libremente formando ondas circulares hasta que llega a
%los bordes y se reflejan y cancelan por interferencia
