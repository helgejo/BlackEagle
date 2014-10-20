close all
clear all

set(0,'DefaultFigureUnits','normalized');
figure('Position',[0.1 0.1 0.8 0.8]);
v=0;
g=-9.81;
while v>=0 && v<=pi/2
    v=input('Tast inn vinkel: '); %vinkel
    clf;
    f=100; % startfart i m/s
    v0x=f*cos(v);
    v0y=f*sin(v);
    t=-(2*v0y/g);
    tid=0:0.1:t;
    tid(end+1)=t;
    x=v0x.*tid;
    y=v0y.*tid+0.5*g.*tid.^2;
    for i=2:length(x)
        plot([x(i-1) x(i)],[y(i-1) y(i)]);
        axis([0 1050 0 550]);
        drawnow;
        pause(0.01);
    end
    disp(['Skudd ble ' num2str(x(end)) 'm og nådde en høyde på ' num2str(max(y)) 'm']);
    
    
%     x(end+1)=f*cos(v)*0.1;
%     fy=[f*sin(v)*0.1];
%     fy(end+1)=fy(end)-0.981;
%     y(end+1)=y(end)+fy(end);
%     while y(end) > 0
%         x(end+1)=x(end)+x(2);
%         fy(end+1)=fy(end)-9.81;
%         y(end+1)=y(end)+fy(end);
%         drawnow;
%     end
%     axis([0,max(x)+20,0,max(y)+20]);
%     disp(['Skudd ble ' num2str(x(end)) 'm og nådde en høyde på ' num2str(max(y)) 'm']);
end