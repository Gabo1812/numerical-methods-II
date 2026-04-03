clearvars;
%Se carga la geometria stl
gm = fegeometry('CapacitorPavo.stl');
figure(1)
pdegplot(gm, FaceLabels="off",EdgeLabels="off",FaceAlpha=0.5);
%........... Se crea el modelo...................
model = createpde();
importGeometry(model,'CapacitorPavo.stl');%en milimetros

%........ Se crea la malla.....
mesh = generateMesh(model,Hmax=25);
%Se grafica la malla
figure(2)
pdemesh(mesh,"FaceAlpha",0.2);