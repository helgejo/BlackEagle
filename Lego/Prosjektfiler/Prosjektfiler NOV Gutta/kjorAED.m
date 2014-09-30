%%
% EksempelMotorA.m
%
% Program for kj�ring av motor A via joystick, og 
% plotting av p�dragssignal som funksjon av tid

%% Initialiserer NXT
COM_CloseNXT all                % lukker alle NXT-h�ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % etablerer nytt h�ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h�ndtak

%% Initialiser/�pne sensorer
%
% Les mer om hvordan disse initialiseres/�pnes i dokumentet: 
%
% #2 Introduksjon til MATLAB, LEGO NXT og RWTH Mindstorms toolbox
%
OpenSound(SENSOR_2,'DB');% Lydsensor i inngang 2


%% Initialiserer motor A
%
% Les mer om forskjellige motoregenskap og hvordan disse initialiseres
% i dokumentet: 
%  #2 Introduksjon til MATLAB, LEGO NXT og RWTH Mindstorms toolbox
%
motorC = NXTMotor('C','SmoothStart',true); % initialiserer motor A
motorB = NXTMotor('B','SmoothStart',true); % initialiserer motor A



%% Initialiserer joystick
joymex2('open',0);                     % �pner joystick
joystick      = joymex2('query',0);    % sp�r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);   % henter verdien fra knapp nr 1 som er stoppknappen 


%% Definerer vektorer best�ende av 100 elementer med 0'er
% for hver inngang, utgang og egendefinerte st�rrelser. 
% Grunnen til 0'en er at vi til enhver tid plotter siste 90 elementer.
% Her kan dere fylle p� med de variable dere �nsker � lagre

% Innganger, f.eks. lyd
Lyd        = zeros(1,100);  % lagrer lydsignal

% Utganger
PowerB     = zeros(1,100);  % lagrer motorp�drag
PowerC     = zeros(1,100);  % lagrer motorp�drag
% Egendefinerte vektorere
JoyForover = zeros(1,100);  % lagrer bevegelsen til joystick
JoySide    = zeros(1,100);  % lagrer bevegelsen til joystick

%% Initialiser figurer
set(0,'DefaultFigureUnits','normalized')
figure('Position',[0.01 0.51 0.4 0.4])
figure('Position',[0.44 0.51 0.4 0.4])


%% index for lagring i vektorer
i=1;

while ~JoyMainSwitch
    %% f� tak i joystickdata
    joystick        = joymex2('query',0);       % sp�r etter data fra joystick
    JoyMainSwitch   = joystick.buttons(1);
    JoyForover(i)   = -joystick.axes(2)/327.68; % 32768 fremover, -32768 bakover
    JoySide(i)      = -joystick.axes(1)/327.68; % 32768 fremover, -32768 bakover
    
    %% f� tak i nye sensordata og lagre i vektor
    Lyd(i) = GetSound(SENSOR_2);

    
    %% beregner motorp�drag og lagrer i vektir
    if JoySide(i) < 0
        paB = JoyForover(i) + (ceil(JoySide(i)*0.75));
        if paB > 100 ;
            paB = 100;
        elseif paB < -25;
            paB = -25;
        end
    else
        paB = JoyForover(i);
    end
    if JoySide(i)>0
        paC = JoyForover(i) - (ceil (JoySide(i).*0.75));
        if paC > 100 ;
            paC = 100;
        elseif paC < -25;
            paC = -25;
        end
    else
         paC = JoyForover(i);
    end
    
    PowerB(i) = paB;
    PowerC(i) = paC;
    
    %% set output data
    motorB.Power = PowerB(i);
    motorC.Power = PowerC(i);    
    motorB.SendToNXT();
    motorC.SendToNXT();
    
    %% plot data
    figure(1)
    subplot(2,1,1)
    bar(PowerB(i));
    axis([0 1 -100 100])
    title('P�drag motor A')

    subplot(2,1,2)
    plot(JoyForover(end-90:end));
    axis([0 100 -100 100])
    title('P�drag motor A som funksjon av tid')

    figure(2)
    subplot(2,1,1)
    plot(Lyd(end-90:end));
    title('Lydverdi')

    subplot(2,1,2)
    plot(JoyForover(end-90:end),'r');
    hold on
    plot(Lyd(end-90:end),'b');
    axis([0 100 -Inf Inf])
    title('Motorp�drag (r�d) og lyd (bl�) i samme plot')
    hold off
    
    % tegn n�
    drawnow
    
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

