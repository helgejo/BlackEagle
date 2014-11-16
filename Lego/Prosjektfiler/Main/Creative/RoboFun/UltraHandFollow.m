function []=ultrahandfollow()
%% Oppgave 9 "Følg objekt" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel Løvik" 2014

% Beskrivelse av program:
% NXT starter med å vri seg i en sirkelbevegelse til Ultralyd sensoren
% finner et objekt innenfor 90 cm.
% NXT vil da kjøre mot objektet med motorkraft som avtar jo nærmere
% objektet er.
% Kommer objektet under "smertegrensen på 14cm" så rygger roboten.


%% Initialiserer NXT
%
COM_CloseNXT all                % lukker alle NXT-håndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % Ser etter NXT USB enheter
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-håndtak


%% Sensorer aktiveres.
OpenUltrasonic(SENSOR_4); 
OpenSound(SENSOR_2, 'DB' );

%% Diverse oppstarts variabler
slyd = [0]; %Lydvektor
sUltra = [0]; % Ultravektor
tid = [0]; % Tidsvektor
ultrastart = 1; % Kontroll løkke for lys registering/endring
ProgStart = cputime; % Logger tiden programmet starter
Motorer = NXTMotor('BC') ; % Bruker begge motorene synkront
breakcount = 0; % Hvis 1 = Tvungen stopp av NXT og While løkke


% %Ultra løkke
% while GetUltrasonic(SENSOR_4) > 90 % Kjører så lenge verdier fra Ultra > 90
%     pause(0.7) % Venter 700ms
%     disp('Objekt ikke funnet') 
% %     Venstre.Power = 10; % Venstre motor kjører med motorkraft på 10%
% %     Venstre.SendToNXT(); % Sender kommandoen til NXT
%     
%     if GetUltrasonic(SENSOR_4) < 90 % Kjører når Ultra verdi er < 30
%     pause(0.7) % Venter 700ms
%     disp('Objekt funnet') 
%     Venstre.Stop('off');  % Skrur av Venstre motor
%     break;
%     end
% end

% ultrastart = ultrastart+1; % Settes til 1, løkken under aktiveres.

        
while ultrastart == 1
        % Plotter verdier inn i 2 plott på en figur
        sUltra(end+1) = GetUltrasonic(SENSOR_4);
        tid(end+1)=cputime-ProgStart;
        subplot(2,1,2)
        plot(tid,sUltra);
        title('Ultralyd måling');
        ylabel({'Ultraverdi'});
        xlabel({'Tid'});
        slyd(end+1) = GetSound(SENSOR_2);
        figure(1)
        subplot(2,1,1)
        plot(tid,slyd);
        title('Måling av lydnivå')
        xlabel({'Tid'});
        ylabel({'Lydverdi'});
        
% Ultrastart On
if breakcount == 0;
   
     if GetUltrasonic(SENSOR_4) >= 80 % Avstand større enn 80cm.
     Motorer.Power = 80; % Kjører med 80% kraft.
     Motorer.SendToNXT(); 
 
     elseif (GetUltrasonic(SENSOR_4)>= 25) && (GetUltrasonic(SENSOR_4)<80) % Avstand mellom 15 og 80cm.
     Motorer.Power = GetUltrasonic(SENSOR_4)-10; % Nåværende avstandsverdi minus 10. Sendes som kraft % til NXT.
     Motorer.SendToNXT();
   elseif GetUltrasonic(SENSOR_4)<= 23 %Avstand under 23cm, kjører bakover.
     Motorer.Power = GetUltrasonic(SENSOR_4)-30; % Nåværende avstandsverdi minus 30. Sendes som kraft % til NXT.
     Motorer.SendToNXT();
    else
    Motorer.Stop('brake'); % Bremser
       
     end
   if GetSound(SENSOR_2) >900; % Ved høy lyd fra rop eller klapp aktiveres "Force stop".
     Motorer.Stop('off');  % Skrur av motor
     breakcount = breakcount +1; % Stopper Ultrastart
     ultrastart = false; % Stopper While løkke
     disp('Force stop aktivert')

   end
end
 end
     

%%
% Steng ned sensorer
  CloseSensor(SENSOR_2);
  CloseSensor(SENSOR_4);

% Close NXT connection.
COM_CloseNXT(handle_NXT);
end
