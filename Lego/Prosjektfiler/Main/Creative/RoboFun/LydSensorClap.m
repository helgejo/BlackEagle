function []=lydsensorclap()
%% Oppgave 8 "NXT reaksjon p� klapp" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel L�vik" 2014

% Beskrivelse av program:
% Roboten starter � kj�re fremover ved 1 kraftig klapp.
% Lydverdiene plottes fortl�pende.
% Ved 2 hurtige kraftige klapp stopper roboten og en distanse tekst dukker
% opp i kommando vinduet.
% Ved nytt klapp resettes klapptelleren og settes til 1 mens koden kj�rer
% runden p� nytt.


    %% Initialiserer NXT
    %
    COM_CloseNXT all                % lukker alle NXT-h�ndtak 
    close all                       % lukker alle figurer  
    clear all                       % sletter alle variable 
    handle_NXT = COM_OpenNXT();     % Ser etter NXT USB enheter
    COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h�ndtak


    %% Initialiserer Lyd sensor
    %
    OpenSound(SENSOR_2, 'DB' ); %  �pner lydsensor og leser data i DB


    %% Div variabler
    slyd = [0];% Lydvektor
    tid = [0]; % Tidsvektor
    Progstart = true; % Variable for While kontroll
    Fremover = NXTMotor('BC') ; % Kj�rer frem
    clapcount = 0; % Klappteller
    clapreg = false; % Klapregistrering
    claptime = [1] ; % Tidsvektor for bruk i cputime kode til m�ling mellom klapp


    while Progstart
            % Plotter n�v�rende lyd verdier og ultraverdier
            tid(end+1)=cputime-ProgStart;
            slyd(end+1) = GetSound(SENSOR_2);
            figure(1)
            plot(tid,slyd);
            title('M�ling av lydniv�')
            ylabel({'Lydverdi'})
            xlabel({'Tid'});
            sUltra(end+1) = GetUltrasonic(SENSOR_4);
            subplot(2,1,2)
            plot(sUltra);
            title('Ultralyd m�ling');
            ylabel({'Ultraverdi'});
            xlabel({'Tid'});



            if GetSound(SENSOR_2) > 600 % Lydverdier i et stille rom er rundt 60.
                % Ved godt klapp �ker verdien til over 600
            Fremover.Power = 20 ; % Kj�rer frem med 20% kraft
            Fremover.SendToNXT(); % Sender til NXT
            % Registrering av klapp + klappetid, s�rger for at klapp bare
            % registreres en gang over satt niv�
            if ~clapreg 
                clapcount = clapcount +1
                claptime(end+1) = cputime;
                clapreg = true; 
            end 
           %Hvis det registreres to klapp innenfor 500ms �ker klappteller med 2
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
                    posdata = Fremover.ReadFromNXT(); % Leser antall grader hjul har rotert.

                    disp(sprintf('NXT har kj�rt %d', posdata.Position)); % Viser antall grader.
                    %Mulighet for formel for � vise distanse i cm.

                  % Ved nytt klapp etter 3 resettes klappteller og starter p� 1.  
           elseif clapcount > 3
                  clapcount = (clapcount - clapcount) +1  

           end

    end
end



