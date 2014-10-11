% Maunell kj?ring test HJB

%% Initialiserer NXT
COM_CloseNXT all                % lukker alle NXT-h?ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Initialiserer motor B og C
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
    Horn            = joystick.buttons(4);
    Horn2           = joystick.buttons(3);
    AlarmOn         = joystick.buttons(5);
    AlarmOff        = joystick.buttons(6);
    JoyForover(i)   = -joystick.axes(2)/327.68; % 32768 fremover, -32768 bakover
    JoySide(i)      = joystick.axes(1)/327.68 % 32768 h?yre, -32768 venstre
    
    %% beregner motorpaadrag og lagrer i vektor
    PowerB(i) = (JoyForover(i)-JoySide(i))/2;
    PowerC(i) = (JoyForover(i)+JoySide(i))/2;
    
    %% set output data
    motorB.Power = PowerB(i);
    motorC.Power = PowerC(i);
    motorB.SendToNXT();
    motorC.SendToNXT();
    if AlarmOn > 0
        while ~AlarmOff
            joystick        = joymex2('query',0);
            AlarmOff        = joystick.buttons(6);
            NXT_PlayTone(1200,1000);
            pause(0.5)
            NXT_PlayTone(700,1000);
        end
    end
    if Horn > 0
        NXT_PlayTone(1400,200);
    end
     if Horn2 > 0
        NXT_PlayTone(400,200);
    end
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

