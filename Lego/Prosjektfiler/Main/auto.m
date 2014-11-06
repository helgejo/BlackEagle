function [] = main()
    %% Auto kjørings funksjon
    % 02.11.2014
    % kreativ del av INT100 prosjekt 
    % Gruppe 1401
    % ***************************
    % Dette er en kreativ oppgave hvor roboten skal kjøre gjennom løypa
    % automatisk. Her er joystick tatt ut og erstattet med kode som
    % beregner motorpådrag i forhold til derivert. 

    %% Initialiserer NXT
    initNXT();
    handle_NXT = COM_OpenNXT();     % etablerer nytt håndtak
    COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-håndtak

    %% Bruker input for hvor ofte grafene skal oppdateres
    prompt={'Tast inn et tall fra 0 til 100000. Høyere tall gir bedre styring via joystick, mens lavere gir oftere oppdatering av figurere og grafer: '};
    name='Graf oppdateringsrate';
    numlines=1;
    defaultanswer={'10'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    plotFrek=str2double(answer);

    %% Initialiserer sensorer og motorer
    OpenLight(SENSOR_3,'ACTIVE');                   % Lys sensor
    motorB = NXTMotor('B','SmoothStart',true);      % Init motor b (høyre)
    motorC = NXTMotor('C','SmoothStart',true);      % Init motor c (venste)

    %% Initialiser variabler
    run = true;                                     % loop variabel, settes til false for å avslutte programmet
    tid=0;                                          % tidsvektor
    deltaTid=0;                                     % tidsendringsvektor
    paadragB = 0;                                   % pådrag motor B
    paadragC = 0;                                   % pådrag motor C
    lys = 0;                                        % måling fra lyssensor
    lysFilt=0;                                      % filtrert lysmåling
    lysNp=1023/2;                                   % Maksverdien fra lyssensor
    avvikL=0;                                       % vektor for filtrert lysverdi avviket fra nullpunkt
    avvikA=0;                                       % vektor for integrert lysverdi = arealet A(t)
    avvikA2=0;                                      % vektor for summen av arealet (integralet fra 0 til t)
    plotTeller = 0;                                 % teller for hvor ofte det skal plottes
    verdi=0;                                        % vektor for verdien som blir målt
    deriv=0;                                        % vektor for de deriverte av avviket
    rettning=0;                                     % vektor som beskriver rettning på avviket.
    startTid=cputime;                               % starttidspunkt
    speed= 0;                                       % Fartsmåling
    screen = get(0,'screensize');                   % Skjermstørrelse
    [rArrow, rmap] = imread('rarrow.jpg');          % Høyre pil for å angi retning
    [lArrow, lmap] = imread('larrow.jpg');          % Venstre pil for å angi retning
    [lrArrow, lrmap] = imread('lrarrow.png');       % Venstre/Høyre pil for å angi retning
    map=lrmap;                                      % Variabel som angir map for retningspil
    arrow=lrArrow;                                  % Angir hvilken retningspil som skal brukes
    w = 2;                                          % Variabel til avsluttende meny
    h = 0;                                          % Messagebox ved avslutning
    LenRead = 0;                                    % Vector for avstandsmåling
   
    %% Initialiserer figurer med bruk av handles
    % Steng ned eksisterende figurer
    close all;

    % Main figur viser totalt avvik
    figure('Name','Hovedfigur','Position',[screen(3)/8, 4.5*screen(4)/8, 3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
    plot1_1=plot(tid, avvikA2);
    set(plot1_1,'Ydata', avvikA2 , 'Xdata', tid );
    hold on;
    title('Totalt avvik: Integrert lysverdi fra t=0 til t');
    xlabel('Tid i sekund');
    ylabel('Totalt avvik');
    legend('Totalt avvik som areal','Location','NorthWest');

    % Figur som viser retning og fart i tittel
    figure('Name','Retning','Position',[screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
    imshow(arrow,map);

    %Integrert avvik figur, Lysverdi fra sensor inkl. nullpunkt, avvik rundt nullpunkt, integrert lysverdi
    figure('Name','Integrert Avvik','Position',[4.5*screen(3)/8, 4.5*screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
    subplot(3,1,1)
    plot3_1=plot(tid,lys,[0,tid(end)],[lysNp , lysNp]);
    set(plot3_1,'Ydata', lys , 'Xdata', tid );
    title('Lysverdi fra sensor inklusiv nullpunk');
    hold on;
    subplot(3,1,2)
    plot3_2=plot(tid,avvikL);
    set(plot3_1,'Ydata', avvikL , 'Xdata', tid );
    title('Avviket omkring nullpunktet');
    hold on;
    subplot(3,1,3)
    plot3_3=plot(tid,avvikA);
    set(plot3_1,'Ydata', avvikA , 'Xdata', tid );
    title('Integrert lysverdi = arealet A(t)')
    hold on;

    %Derivert avvik figur, lysverdi, filtrert lysverdi, filtrert derivert 
    figure('Name','Derivert Avvik','Position',[4.5*screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
    %Lysverdi og Filtrert lysverdi
    subplot(2,1,1)
    plot4_1=plot(tid,lysFilt,tid,lys);
    set(plot3_1,'Ydata', lysFilt , 'Xdata', tid );
    title('Filtrert Lysmålig: Blå, Lysmåling: Rød');
    hold on;
    %Derviert av filtrert lysverdi
    subplot(2,1,2)
    plot4_2=plot(tid,deriv);
    set(plot3_1,'Ydata', deriv , 'Xdata', tid );
    title('Derivert av filtrert lysverdi');
    %axis([0,tid(end),-1000,1000]);
    hold on;

    %% Main rutine som kjører roboten og oppdaterer grafer imens til knapp 1 blir trykket og run = false
    tic;
    while run
        % Tids beregninger
        tid(end+1)=toc;
        deltaTid(end+1)=tid(end)-tid(end-1);

        % les lys sensor
        lys(end+1)=GetLight(SENSOR_3);
        lysFilt(end+1)=filtLys([lysFilt(end),lys(end)]);

        % integrasjon av lysignalet
        avvikL(end+1)=lysFilt(end)-lysNp;
        avvikA(end+1)=intFunk(tid,avvikL)+avvikA(end);
        avvikA2(end+1)=abs(intFunk(tid,avvikL))+avvikA2(end);

        % Derivasjon av lysignalet
        deriv(end+1)=derivFunk(tid,avvikL)

        % Har roboten rettning mot lysere eller mørkere side
        rettning(end+1)=retFunk(deriv(end),rettning(end))

        % utregning av konkurranse poeng
        verdi(end+1)=tid(end)*100+avvikA2(end);

         % Sett bilde som viser retning basert på derivert
            % 1 angir retning mot lysere side (venstre)
         if rettning(end) > 0;
            arrow=lArrow;
            map=lmap;
            % -1 angir retning mot mørkere side (høyre)
        elseif rettning(end) < 0;
            arrow=rArrow;
            map=rmap; 
        end

        % Beregn motor pådrag basert på lys avvik fra 0 punkt
        [paadragB(end+1),paadragC(end+1)] = Autofunc(avvikL(end)); % Legg inn pådrag ihht retning

        % Send til motorene
        motorB.Power = paadragB(end);
        motorC.Power = paadragC(end);
        motorB.SendToNXT();
        motorC.SendToNXT();

        % Get speed data and calculate speed
        sBdata = motorB.ReadFromNXT(); % hent motorinformasjon 
        sCdata = motorC.ReadFromNXT(); % hent motorinformasjon 
        LenRead(end+1) = (Deg2Dist(sBdata.Position)+ Deg2Dist(sCdata.Position))/2;  % Gjennomsnitt avstand på begge motorer
        speed(end+1) = round(((LenRead(end)-LenRead(end-1))/1000) / deltaTid(end)); % delta avstand (m) / delta tid (s)

        % Plot figurer hvis plot frekvens er nådd
        if plotTeller > plotFrek
            figure(1) 
                set(plot1_1,'Ydata', avvikA2 , 'Xdata',  tid);
                title(['Points in competition: ' num2str(verdi(end)) 's']);
            figure(2)
                imshow(arrow,map)
                title(['Fart: ' num2str(speed(end)) ' m/s'], 'FontSize', 16);
            figure(3) 
                set(plot3_1,'Ydata', lys ,    'Xdata',  tid);
                set(plot3_2,'Ydata', avvikL , 'Xdata',  tid);
                set(plot3_3,'Ydata', avvikA , 'Xdata',  tid);
            figure(3) 
                set(plot4_1,'Ydata', lysFilt ,'Xdata',  tid);
                set(plot4_2,'Ydata', deriv ,  'Xdata',  tid);

             % reset plotcounter
             plotTeller = 0;
        else
            plotTeller = plotTeller + 1;
        end

        % Tegn figurer
        drawnow

        %Sjekk om programmet skal avsluttes. Det sjekkes om lysverdi
        %overstiger en gitt verdi. Dette tolkes som robot har kjørt av
        %banen.
        if  avvikL(end) >= 100 % 
            run = false;
        end    
    end

    %% Avslutt
    % Stop motorer
    motorB.Stop;
    motorC.Stop;

    % Steng kobling til sensorer
    CloseSensor(SENSOR_3);

    % Plott alt med de siste verdiene
    % avsluttende tegning av alle figurer
    close all;
    % Plot figurer    
    % Plot figur 1
    figure('Name','****PRESS ANY KEY TO RETURN TO MENU*****','Position',[screen(3)/8, 4.5*screen(4)/8, 3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
    %totalt avvik som areal
    subplot(4,1,1)
    plot(tid,avvikA2);
    title('Totalt avvik: Integrert lysverdi fra t=0 til t')
    %Rettning på avvik
    subplot(4,1,2)
    plot(tid,rettning);
    title('Har roboten retning mot (-1)mørk eller (1)lys side');
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
    figure('Name','Retning','Position',[screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
    %Pådrag motor B
    subplot(2,1,1)
    plot(tid,paadragB)
    title('Motor B');
    %Pådrag motor C
    subplot(2,1,2)
    plot(tid,paadragC)
    title('Motor C');

    %plot figur 3
    figure('Name','Integrert Avvik','Position',[4.5*screen(3)/8, 4.5*screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
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
    figure('Name','Derivert Avvik','Position',[4.5*screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off');
    %Lysverdi og Filtrert lysverdi
    subplot(2,1,1)
    plot(tid,lysFilt,tid,lys);
    title('Filtrert Lysmåling: Blå, Lysmåling: Rød');
    %Derviert av filtrert lysverdi
    subplot(2,1,2)
    plot(tid,deriv);
    title('Derivert av filtrert lysverdi');
    axis([0,tid(end),-1000,1000])

    % Gi beskjed at bruker må taste key på tastatur for å stenge figurer.
    if h == 0
        h = msgbox('Press any key on keyboard to close figures and return to menu','Message','help')
    end

    while w > 1
    w = waitforbuttonpress;
        if w <= 1;
            % Steng NXT tilkobling
            initNXT();
            % Return to main menu
            gui();
        end
    end
end