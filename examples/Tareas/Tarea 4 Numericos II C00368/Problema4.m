%Tarea 4, Gabriel Alvarez Castrillo C00368
%Problema 4:

%{
Con el archivo Twist Cup.STL, realize una simulacion de diffusion termica.
Fije la constante de diffusividad termica del material de preferencia 
y la condicion inicial de temperatura.
%}
clearvars;
%Se carga la geometria stl
gm = fegeometry('Twist_Cup.STL');
figure(1)
pdegplot(gm, FaceLabels="on",FaceAlpha=0.5);
%........... Se crea el modelo...................
model = createpde();
importGeometry(model,'Twist_Cup.STL');
%Se ingresan los coeficientes del problema
% En este caso, ocupamos la difusividad termica del aluminio
alpha = 97; % difusividad del aluminio en mm^2/s para que concuerde con el modelo en 3D
specifyCoefficients(model, 'm',0,'d',1,'c',alpha,'a',0,'f',0);

%Se aplican las condiciones de Dirichlet
T = 100; %C en la cara plana
applyBoundaryCondition(model,"dirichlet","Face",1,"r",T,"h",1);
%Se aplica Neumann
applyBoundaryCondition(model,"neumann","Face",[2,3],"g",0,"q",0);

T_inicial = 20; %C
setInitialConditions(model,T_inicial);
%........ Se crea la malla.....
mesh = generateMesh(model,Hmax=10);
%Se grafica la malla
figure(2)
pdemesh(mesh,"FaceAlpha",0.2);
t = (0:0.5:100);

%Ahora resolvemos el sistema
R = solvepde(model,t);
U = R.NodalSolution;
for i=1:size(t,2)
    %Grafica en 3D la evolución temporal
    figure(3)
    pdeplot3D(mesh, "ColorMapData",R.NodalSolution(:,i),"FaceAlpha",0.7)
    axis equal
    xlabel('x(m)')
    ylabel('y(m)')
    zlabel('z(m)')
    clim([0,100])
    string = ['t = ', num2str(t(i)), ' s'];
    title(string)
    pause(1e-2) %mejorar velocidad animación
end
