%Examen 3, Gabriel Alvarez Castrillo C00368
%{
Problema 3: configuracion en forma de barra, conformada
por dos piezas de cobre y un material diferente en medio de estas
Si el cobre tiene una constante de difusividad termica
de 111 × 10−3 mm2/s y tambien se considera que el material situado en medio es
hierro, con una constante de difusividad t´ermica de 23 ×10−3 mm2/s. Realice una
modelizacion, por el metodo de elemento finito, de la difusion termica si toda la
barra se encuentra a una temperatura inicial de 20 ◦C y se coloca en contacto con
una fuente a una temperatura de 300 ◦C en una de sus caras axiales. Considere que
toda la barra esta aislada y utilice para t = (0 : 100 : 20000); y Hmax = 3 para
generar el mesh, como recomendacion para que no quede pesada la simulacion.
%}
clearvars;
%------------------------------------------------
%Se crea la geometria :
%gm = multicylinder(10,[50 15 50],ZOffset=[-50 0 15]); %en teoria estan mm
gm = multicylinder(10,[50 15 50],ZOffset=[(-50-15/2) -15/2 15/2]); %en
%teoria estan mm, otra forma con el segundo cilindro centrado
%------------------------------------------------
figure(1)
pdegplot(gm, CellLabels="on",FaceLabels="on",FaceAlpha=0.5);
axis equal

% crear le objeto del modelo 
model = createpde();
model.Geometry = gm;

%Se ingresan los coeficientes del problema
% En este caso, ocupamos la difusividad termica del aluminio
alpha1 = 111e-3; % difusividad del cobre  en mm^2/s 
alpha2 = 23e-3;  % difusividad del hierro en mm^2/s 

specifyCoefficients(model, 'm',0,'d',1,'c',alpha1,'a',0,'f',0, 'Cell', [1,3]);
specifyCoefficients(model, 'm',0,'d',1,'c',alpha2,'a',0,'f',0, 'Cell', 2);

%Se aplican las condiciones de Dirichlet
T = 300; %C en la cara axial de abajo
applyBoundaryCondition(model,"dirichlet","Face",1,"r",T,"h",1);
%Se aplica Neumann
applyBoundaryCondition(model,"neumann","Face",2:7,"g",0,"q",0);

T_inicial = 20; %C
setInitialConditions(model,T_inicial);
%........ Se crea la malla.....
mesh = generateMesh(model,Hmax=3);
%Se grafica la malla
figure(2)
pdemesh(mesh,"FaceAlpha",0.2);
t = (0 : 100 : 20000);
%Nota se calienta por completo en t>100 000 s, por lo que lo dejaremos como
%en el enunciado hasta 20 000
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
    clim([0,300])
    string = ['t = ', num2str(t(i)), ' s'];
    title(string)
    pause(1e-3) %mejorar velocidad animación
end

