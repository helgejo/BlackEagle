function [] = graymusic()
%Bruk lysm?ler til ? spille musikk
%   Bruk lysm?ler til ? lese gr?toner p? et eller flere ark, hvor gr?tone
%   repr. en tone, og den fysiske lengden av gr?tonene p? arket repr.
%   tidslengde som hver tone skal spilles. La roboten kj?re over arket og
%   spille melodien
%TODO
% La roboten kj?re til bruker trykker p? knappen for ? spille melodi
% Lag en while loop som spiller av melodi, hvor lengde av gr?tt omr?de er
% registrert og blir brukt som tid mot tone som er lysm?ling.

%% Initialiserer NXT
initNXT();
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Initialiserer sensorer
OpenLight(SENSOR_3,'ACTIVE'); %Lys sensor

%% Initialiser variabler
%tid=[0]; %tidsvektor
paadragB = 0; %p?drag motor B
paadragC = 0; %p?drag motor C
lys = 0; %m?ling fra lyssensor
lysFilt=0; %filtrert lysm?ling
startTid=cputime; %starttidspunkt
RoboSpeed = 50; %Robot speed m/s
TotLen = 0; % Total length robot should drive
WheelCirc = 56*pi; % Calculate wheel circumference
LenRead = 0; % Measured Length

%% Menu Choices
switch menu('Choose length robot should drive to measure: ', 'A3', 'A4', 'A5','Back')
    case 1
        TotLen=420;
    case 2
        TotLen=300;
    case 3
        TotLen=210;
    case 4
        main();
end

% Convert input to degrees
TotLenDeg = (TotLen/WheelCirc)*360;

Lenprompt = 'How long should the sound play compared to distance? Default is 1 (1mm=1ms). Higher number give longer tones';
SoundLen = input(Lenprompt)
    if isempty(SoundLen)
        SoundLen = 1;
    end 
Speedprompt = 'Input robot speed? Default is 50 and maks is 100';
RoboSpeed = input(Speedprompt) 
    if or(isempty(RoboSpeed),RoboSpeed > 100) 
        RoboSpeed = 50;
    end
    
Precprompt = 'Input robot precision in degrees? Default is 5 and maks is 360';
RoboPrec = input(Precprompt) 
    if or(isempty(RoboPrec),RoboPrec > 360) 
        RoboPrec = 5;
    end
%% Drive and collect measurments
while LenRead < TotLen
    % Tids beregninger
    %tid(end+1)=cputime-startTid;
    
    % les lys sensor
    lys(end+1)=GetLight(SENSOR_3);
    lysFilt(end+1)=filtLys([lysFilt(end),lys(end)]);
    
    

    
    %Beregn motor p?drag
    %Alternativ ved andre forhold mellom fram/bak og sideveis:
    % [paadragB(end+1),paadragC(end+1)] = motorPaadrag(joyFB(end),joyS(end));
    paadragB(end+1) = (joyFB(end)-joyS(end))/2;
    paadragC(end+1) = (joyFB(end)+joyS(end))/2;
    
    %sender til motorene
    motorB.Power = paadragB(end);
    motorC.Power = paadragC(end);
    motorB.SendToNXT();
    motorC.SendToNXT();
 
end

%% Play music (play vector if possible else create function with while loop)
NXT_PlayTone(lysFilt(end),SoundLen);

%% Avslutt
% Stop motorer
motorB.Stop;
motorC.Stop;

% Steng kobling til sensorer
CloseSensor(SENSOR_3);

% Steng NXT tilkobling
COM_CloseNXT(handle_NXT);

initNXT();

end

