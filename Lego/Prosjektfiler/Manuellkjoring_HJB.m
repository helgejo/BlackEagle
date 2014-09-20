% Maunell kj?ring test HJB

%% Initialiserer NXT
COM_CloseNXT all                % lukker alle NXT-h?ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Initialiserer motor A
%  #2 Introduksjon til MATLAB, LEGO NXT og RWTH Mindstorms toolbox
%
motorB = NXTMotor('B','SmoothStart',true); % initialiserer motor B
motorC = NXTMotor('C','SmoothStart',true); % initialiserer motor C


%% Initialiserer joystick
joymex2('open',0);                     % ?pner joystick
joystick      = joymex2('query',0);    % sp?r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);   % henter verdien fra knapp nr 1 som er stoppknappen 

%% index for lagring i vektorer
i=1;

while ~JoyMainSwitch
    %% f? tak i joystickdata
    joystick        = joymex2('query',0);       % sp?r etter data fra joystick
    JoyMainSwitch   = joystick.buttons(1);
    JoyForover(i)   = -joystick.axes(2)/327.68; % 32768 fremover, -32768 bakover
    JoySide(i)      = joystick.axes(1)/327.68 % 32768 høyre, -32768 venstre
    
    %% beregner motorpaadrag og lagrer i vektor
    PowerB(i) = (JoyForover(i)-JoySide(i))/2;
    PowerC(i) = (JoyForover(i)+JoySide(i))/2;
    
    %% set output data
    motorB.Power = PowerB(i);
    motorC.Power = PowerC(i);
    motorB.SendToNXT();
    motorC.SendToNXT();
    
    % oppdaterer tellevariabel
    i=i+1;
end

%% stopp motorer
motorB.Stop;
motorC.Stop;

% Clear MEX-file to release joystick
clear joymex2

% Steng ned sensorer
CloseSensor(SENSOR_2);

% Close NXT connection.
COM_CloseNXT(handle_NXT);

