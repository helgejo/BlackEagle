close all
clear all

set(0,'DefaultFigureUnits','normalized');
figure('Position',[0.1 0.1 0.8 0.8]);
spill = input('Spill y/n: ','s');
while spill~='n';
    v=0;
    axis([0,100,0,80]);
    while v<=pi/2
        c=10; % kanonlengde
        x=c*cos(v);
        y=c*sin(v);

        plot([0,x],[0,y]);
        plot([0,x],[0,y]);
        drawnow;
        v=v+0.01;
    end
    while v>=0
        c=10; % kanonlengde
        x=c*cos(v);
        y=c*sin(v);

        plot([0,x],[0,y]);
        drawnow;
        v=v-0.01;
    end
    spill = input('En gang til? (y/n) ','s');
end