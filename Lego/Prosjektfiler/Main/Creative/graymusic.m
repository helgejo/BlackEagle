function [] = graymusic()
% Kreativ oppgave av Helge Bjorland

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

%% Initialiserer motorer

motorB = NXTMotor('B','SmoothStart',true); % Init motor b (h?yre)
motorC = NXTMotor('C','SmoothStart',true); % Init motor c (venste)

%% Initialiser variabler
lys = 0; %m?ling fra lyssensor
lysFilt=0; %filtrert lysm?ling
RoboSpeed = 30; %Robot speed m/s
TotLen = 300; % Total length robot should drive
LenRead=5;
SoundLen= 1000;
RoboPrec= 75;
Mlen= 1000;
Mtone= 200;
engine=('B');
      

%% Functions

%     function [out] = LtoHZ(l)
%         x= 13800/1023;
%         out = (x * l)+200
%         if out > 14000
%             out = 14000
%         end
%         
%         if out < 200
%             out = 200
%         end
%     end
%     
%     function [out] = Dist2Deg(dist)
%         WheelCirc = 56*pi;
%         out = (dist/WheelCirc)*360;
%     end
%     
%     function [out] = Deg2Dist(deg)
%         WheelCirc = 56*pi;
%         out =  WheelCirc*(deg/360);
%     end
% 
%     function [out] = Lfilter(in, Prec)
%         %Filtrerer en input vektor til et tall ut  
%         temp = in(end)-in(end-1);
%         % if change is less than +-Prec then take last value instead
%         if temp < Prec && temp > -Prec
%             out = in(end-1);
%         % else take the new light reading
%         else
%             out = in(end);
%         end
%     end

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
prompt={'How long in ms should the sound play per cm? Default is 1000 (1cm=1s). Higher number give longer tones',...
        'Input robot speed? Default is 10 and maks is 100',...
        'Input robot light reading precision between 0 - 100? Lower number is more accurate. Default is 75'};
name='Input for light to music function';
numlines=1;
defaultanswer={'1000','10','75'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
        %Lenprompt = 'How long in ms should the sound play per cm? Default is 1000 (1cm=1s). Higher number give longer tones';
        SoundLen = str2double(answer(1));
            if isempty(SoundLen)
                SoundLen = 1000;
            end
            
        %Speedprompt = 'Input robot speed? Default is 10 and maks is 100';
        RoboSpeed = str2double(answer(2)); 
            if or(isempty(RoboSpeed),RoboSpeed > 100) 
                RoboSpeed = 10;
            end

        %Precprompt = 'Input robot light reading precision between 0 - 100? Lower number is more accurate. Default is 75';
        RoboPrec = str2double(answer(3)); 
            if or(isempty(RoboPrec),RoboPrec > 360) 
                RoboPrec = 75;
            end
        RoboPrec = ceil(Dist2Deg(RoboPrec))
    end
    
%% Getting everything ready
     
[TotLen, SoundLen, RoboSpeed,RoboPrec] = menuCh(); %get user input
TotLenDeg = Dist2Deg(TotLen); % Convert length input to degrees
motorB.ResetPosition(); % nullstill vinkelteller
motorC.ResetPosition(); % nullstill vinkelteller
lys = GetLight(SENSOR_3); % Get first light reading
%lysFilt(end)=lys(end);
screen = get(0,'screensize');
%Main figur, Totalt avvik
figure('Name','Hovedfigur - Press en tast for å komme tilbake til meny','Position',[screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
subplot(3,1,1)
plot1_1=plot((1:(length(Mlen))), Mlen);
set(plot1_1,'Ydata', Mlen , 'Xdata', (1:(length(Mlen))) );
hold on;
title('Lyd data');
% xlabel('Målepunkt');
ylabel('Lydlengde');
subplot(3,1,2)
plot1_2=plot((1:(length(Mtone))), Mtone);
set(plot1_2,'Ydata', Mtone , 'Xdata', (1:(length(Mtone))) );
%xlabel('Målepunkt');
ylabel('Frekvens');
hold on;
subplot(3,1,3)
plot1_3=plot((1:(length(lysFilt))), lysFilt);
set(plot1_3,'Ydata', lysFilt , 'Xdata', (1:(length(lysFilt))) );
xlabel('Målepunkt');
ylabel('Lys');
hold on;

% move forward with robospeed   
    motorB = NXTMotor('B','Power',RoboSpeed);
    motorC = NXTMotor('C','Power',RoboSpeed);
    motorB.SendToNXT();
    motorC.SendToNXT();
%% Drive and collect measurments
while LenRead < TotLen;
    tlen = 1000;
    ttone= 200;
    % when lightsensor detects a major change larger than RoboPrec then 
    % get motor position and calculate distance
    % Play tone for distance and light(end-1)
    data = motorB.ReadFromNXT(); % hent motorinformasjon 
    lys(end+1)=GetLight(SENSOR_3);
    lysFilt(end+1)=Lfilter([lysFilt(end),lys(end)], RoboPrec);
    
    if abs(lysFilt(end)-lysFilt(end-1))> 0;
        distdeg = motorC.ReadFromNXT();
        Mlen(end+1)= Deg2Dist(distdeg.Position)*SoundLen;
        Mtone(end+1) = LtoHZ(lysFilt(end-1));
        motorC.ResetPosition(); % nullstill vinkelteller
    else
        Mlen(end+1)= Mlen(end);
        Mtone(end+1) = Mtone(end);
    end
    LenRead = Deg2Dist(data.Position);
end

% Stop motorer
motorB.Stop;
motorC.Stop;

%% Play music (play vector if possible else create function with while loop)
i=1;
directB=1;
directC=1;
mbtarget=100;
mctarget=100;
while i < length(Mlen);
    NXT_PlayTone(Mtone(i),Mlen(i));
    
    %Do the boogie to the lovely music
    if engine == 'B'
        if mbtarget == 100;
            motorC.Stop;
            motorB = NXTMotor('B','Power',100*directB);
            motorB.SmoothStart = false;
            motorB.SendToNXT();
            mbtarget=0;
            directB= directB*-1;
        end
        engine = 'C';
        mbtarget=mbtarget+1;
    else
        if mctarget == 100;
            motorB.Stop;
            motorC = NXTMotor('C','Power',100*directC);
            motorC.SmoothStart = false;
            motorC.SendToNXT();
            mctarget=0;
            directC= directC*-1;
        end
        engine = 'B';
        mctarget=mctarget+1;
    end    
    i=i+1;
end


%% Avslutt
% Stop motorer
motorB.Stop;    
motorC.Stop;

figure(1) 
    set(plot1_1,'Ydata', Mlen ,     'Xdata',  (1:(length(Mlen))));
    set(plot1_2,'Ydata', Mtone ,    'Xdata',  (1:(length(Mtone))));
    set(plot1_3,'Ydata', lysFilt ,  'Xdata',  (1:(length(lysFilt))) );

% Steng kobling til sensorer
CloseSensor(SENSOR_3);

w = 2;
    h=0;
    if h==0
        h= msgbox('Press any key to close figures and return to menu','Message','help')
    end

    while w > 1
    w = waitforbuttonpress;
        if w <= 1;
            % Steng NXT tilkobling
            initNXT();
            % Return to main menu
            %main();
        end
    end

end

