%%
% LyssensorDeriv.m
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
stigning=[0];
y=[0];
light = [0];
npv = [nullpunkt];

while Run
    time=clock;
    tid(end+1)=time(end-2).*3600+time(end-1).*60+time(end);
    deltaT = tid(end)-tid(end-1);
    light(end+1)= GetLight(SENSOR_3);
    light(end) = FiltFunct(light) ;
    deltaY = light(end) - light(end-1) ;
    stigning(end+1) =deltaT/deltaY ;
    subplot (2,1,1)
    plot (tid,light)
    title ('Lysverdi fra sensor')
    subplot (2,1,2)
    plot(tid,stigning)
    title ('Numerisk derivasjon av lysverdi')
    
    
    
    drawnow
    
end

%%
%%
% Steng sensor manuelt
CloseSensor(SENSOR_3)

