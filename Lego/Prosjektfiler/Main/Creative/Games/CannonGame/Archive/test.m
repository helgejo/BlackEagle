close all
clear all

set(0,'DefaultFigureUnits','normalized');
figure('Position',[0.1 0.1 0.8 0.8]);
v=0;
while v>=0 && v<=pi/2
    v=input('Tast inn vinkel: '); %vinkel
    c=10; % kanonlengde
    x=c*cos(v);
    y=c*sin(v);

    plot([0,x],[0,y]);
    axis([0,100,0,80]);
    drawnow;
end
