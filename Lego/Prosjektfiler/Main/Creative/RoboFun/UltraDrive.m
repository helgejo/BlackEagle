function []=UltraDrive()
%% Oppgave 9 "F�lg objekt" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel L�vik" 2014

% Beskrivelse av program:
% NXT kj�rer mot et objekt til den er innenfor grenseomr�det mellom 23 og
% 25 cm.
% NXT vil da bremse og st� stille s� lenge den er i grenseomr�det, �ker
% avstanden kj�rer den framover, minker den rygger NXT.
% Kommer objektet under "smertegrensen p� 23cm" s� rygger roboten.


%% Initialiserer NXT
%
COM_CloseNXT all                % lukker alle NXT-h�ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % Ser etter NXT USB enheter
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h�ndtak


%% Sensorer aktiveres.
OpenUltrasonic(SENSOR_4); % �pner Ultralydsensoren.
OpenSound(SENSOR_2, 'DB' ); % �pner lydsensoren og leser data i DB

%% Diverse oppstarts variabler
slyd = [0]; %Lydvektor
sUltra = [0]; % Ultravektor
tid = [0]; % Tidsvektor
ultrastart = 1; % Kontroll l�kke for lys registering/endring
ProgStart = cputime; % Logger tiden programmet starter
Motorer = NXTMotor('BC') ; % Bruker begge motorene synkront
breakcount = 0; % Hvis 1 = Tvungen stopp av NXT og While l�kke


        
while ultrastart == 1
        % Plotter Ultralyd, lyd og tids verdier underveis.
        sUltra(end+1) = GetUltrasonic(SENSOR_4);
        tid(end+1)=cputime-ProgStart;
        subplot(2,1,2)
        plot(tid,sUltra);
        title('Ultralyd m�ling');
        ylabel({'Ultraverdi'});
        xlabel({'Tid'});
        slyd(end+1) = GetSound(SENSOR_2);
        figure(1)
        subplot(2,1,1)
        plot(tid,slyd);
        title('M�ling av lydniv�')
        xlabel({'Tid'});
        ylabel({'Lydverdi'});
        
% Ultrastart On
if breakcount == 0;
   
     if GetUltrasonic(SENSOR_4) >= 80 % Avstand st�rre enn 80cm.
     Motorer.Power = 80; % Kj�rer med 80% kraft.
     Motorer.SendToNXT(); 
 
     elseif (GetUltrasonic(SENSOR_4)>= 25) && (GetUltrasonic(SENSOR_4)<80) % Avstand mellom 25 og 80cm.
     Motorer.Power = GetUltrasonic(SENSOR_4)-10; % N�v�rende avstandsverdi minus 10. Sendes som kraft % til NXT.
     Motorer.SendToNXT();
   elseif GetUltrasonic(SENSOR_4)<= 23 %Avstand under 23cm, kj�rer bakover.
     Motorer.Power = GetUltrasonic(SENSOR_4)-30; % N�v�rende avstandsverdi minus 30. Sendes som kraft % til NXT.
     Motorer.SendToNXT();
    else
    Motorer.Stop('brake'); % Bremser
       
     end
   if GetSound(SENSOR_2) >900; % Ved h�y lyd fra rop eller klapp aktiveres "Force stop".
     Motorer.Stop('off');  % Skrur av motor
     breakcount = breakcount +1; % Stopper Ultrastart
     ultrastart = false; % Stopper While l�kke
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
