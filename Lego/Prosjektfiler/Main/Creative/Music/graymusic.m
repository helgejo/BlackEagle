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
RoboSpeed = 10; %Robot speed m/s
TotLen = 300; % Total length robot should drive
LenRead=5;
SoundLen= 10;
RoboPrec= 5;
Mlen= 0;
Mtone= 200;
templys = 0;
lysneg = 0;
i=1;
danceDirect=1;
danceSpeed=15;      

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
prompt={'Sound length multiplier? Default is 1 (1cm=1ms). Higher number give longer tones',...
        'Input robot speed when measuring? Default is 10 and maks is 100',...
        'Input robot light reading precision between 0 - 100? Lower number is more accurate. Default is 5'};
name='Input for light to music function';
numlines=1;
defaultanswer={'1','10','5'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
        %Lenprompt = 'How long in ms should the sound play per cm? Default is 1000 (1cm=1s). Higher number give longer tones';
        SoundLen = str2double(answer(1))*10;
            if isempty(SoundLen)
                SoundLen = 10;
            end
            
        %Speedprompt = 'Input robot speed? Default is 10 and maks is 100';
        RoboSpeed = str2double(answer(2)); 
            if or(isempty(RoboSpeed),RoboSpeed > 100) 
                RoboSpeed = 10;
            end

        %Precprompt = 'Input robot light reading precision between 0 - 100? Lower number is more accurate. Default is 75';
        RoboPrec = str2double(answer(3)); 
            if or(isempty(RoboPrec),RoboPrec > 360) 
                RoboPrec = 5;
            end
        RoboPrec = ceil(Dist2Deg(RoboPrec))
    end
    
%% Getting everything ready
[TotLen, SoundLen, RoboSpeed,RoboPrec] = menuCh(); %get user input
motorB.ResetPosition(); % nullstill vinkelteller
motorC.ResetPosition(); % nullstill vinkelteller
lys = GetLight(SENSOR_3); % Get first light reading
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
    % when lightsensor detects a major change larger than RoboPrec then 
    % get motor position and calculate distance
    % Play tone for distance and light(end-1)
    data = motorB.ReadFromNXT(); % hent motorinformasjon 
    lys(end+1)=GetLight(SENSOR_3);
    lysFilt(end+1)=Lfilter([lysFilt(end),lys(end)], RoboPrec);
    deltaLys = lysFilt(end)-lysFilt(end-1);

    if deltaLys < 0;
        templys(end+1) = lysFilt(end);
        lysneg = 1;
    elseif deltaLys == 0;
        if lysneg == 1;
            templys(end+1) = lysFilt(end);
        end
    else
       if lysneg == 1;
           distdeg = motorC.ReadFromNXT();
           Mtone(end+1) = LtoHZ(mean(templys));
           Mlen(end+1)= Deg2Dist(distdeg.Position)*SoundLen;
           motorC.ResetPosition(); % nullstill vinkelteller
           templys = 0;
           lysneg = 0;
       end
    end
    LenRead = Deg2Dist(data.Position);
end

% Stop motorer
motorB.Stop;
motorC.Stop;

%% Play music and dance
while i < length(Mlen);
    NXT_PlayTone(Mtone(i),Mlen(i));

    %Do a boogie to the lovely music
    motorB = NXTMotor('B','Power',danceSpeed*danceDirect);
    motorC = NXTMotor('C','Power',danceSpeed*danceDirect*-1);
    motorB.SendToNXT();
    motorC.SendToNXT();
    danceDirect = danceDirect * -1;
    pause((Mlen(i))/1000)
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

