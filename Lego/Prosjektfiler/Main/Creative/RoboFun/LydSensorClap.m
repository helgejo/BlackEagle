function []=lydsensorclap()
%% Oppgave 8 "NXT reaksjon på klapp" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel Løvik" 2014

% Beskrivelse av program:
% Roboten starter å kjøre fremover ved 1 kraftig klapp.
% Lydverdiene plottes fortløpende.
% Ved 2 hurtige kraftige klapp stopper roboten og en distanse tekst dukker
% opp i kommando vinduet.
% Ved nytt klapp resettes klapptelleren og settes til 1 mens koden kjører
% runden på nytt.


    %% Initialiserer NXT
    %
    COM_CloseNXT all                % lukker alle NXT-håndtak 
    close all                       % lukker alle figurer  
    clear all                       % sletter alle variable 
    handle_NXT = COM_OpenNXT();     % Ser etter NXT USB enheter
    COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-håndtak


    %% Initialiserer Lyd sensor
    OpenUltrasonic(SENSOR_4);
    OpenSound(SENSOR_2, 'DB' ); %  Åpner lydsensor og leser data i DB


    %% Div variabler
    slyd = [0];% Lydvektor
    sUltra = [0];% Ultravektor
    tid = [0]; % Tidsvektor
    Progstart = true; % Variable for While kontroll
    Fremover = NXTMotor('BC') ; % Kjører frem
    clapcount = 0; % Klappteller
    clapreg = false; % Klapregistrering
    claptime = [1] ; % Tidsvektor for bruk i cputime kode til måling mellom klapp
    Start = cputime; % Starttid


    while Progstart
            % Plotter nåværende lyd verdier og ultraverdier
            tid(end+1)=cputime-Start;
            slyd(end+1) = GetSound(SENSOR_2);
            subplot(2,1,1)
            plot(tid,slyd);
            title('Måling av lydnivå')
            ylabel({'Lydverdi'})
            xlabel({'Tid'});
            sUltra(end+1) = GetUltrasonic(SENSOR_4);
            subplot(2,1,2)
            plot(tid,sUltra);
            title('Ultralyd måling');
            ylabel({'Ultraverdi'});
            xlabel({'Tid'});



            if GetSound(SENSOR_2) > 600 % Lydverdier i et stille rom er rundt 60.
                % Ved godt klapp øker verdien til over 600
            Fremover.Power = 20 ; % Kjører frem med 20% kraft
            Fremover.SendToNXT(); % Sender til NXT
            % Registrering av klapp + klappetid, sørger for at klapp bare
            % registreres en gang over satt nivå
            if ~clapreg 
                clapcount = clapcount +1
                claptime(end+1) = cputime;
                clapreg = true; 
            end 
           %Hvis det registreres to klapp innenfor 500ms øker klappteller med 2
             if claptime(end) - claptime(end-1) < 0.5 
                clapcount = clapcount +2
             end      
        else 
            if clapreg 
                clapreg = false;   
            end               

            end
            % Ved 1 vanlig klapp og 2 kjappe klapp settes NXT i brems.
           if clapcount == 3   
                    Fremover.Stop('brake')


                  % Ved nytt klapp etter 3 resettes klappteller og starter på 1.  
           elseif clapcount > 3
                  clapcount = (clapcount - clapcount) +1  

           end
           if GetUltrasonic(SENSOR_4) < 25
               Fremover.Stop('off');
               Progstart = false;

    end
end



