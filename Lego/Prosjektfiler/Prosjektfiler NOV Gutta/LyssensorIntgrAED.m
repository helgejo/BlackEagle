%%
% Lyssensor.m
%
% Lyssensor bla bla 


%% Initialiserer NXT
COM_CloseNXT all                % lukker alle NXT-håndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % etablerer nytt håndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-håndtak

%%
%Lyssensor
clf
OpenLight(SENSOR_3,'ACTIVE');  % Spesifiserer ACTIVE eller DEACTIVE
Run = true ;
time=clock;
nullpunkt = 1023/2;
tid=[time(end-2).*3600+time(end-1).*60+time(end)];
avvik=[0];
y=[0];
light = [0];
npv = [nullpunkt];
while Run
    time=clock;
    tid(end+1)=time(end-2).*3600+time(end-1).*60+time(end);
    deltaT = tid(end)-tid(end-1);
    light(end+1)= GetLight(SENSOR_3);
    y(end+1) =  light(end)- nullpunkt;    % Gir verdi mellom 0 og 1023 tilsvarende mørkt og lyst
    npv(end+1) = nullpunkt;
    % avvik(end+1)= abs(y(end).* deltaT)+ avvik(end);
    avvik(end+1) = y(end).*deltaT + avvik(end);
    subplot (3,1,1)
    plot (tid,light, tid,npv)
    title ('Lysverdi fra sensor inkl. nullpunkt')
    subplot (3,1,2)
    plot(tid,y)
    title ('avvik omkring nullpunkt')
    xlabel ('tid')
    ylabel ('avvik fra 0')
    subplot (3,1,3)
    plot (tid,avvik)
    title ('integrert lysverdi = arealet A(t)')
    drawnow
end

%%
% Steng sensor manuelt
JoyMainSwitch   = joystick.buttons(7);
CloseSensor(SENSOR_3)
