function [] = graymusic()
%Bruk lysm?ler til ? spille musikk
%   Bruk lysm?ler til ? lese gr?toner p? et eller flere ark, hvor gr?tone
%   repr. en tone, og den fysiske lengden av gr?tonene p? arket repr.
%   tidslengde som hver tone skal spilles. La roboten kj?re over arket og
%   spille melodien

%% Initialiserer NXT
initNXT();
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Initialiserer sensorer
OpenLight(SENSOR_3,'ACTIVE'); %Lys sensor

%% Initialiser variabler
lys = 0; %m?ling fra lyssensor
lysFilt=0; %filtrert lysm?ling
startTid=cputime; %starttidspunkt
RoboSpeed = 50; %Robot speed m/s
TotLen = 0; % Total length robot should drive
LenRead=0;
SoundLen= 0;
RoboPrec= 0;
global WheelCirc = 56*pi; % Calculate wheel circumference
Mlen= 0;
Mtone= 0;
tmpDist= 0;
      

%% Functions

    function [out] = LtoHZ(l)
        x= 20000/1023;
        out = x * l
    end
    
    function [out] = Dist2Deg(dist)
        out = (dist/WheelCirc)*360;
    end
    
    function [out] = Deg2Dist(deg)
        out = WheelCirc*(deg/360);
    end

    function out = Lfilter(in)
        %Filtrerer en input vektor til et tall ut  
        temp = in(end)-in(end-1);
        % if change is less than +-5 then take last value instead
        if temp < 5 && temp > -5
            out = in(end-1);
        % filter joy input
        else
            out = in;
        end
    end

    function [TotLen,SoundLen,RoboSpeed,RoboPrec]=menuCh()
        % Menu Choices

        switch menu('Choose length robot should drive to measure: ', 'A3', 'A4', 'A5','Back')
            case 1
                TotLen=420; %papersize in mm
            case 2
                TotLen=300; %papersize in mm
            case 3
                TotLen=210; %papersize in mm
            case 4
                main();
        end

        Lenprompt = 'How long should the sound play compared to distance? Default is 10 (1mm=10ms). Higher number give longer tones';
        SoundLen = input(Lenprompt)
            if isempty(SoundLen)
                SoundLen = 10;
            end
            
        Speedprompt = 'Input robot speed? Default is 50 and maks is 100';
        RoboSpeed = input(Speedprompt) 
            if or(isempty(RoboSpeed),RoboSpeed > 100) 
                RoboSpeed = 50;
            end

        Precprompt = 'Input robot precision in mm? Default is 5';
        RoboPrec = input(Precprompt) 
            if or(isempty(RoboPrec),RoboPrec > 360) 
                RoboPrec = 5;
            end
        RoboPrec = Dist2Deg(RoboPrec)
    end
    
%% Getting everything ready
     
[TotLen, SoundLen, RoboSpeed,RoboPrec] = menuCh(); %get user input
TotLenDeg = Dist2Deg(TotLen); % Convert length input to degrees
motorB.ResetPosition(); % nullstill vinkelteller
motorC.ResetPosition(); % nullstill vinkelteller
lys = GetLight(SENSOR_3); % Get first light reading

%% Drive and collect measurments
while LenRead < TotLen
    motorB = NXTMotor('B','Power',RoboSpeed,'TachoLimit',RoboPrec);
    motorC = NXTMotor('C','Power',RoboSpeed,'TachoLimit',RoboPrec);
    motorB.SendToNXT();
    motorC.SendToNXT();
    motorB.WaitFor();
    motorC.WaitFor();
    % Read light sensor and filter
    lys(end+1)=GetLight(SENSOR_3);
    lysFilt(end+1)=Lfilter([lysFilt(end),lys(end)]);
    LenRead = LenRead + RoboPrec;
    %check if light sensor data have changed
    if lysFilt(end-1) == lysFilt(end)
        tmpDist = tmpDist + RoboPrec;
    else
        Mlen(end+1) = Deg2Dist(tmpDist)*SoundLen;
        Mtone(end+1) = LtoHZ(lysFilt(end-1));
        tmpDist = 0;
end

%% Play music (play vector if possible else create function with while loop)
NXT_PlayTone(Mtone,Mlen);

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

