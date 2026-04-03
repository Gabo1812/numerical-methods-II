%Codigo Hecho  por Gabriel Alvarez 
%{
       _,    _   _    ,_
  .o888P     Y8o8Y     Y888o.
 d88888      88888      88888b
d888888b_  _d88888b_  _d888888b
8888888888888888888888888888888
8888888888888888888888888888888
YJGS8P"Y888P"Y888P"Y888P"Y8888P
 Y888   '8'   Y8P   '8'   888Y
  '8o          V          o8'
    `                     `
%}

% Si queremos guardar una grafica dinamica, tenemos dos formatos.
% Pero ambos comparten que el codigo va dentro de los ciclos for
% Para guardar en GIF
    % Realmente hay dos formas:
    % Forma 1) Usando 
    % exportgraphics(gcf, 'ejemplo.gif', 'Append', true);
    % Probablemente propia de elemento finito, y tarda mucho en guardar 
    % cada fotograma de la animación

    % Forma 2) Usando
    %{
    % Captura y guarda el fotograma en el GIF
    [imind, cm] = rgb2ind(frame2im(getframe(gcf)), 256);
    if i == 1
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'overwrite', 'DelayTime', 0.01, 'LoopCount', Inf);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.01);
    end
    %}
    % Son más lineas de codigo pero es más rapida en guardar

% Para guardar en video mp4

%Antes del for ponemos:
%{
filename = 'ejemplo.mp4';
v = VideoWriter(filename, 'MPEG-4'); 
v.FrameRate = 30; 
open(v); 
%}
%En el for ponemos:
%{

% Captura y guarda el fotograma en el video
    frame = getframe(gcf); % Captura el contenido de la figura
    writeVideo(v, frame); % Escribe el fotograma en el video

%}
%Despues del for ponemos:
%{
close(v); 
disp(['Video guardado como ', filename]);
%}