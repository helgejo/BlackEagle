%% Oppgave 9 "Følg objekt+lys" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel Løvik" 2014

% Beskrivelse av program:
% NXT starter med å vri seg i en sirkelbevegelse til Ultralyd sensoren
% finner et objekt innenfor 30 cm.

% Når objektet er funnet aktiveres lyssensor og NXT venter på at verdien
% fra lyssensoren endrer seg ved at et objekt "formørker" den og gjør at
% lysverdien faller under 400. NXT vil nå kjøre fremover så lenge verdien
% holder seg under 400. Underveis vises data fra Lyssensor og Ultralyd
% grafisk.
%
% Det er implementert en "tvungen" stop hvis verdien til lyssensoren faller
% under 280, da stopper hele programmet opp og sensorer lukkes.


%% Initialiserer NXT
%
COM_CloseNXT all                % lukker alle NXT-håndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % Ser etter NXT USB enheter
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-håndtak


%% Ultralyd sensor aktiveres.
OpenUltrasonic(SENSOR_4); 


%% Diverse oppstarts variabler
sLys = [0]; % Lysvektor
sUltra = [0]; % Ultravektor
tid = [0]; % Tidsvektor
lysStart = 0; % Kontroll løkke for lys registering/endring
ProgStart = cputime; % Logger tiden programmet starter
Fremover = NXTMotor('BC') ; % Bruker begge motorene synkront
Venstre = NXTMotor('B') ; % Bruker bare venstre motor
Hoyre = NXTMotor('C'); % Bruker bare høyre motor
breakcount = 0; % Hvis 1 = Tvungen stopp av NXT og While løkke

%Ultra løkke
while GetUltrasonic(SENSOR_4) > 30 % Kjører så lenge verdier fra Ultra > 30
    pause(1)
    disp('Objekt ikke funnet')
    Venstre.Power = 10; % Venstre motor kjører med motorkraft på 10%
    Venstre.SendToNXT(); % Sender kommandoen til NXT
    
    if GetUltrasonic(SENSOR_4) < 30 % Kjører når Ultra verdi er < 30
    pause(1) 
    disp('Objekt funnet') 
    Venstre.Stop('off');  % Skrur av Venstre motor
    OpenLight(SENSOR_3,'ACTIVE');
    break;
    end
end

lysStart = lysStart+1; % Settes til 1, løkken under aktiveres.

        
while lysStart == 1
        % Plotter verdier inn i 2 plott på en figur
        sUltra(end+1) = GetUltrasonic(SENSOR_4);
        tid(end+1)=cputime-ProgStart;
        subplot(2,1,2)
        plot(tid,sUltra);
        title('Ultralyd måling');
        sLys(end+1) = GetLight(SENSOR_3);
        figure(1)
        subplot(2,1,1)
        plot(tid,sLys);
        title('Måling av lysverider')

% Lysløkke
if breakcount == 0;

   if GetLight(SENSOR_3) >500 % Leser av lysverdier som i et normalt rom vil være ca 600+
       Fremover.Stop('brake');
       
   elseif (GetLight(SENSOR_3) > 280) && (GetLight(SENSOR_3) <400 )% Når hånd/objekt dekker lyssensoren fra 
     %en avstand synker verdien ned til trigger verdi.
     Fremover.Power = 30; % Kjører frem med 30% kraft
     Fremover.SendToNXT();
     
   elseif GetLight(SENSOR_3) <280; % Hvis lyssensor dekkes godt over synker verdien under grensen og "Force stop" aktiveres.
     Fremover.Stop('off');  % Skrur av motor
     breakcount = breakcount +1; % Stopper Lysløkken
     lysStart = false; % Stopper While løkke
     disp('Force stop aktivert')
   else
       Fremover.Stop('brake'); % Bremser
       
   end
end
end
     

%%
% Steng ned sensorer
  CloseSensor(SENSOR_3);
  CloseSensor(SENSOR_4);

% Close NXT connection.
COM_CloseNXT(handle_NXT);

