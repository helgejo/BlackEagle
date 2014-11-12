function [] = graymusic()
%% Kreativ oppgave av Helge Bjorland

%% Bruk lysm?ler til ? spille musikk
%   Bruker lysm?ler til ? lese gr?toner separert av hvitt felt p? ett ark, hvor gr?tone
%   repr. en tone, og den fysiske lengden av gr?tonene p? arket repr.
%   tidslengde som hver tone skal spilles. Man velger: 
%       + st?rrelse p? arket
%       + Lyd lengde multiplier
%       + Robot fart under m?ling
%       + Presisjon p? lysm?ling
%   Roboten kj?rer over arket og spiller deretter melodien

%% Initialiserer NXT
initNXT();
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Initialiserer sensorer
OpenLight(SENSOR_3,'ACTIVE');   % ?pner lys sensor

%% Initialiserer motorer

motorB = NXTMotor('B','SmoothStart',true); % Initialiser motor b (h?yre)
motorC = NXTMotor('C','SmoothStart',true); % Initialiser motor c (venste)

%% Initialiser variabler
lys = 0;            % m?ling fra lyssensor
lysFilt=0;          % filtrert lysm?ling
RoboSpeed = 10;     % Robot speed m/s
TotLen = 300;       % Total length robot should drive
LenRead=5;          % M?ler lengden robot har kj?rt
SoundLen= 10;       % Lengden p? tonen i forhold til distanse
RoboPrec= 5;        % Presisjons faktor for lysm?ler
Mlen= 0;            % Tone lengde
Mtone= 200;         % Tone frekvens
templys = 0;        % lysm?ling temp variabel
lysneg = 0;         % lysm?ling derivert positiv eller negativ
i=1;                % teller i while loop
danceDirect=1;      % Danse retning
danceSpeed=15;      % Danse fart

function [TotLen,SoundLen,RoboSpeed,RoboPrec]=menuCh()
        % Meny for ? sette papirst?rrelse

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
        
% Meny for ? sette variabler fra bruker input
prompt={'Sound length multiplier? Default is 1 (1mm=1ms). Higher number give longer tones',...
        'Input robot speed when measuring? Default is 10 and maks is 100',...
        'Input robot light reading precision between 0 - 100? Lower number is more accurate. Default is 5'};
name='Input for light to music function';
numlines=1;
defaultanswer={'1','10','5'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
        SoundLen = str2double(answer(1))*10;
            if isempty(SoundLen)
                SoundLen = 10;
            end
            
        RoboSpeed = str2double(answer(2));
            if or(isempty(RoboSpeed),RoboSpeed > 100) 
                RoboSpeed = 10;
            end

        RoboPrec = str2double(answer(3)); 
            if or(isempty(RoboPrec),RoboPrec > 360) 
                RoboPrec = 5;
            end
        RoboPrec = ceil(Dist2Deg(RoboPrec))
    end
    
%% Getting everything ready
[TotLen, SoundLen, RoboSpeed,RoboPrec] = menuCh();      % get user input
motorB.ResetPosition();                                 % nullstill vinkelteller
motorC.ResetPosition();                                 % nullstill vinkelteller
lys = GetLight(SENSOR_3);                               % Get first light reading
screen = get(0,'screensize');                           % hent skjermst?rrelse for ? stille grafene

% Figur for ? vise tonelengde
figure('Name','Hovedfigur - Press en tast for ? komme tilbake til meny','Position',[screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
subplot(3,1,1)
plot1_1=plot((1:(length(Mlen))), Mlen);
set(plot1_1,'Ydata', Mlen , 'Xdata', (1:(length(Mlen))) );
hold on;
title('Lyd data');
ylabel('Lydlengde');

% Figur for ? vise frekvens
subplot(3,1,2)
plot1_2=plot((1:(length(Mtone))), Mtone);
set(plot1_2,'Ydata', Mtone , 'Xdata', (1:(length(Mtone))) );
ylabel('Frekvens');
hold on;

% Figur for ? vise lysm?lingsdata
subplot(3,1,3)
plot1_3=plot((1:(length(lysFilt))), lysFilt);
set(plot1_3,'Ydata', lysFilt , 'Xdata', (1:(length(lysFilt))) );
xlabel('M?lepunkt');
ylabel('Lys');
hold on;

% Move forward with robospeed   
motorB = NXTMotor('B','Power',RoboSpeed);
motorC = NXTMotor('C','Power',RoboSpeed);
motorB.SendToNXT();
motorC.SendToNXT();
    
%% Drive and collect measurments
while LenRead < TotLen;
    data = motorB.ReadFromNXT();                                    % hent motor B informasjon 
    lys(end+1)=GetLight(SENSOR_3);                                  % hent lysm?ling
    lysFilt(end+1)=Lfilter([lysFilt(end),lys(end)], RoboPrec);      % filtrer lysm?ling med input presision
    deltaLys = lysFilt(end)-lysFilt(end-1);                         % Finn endring i lysm?ling

    if deltaLys < 0;                                                % Hvis endring i lysm?ling er negativ (et m?rkere parti starter)
        templys(end+1) = lysFilt(end);                              % registrer da lysm?ling i temp variabel
        lysneg = 1;                                                 % sett lysneg til 1 for ? vite at m?ling av gr?tt omr?de er startet
 
    elseif deltaLys == 0;                                           % Hvis det ikke er endring i lysm?ling
        if lysneg == 1;                                             % Men man er p? et gr?tt felt
            templys(end+1) = lysFilt(end);                          % registrer lysm?ling
        end
    else
       if lysneg == 1;                                              % Endring er positiv og dette er f?rste gang (hvitt parti starter)                              
           distdeg = motorC.ReadFromNXT();                          % Les data fra motor C
           Mtone(end+1) = LtoHZ(mean(templys));                     % Sett lyd tone til gjennomsnitt lysm?linger som er gjort p? gr?tt parti
           Mlen(end+1)= Deg2Dist(distdeg.Position)*SoundLen;        % Sett lengden p? tone til fysisk lengde av gr?tt p? arket fra motor c m?ling
           motorC.ResetPosition();                                  % nullstill motorC posisjons m?ler
           templys = 0;                                             % T?m temp lysm?lingsvariabel
           lysneg = 0;                                              % Forteller at robot er p? hvitt parti og gr?tt omr?de er allerede registrert
       end
    end
    LenRead = Deg2Dist(data.Position);                              % Sjekk total kj?relengde for ? se om det er p? tide ? stoppe
end

% Stop motorer n?r ark lengde er n?dd
motorB.Stop;
motorC.Stop;

%% Spill av sangen og dans til de herlige tonene
while i < length(Mlen);                                         % Kj?r til alle toner er spillt av
    NXT_PlayTone(Mtone(i),Mlen(i));                             % Spill toner p? nxt
    %Do a boogie to the lovely music
    motorB = NXTMotor('B','Power',danceSpeed*danceDirect);      % kj?r motor b i en retning
    motorC = NXTMotor('C','Power',danceSpeed*danceDirect*-1);   % kj?r motor c i andre retning
    motorB.SendToNXT();                                         % send motorinfo til nxt
    motorC.SendToNXT();                                         % send motorinfo til nxt
    danceDirect = danceDirect * -1;                             % snu motor retninger
    pause((Mlen(i))/1000)                                       % pause i tonelengde for ? la roboten spille ferdig tone
    i=i+1;                                                      % ?k teller
end


%% Avslutt n?r sang og dans er ferdig
% Stop motorer
motorB.Stop;    
motorC.Stop;

%% Oppdater figurer
figure(1) 
    set(plot1_1,'Ydata', Mlen ,     'Xdata',  (1:(length(Mlen))));
    set(plot1_2,'Ydata', Mtone ,    'Xdata',  (1:(length(Mtone))));
    set(plot1_3,'Ydata', lysFilt ,  'Xdata',  (1:(length(lysFilt))) );

%% Steng koblinger til sensorer og avslutt n?r knapp trykkes p? keyboard
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
            % main();
        end
    end

end

