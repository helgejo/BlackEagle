function [] = graymusic()
%Bruk lysm?ler til ? spille musikk
%   Bruk lysm?ler til ? lese gr?toner p? et eller flere ark, hvor gr?tone
%   repr. en tone, og den fysiske lengden av gr?tonene p? arket repr.
%   tidslengde som hver tone skal spilles. La roboten kj?re over arket og
%   spille melodien

%TODO
%test with high Soundlen, if melody not longer playtone outside loop in the
%end
% test light reading to see what filter should be used (when to use new
% tone)
%Try to use cos function from piano
%graph that show light reading vs time
%graph that show tone and length vs time
% robodance in the end
% get distance from accelerator and ultrasound


%% Initialiserer NXT
initNXT();
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Initialiserer sensorer
OpenLight(SENSOR_3,'ACTIVE'); %Lys sensor

%% Initialiserer motorer

motorB = NXTMotor('B','SmoothStart',true); % Init motor b (h?yre)
motorC = NXTMotor('C','SmoothStart',true); % Init motor c (venste)

%% Initialiser variabler
lys = 0; %m?ling fra lyssensor
lysFilt=0; %filtrert lysm?ling
startTid=cputime; %starttidspunkt
RoboSpeed = 30; %Robot speed m/s
TotLen = 300; % Total length robot should drive
LenRead=5;
SoundLen= 50;
RoboPrec= 5;
WheelCirc = 56*pi; % Calculate wheel circumference
Mlen= 0;
Mtone= 0;
tmpDist= 0;
distdeg=0;
      

%% Functions

    function [out] = LtoHZ(l)
        x= 13800/1023;
        out = (x * l)+200
        if out > 14000
            out = 14000
        end
        
        if out < 200
            out = 200
        end
    end
    
    function [out] = Dist2Deg(dist)
        out = (dist/WheelCirc)*360;
    end
    
    function [out] = Deg2Dist(deg)
        out =  WheelCirc*(deg/360);
    end

    function [out] = Lfilter(in)
        %Filtrerer en input vektor til et tall ut  
        temp = in(end)-in(end-1);
        % if change is less than +-5 then take last value instead
        if temp < 5 && temp > -5
            out = in(end-1);
        % filter joy input
        else
            out = in(end);
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
        RoboPrec = ceil(Dist2Deg(RoboPrec))
    end
    
%% Getting everything ready
     
%[TotLen, SoundLen, RoboSpeed,RoboPrec] = menuCh(); %get user input
TotLenDeg = Dist2Deg(TotLen); % Convert length input to degrees
motorB.ResetPosition(); % nullstill vinkelteller
motorC.ResetPosition(); % nullstill vinkelteller
lys = GetLight(SENSOR_3); % Get first light reading
%lysFilt(end)=lys(end);

% move forward with robospeed   
    motorB = NXTMotor('B','Power',RoboSpeed);
    motorC = NXTMotor('C','Power',RoboSpeed);
    %motorB = NXTMotor('B','Power',RoboSpeed,'TachoLimit',RoboPrec);
    %motorC = NXTMotor('C','Power',RoboSpeed,'TachoLimit',RoboPrec);
    motorB.SendToNXT();
    motorC.SendToNXT();
%% Drive and collect measurments
while LenRead < TotLen
    
    % when lightsensor detects a major change larger than x then 
    % get motor position and calculate distance
    % Play tone for distance and light(end-1)
    data = motorB.ReadFromNXT() % hent motorinformasjon og presenter
    lys(end+1)=GetLight(SENSOR_3);
    lysFilt(end+1)=Lfilter([lysFilt(end),lys(end)]);
    
    if abs(lysFilt(end)-lysFilt(end-1))> 5
        distdeg = motorC.ReadFromNXT()
        Mlen(end+1)= Deg2Dist(distdeg.Position)*SoundLen
        Mtone(end+1) = LtoHZ(lysFilt(end-1))
        NXT_PlayTone(Mtone(end),Mlen(end))
        motorC.ResetPosition(); % nullstill vinkelteller
    end
    LenRead = Deg2Dist(data.Position)
end
%% Play music (play vector if possible else create function with while loop)

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

