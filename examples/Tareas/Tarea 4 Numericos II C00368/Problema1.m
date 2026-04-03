%Tarea 4, Gabriel Alvarez Castrillo C00368
%Problema 1:
%{
 Se tiene un disipador de aluminio, como se describe en el archivo ZD 23.stl,
 que se encuentra a una temperatura de 20◦C. Se le coloca una fuente de calor, a
 una temperatura de 100◦C, a la cara plana de mayor superficie. Si se considera
 que el disipador esta aislado, modele mediante elemento finito la difusion
 termica del disipador para ti = 0 hasta tf = 150s con un ∆t = 0,5s.
%}
clearvars;
%Se carga la geometria stl
gm = fegeometry('ZD_23.stl');
figure(1)
pdegplot(gm, FaceLabels="on",FaceAlpha=0.5);
%........... Se crea el modelo...................
model = createpde();
importGeometry(model,'ZD_23.stl');
%Se ingresan los coeficientes del problema
% En este caso, ocupamos la difusividad termica del aluminio
alpha = 0.97; % difusividad del aluminio en cm^2/s para que concuerde con el modelo en 3D
specifyCoefficients(model, 'm',0,'d',1,'c',alpha,'a',0,'f',0);
%Se aplican las condiciones de Dirichlet
T = 100; %C en la cara plana
applyBoundaryCondition(model,"dirichlet","Face",109,"r",T,"h",1);
%Se aplica Neumann
applyBoundaryCondition(model,"neumann","Face",1:108,"g",0,"q",0);
applyBoundaryCondition(model,"neumann","Face",110:182,"g",0,"q",0);

T_inicial = 20; %C
setInitialConditions(model,T_inicial);
%........ Se crea la malla.....
mesh = generateMesh(model,Hmax=5);
%Se grafica la malla
figure(2)
pdemesh(mesh,"FaceAlpha",0.2);
t = (0:0.5:150);

%Ahora resolvemos el sistema
R = solvepde(model,t);
U = R.NodalSolution;

for i=1:size(t,2)
    %Grafica en 3D la evolución temporal
    figure(3)
    pdeplot3D(mesh, "ColorMapData",R.NodalSolution(:,i),"FaceAlpha",0.7)
    axis equal
    p.AxesVisible = 'off';
    clim([0,100])
    view(180,50)% azimutal y elevación
    string = ['t = ', num2str(t(i)), ' s'];
    title(string)
    pause(1e-5) %mejorar velocidad animación
end

