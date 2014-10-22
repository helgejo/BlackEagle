function [] = main()
%%
%V01 av main scriptet som styrer alt
% TODO
    % VIS HASTIGHET - OK, check and maybe convert to km/h
    % HANDLES TIL PLOTTING

%% Initialiserer NXT
initNXT();
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Bruker input for hvor ofte grafene skal oppdateres
plotFrek=input('Tast inn et tall fra 0 til 100000. H?yere tall gir bedre styring via joystick, mens lavere gir oftere oppdatering av figurere og grafer: ');

%% Initialiserer sensorer
OpenLight(SENSOR_3,'ACTIVE'); %Lys sensor
OpenAccelerator(SENSOR_4); %accelerator

%% Initialiserer motorer

motorB = NXTMotor('B','SmoothStart',true); % Init motor b (h?yre)
motorC = NXTMotor('C','SmoothStart',true); % Init motor c (venste)

%% Initialiserer joystick
joymex2('open',0);                  % ?pner joystick
joystick = joymex2('query',0);      % sp?r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);   % Knapp 1, for ? stoppe program
initFB = -joystick.axes(2); % henter joystick posisjon p? "y"-aksen
initS = joystick.axes(1); % henter joystick posissjon p? "x"-aksen

%% Initialiserer figurer
figure(1); %Main figur, Totalt avvik, Rettning p? n?v?rende avvik, Verdi, delta T
figure(2); %Motor figur, p?drag h?yre motor, p?drag venstre motor
figure(3); %IntAvvik figur, Lysverdi fra sensor ink nullpunkt, avvik rundt nullpunkt, integrert lysverdi
figure(4); %DerAvvik figur, lysverdi, filtrert lysverdi, filtrert derivert

%% Initialiser variabler for main
run = true; % loop variabel, settes til false for ? avslutte programmet
joyFB = [0]; % vektor for forover/bakover bevegelse av joystick
joyS = [0]; % vektor for sideveis bevegelse av joystick
tid=[0]; %tidsvektor
deltaTid=0; %tidsendringsvektor
paadragB = [0]; %p?drag motor B
paadragC = [0]; %p?drag motor C
lys = [0]; %m?ling fra lyssensor
lysFilt=[0]; %filtrert lysm?ling
lysNp=1023/2; % Maksverdien fra lyssensor
avvikL=[0]; %vektor for filtrert lysverdi avviket fra nullpunkt
avvikA=[0]; %vektor for integrert lysverdi = arealet A(t)
avvikA2=[0]; %vektor for summen av arealet (integralet fra 0 til t)
plotTeller = 0; %teller for hvor ofte det skal plottes
verdi=[0]; %vektor for verdien som blir m?lt
deriv=[0]; %vektor for de deriverte av avviket
rettning=[0]; %vektor som beskriver rettning p? avviket.
startTid=cputime; %starttidspunkt
speed= 0;

%% Main
while run
    % Tids beregninger
    tid(end+1)=cputime-startTid;
    deltaTid(end+1)=tid(end)-tid(end-1);
    
    % les lys sensor
    lys(end+1)=GetLight(SENSOR_3);
    lysFilt(end+1)=filtLys([lysFilt(end),lys(end)]);
    
    %integrasjon av lysignalet
    avvikL(end+1)=lysFilt(end)-lysNp;
    avvikA(end+1)=intFunk(tid,avvikL)+avvikA(end);
    avvikA2(end+1)=abs(intFunk(tid,avvikL))+avvikA2(end);
    
    %Derivasjon av lysignalet
    deriv(end+1)=derivFunk(tid,avvikL);
    
    %Har roboten rettning mot lysere eller m?rkere side
    rettning(end+1)=retFunk(deriv(end),rettning(end));
    
    %utregning av verdi
    verdi(end+1)=tid(end)*100+avvikA2(end);
    
    % les joystick bevegelser
    joystick = joymex2('query',0);
    joyFB(end+1) = -joystick.axes(2)-initFB/327.68; % henter joystick posisjon p? "y"-aksen
    joyS(end+1) = joystick.axes(1)-initS/327.68; % henter joystick posissjon p? "x"-aksen
    
    %Filtrere joystick signalet
    joyFB(end) = filtJoy([joyFB(end-1),joyFB(end)]);
    joyS(end) = filtJoy([joyS(end-1),joyS(end)]);
    
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
    speed(end+1) = GetAccelerator(SENSOR_4);
    msgbox(int2str(speed(end)),'Current Speed')
    if plotTeller > plotFrek
        % Plot figurer
        % Plot figur 1
        figure(1)
        %totalt avvik som areal
        subplot(4,1,1)
        plot(tid,avvikA2);
        title('Totalt avvik: Integrert lysverdi fra t=0 til t')
        %Rettning p? avvik
        subplot(4,1,2)
        plot(tid,rettning);
        title('Har roboten retning mot (-1)m?rk eller (1)lys side');
        axis([0,tid(end),-1.5,1.5]);
        %Verdi i konkurasne ut fra gitt formel
        subplot(4,1,3)
        plot(tid,verdi);
        title('Verdi i konkuranse');
        %deltaTid
        subplot(4,1,4)
        plot(tid,deltaTid)
        title('Tidsendring pr tidsinkrement: deltaTid');

        % Plot figur 2
        figure(2)
        %P?drag motor B
        subplot(4,1,1)
        plot(tid,paadragB)
        title('Motor B');
        %P?drag motor C
        subplot(4,1,2)
        plot(tid,paadragC)
        title('Motor C');
        %Joystick posisjon i y-akse
        subplot(4,1,3)
        plot(tid,joyFB)
        title('Joystick posisjon Fremover/Bakover');
        %Joystick posisjon i x-akse
        subplot(4,1,4)
        plot(tid,joyS)
        title('Joystick posisjon Sideveis');
        
        %plot figur 3
        figure(3)
        %Lysverdi fra sensor og nullpunkt
        subplot(3,1,1)
        plot(tid,lys,[0,tid(end)],[lysNp , lysNp])
        title('Lysverdi fra sensor inklusiv nullpunk');
        %Filtrert lysverdi avviket fra 0 punkt
        subplot(3,1,2)
        plot(tid,avvikL);
        title('Avviket omkring nullpunktet');
        %integrert lysverdi
        subplot(3,1,3)
        plot(tid,avvikA);
        title('Integrert lysverdi = arealet A(t)')
        
        %Plot figur 4
        figure(4)
        %Lysverdi og Filtrert lysverdi
        subplot(2,1,1)
        plot(tid,lysFilt,tid,lys);
        title('Filtrert Lysm?lig: Bl?, Lysm?ling: R?d');
        %Derviert av filtrert lysverdi
        subplot(2,1,2)
        plot(tid,deriv);
        title('Derivert av filtrert lysverdi');
        axis([0,tid(end),-1000,1000]);
        % reset plotcounter
         plotTeller = 0;
    else
        plotTeller = plotTeller + 1;
    end
        
    % Tegn figurer
    drawnow
    
    %Sjekk om programmet skal avsluttes
    JoyMainSwitch   = joystick.buttons(1);
    if JoyMainSwitch
        run = false;
    end    
end

%% Avslutt

% Stop motorer
motorB.Stop;
motorC.Stop;

% Steng kobling til sensorer
CloseSensor(SENSOR_3);
CloseSensor(SENSOR_4);

% Fjern joystick
clear joymex2

% Steng NXT tilkobling
COM_CloseNXT(handle_NXT);

% Plott alt med de siste verdiene
% avsluttende tegning av alle figurer
% Plot figurer
% Plot figur 1
figure(1)
%totalt avvik som areal
subplot(4,1,1)
plot(tid,avvikA2);
title('Totalt avvik: Integrert lysverdi fra t=0 til t')
%Rettning p? avvik
subplot(4,1,2)
plot(tid,rettning);
title('Har roboten retning mot (-1)m?rk eller (1)lys side');
axis([0,tid(end),-1.5,1.5]);
%Verdi i konkurasne ut fra gitt formel
subplot(4,1,3)
plot(tid,verdi);
title('Verdi i konkuranse');
%deltaTid
subplot(4,1,4)
plot(tid,deltaTid)
title('Tidsendring pr tidsinkrement: deltaTid');

% Plot figur 2
figure(2)
%P?drag motor B
subplot(4,1,1)
plot(tid,paadragB)
title('Motor B');
%P?drag motor C
subplot(4,1,2)
plot(tid,paadragC)
title('Motor C');
%Joystick posisjon i y-akse
subplot(4,1,3)
plot(tid,joyFB)
title('Joystick posisjon Fremover/Bakover');
%Joystick posisjon i x-akse
subplot(4,1,4)
plot(tid,joyS)
title('Joystick posisjon Sideveis');

%plot figur 3
figure(3)
%Lysverdi fra sensor og nullpunkt
subplot(3,1,1)
plot(tid,lys,[0,tid(end)],[lysNp , lysNp])
title('Lysverdi fra sensor inklusiv nullpunk');
%Filtrert lysverdi avviket fra 0 punkt
subplot(3,1,2)
plot(tid,avvikL);
title('Avviket omkring nullpunktet');
%integrert lysverdi
subplot(3,1,3)
plot(tid,avvikA);
title('Integrert lysverdi = arealet A(t)')


%Plot figur 4
figure(4)
%Lysverdi og Filtrert lysverdi
subplot(2,1,1)
plot(tid,lysFilt,tid,lys);
title('Filtrert Lysm?lig: Bl?, Lysm?ling: R?d');
%Derviert av filtrert lysverdi
subplot(2,1,2)
plot(tid,deriv);
title('Derivert av filtrert lysverdi');
axis([0,tid(end),-1000,1000])

initNXT();
end