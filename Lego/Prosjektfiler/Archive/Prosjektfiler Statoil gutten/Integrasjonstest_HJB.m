%% Initialiserer NXT
COM_CloseNXT all                % lukker alle NXT-h?ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak
OpenLight(SENSOR_3, 'ACTIVE');

%% Initialiserer motor B og C
%  #2 Introduksjon til MATLAB, LEGO NXT og RWTH Mindstorms toolbox
%
motorB = NXTMotor('B','SmoothStart',true); % initialiserer motor B
motorC = NXTMotor('C','SmoothStart',true); % initialiserer motor C

%% Initialiserer joystick
joymex2('open',0);                     % ?pner joystick
joystick      = joymex2('query',0);    % sp?r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);   % henter verdien fra knapp nr 1 som er stoppknappen 

%% Integrasjon
nullpunkt = GetLight(SENSOR_3); % 50% gr?tt (senterstrek) goes from 0 to 1023
k=1;                            % diskret tellevariabel
Lys(k)   = GetLight(SENSOR_3);  % f?rste m?ling av lys
Tid(k)   = rem(now,1);          % starttidspunkt
A(k)     = 0                    % initialverdi areal, A(1)=0
k=k+1;                          % ?ker diskret indeks og g?r inn i while-l?kke

%% loop
while ~JoyMainSwitch
    %% f? tak i joystickdata
    joystick        = joymex2('query',0);       % sp?r etter data fra joystick
    JoyMainSwitch   = joystick.buttons(1);
    JoyForover(k)   = -joystick.axes(2)/327.68; % 32768 fremover, -32768 bakover
    JoySide(k)      = joystick.axes(1)/327.68 % 32768 h?yre, -32768 venstre
    
    %% beregner motorpaadrag og lagrer i vektor
    PowerB(k) = (JoyForover(k)-JoySide(k))/2;
    PowerC(k) = (JoyForover(k)+JoySide(k))/2;
    
    %% set output data
    motorB.Power = PowerB(k);
    motorC.Power = PowerC(k);
    motorB.SendToNXT();
    motorC.SendToNXT();
    
    %% Finn Areal og avvik fra midtpunkt
    Lys(k)   = GetLight(SENSOR_3);          % ny m?ling av lys
    Tid(k)   = rem(now,1);                  % ny tidsverdi
    Ts(k-1)  = Tid(k)-Tid(k-1);             % beregn tidsskritt i sekund
    avvik(k-1) = Lys(k-1)-nullpunkt;        % beregn avvik fra nullpunkt
    A(k)     = A(k-1) + avvik(k-1)*Ts(k-1); % numerisk integrerer
    
    k=k+1;                                  % oppdaterer tellevariabel
end

%% Draw figure
figure
plot(Tid,A)
xlabel('tid [sekund]')
ylabel('areal A')


%% cleanup
% stopp motorer
motorB.Stop;
motorC.Stop;

% Clear MEX-file to release joystick
clear joymex2

% Steng ned sensorer
CloseSensor(SENSOR_3);

% Close NXT connection.
COM_CloseNXT(handle_NXT);


