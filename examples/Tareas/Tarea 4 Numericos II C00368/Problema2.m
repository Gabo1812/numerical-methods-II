%Tarea 4, Gabriel Alvarez Castrillo C00368
%Problema 2:
%{
Simule la propagacion de una onda, mediante elemento finito, en toda la 
extension de la geometrıa considerando todos los bordes con condicion de 
Dirichlet a cero para una rapidez de la onda de 1,0m/s. 
La perturbacion o condicion inicial en t0 = 0 utilice la perturbacion 
gaussiana vista en clase, colocada adecuadamente.
%}
clearvars;
%-----------------------------------------------
%Se crea la geometria:
R = 0.005;%m
x0 = 0.0;%m
y0 = 0.0;%m
d = 0.025;
C1 = [1;x0;y0+4*d;R;0;0;0;0;0;0];
C2 = [1;x0;y0+2*d;R;0;0;0;0;0;0];
C3 = [1;x0;y0;R;0;0;0;0;0;0];
C4 = [1;x0;y0-2*d;R;0;0;0;0;0;0];
C5 = [1;x0;y0-4*d;R;0;0;0;0;0;0];
%Rectangulo 1:
L = 0.50;%m
H = 0.30;%m
R1 = [3;4;-L/2;L/2;L/2;-L/2;-H/2;-H/2;H/2;H/2];
%----------------------------------------------
gd = [C1,C2,C3,C4,C5,R1];
ns = char('C1','C2','C3','C4','C5','R1');
ns = ns';
sf = 'R1-(C1+C2+C3+C4+C5)';
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
alpha = 1; % m/s rapidez de la onda en ese medio 
% coeficientes de dominio 
specifyCoefficients(model,'m',1,'d',0,'c',alpha^2, 'a',0,'f',0,'Face',1);
% Aplicar condiciones de Dirichlet
applyBoundaryCondition(model,'dirichlet','Edge',1:24,'r',0,'h',1);

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
    pause(0.001) %mejorar velocidad animación
end
%Se puede ver como la onda que pasa por el agujero se refleja en los bordes
% Y modifica el frente de onda circular por interferencia destructiva

