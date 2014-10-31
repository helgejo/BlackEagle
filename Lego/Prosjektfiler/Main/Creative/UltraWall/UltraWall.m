%%BETA!
%% Egen kreativ oppgave " UltraWall"
% ING100 Gruppe 1401 "Daniel L�vik" 2014

% Beskrivelse av program:

% Roboten kj�rer fremover helt til Ultralydsensoren finner veggen innenfor
% 40cm, roboten vil da snu 90 grader og kj�re videre og gjenta prosedyren
% ved ny vegg.
% Kj�relengde i cm vises n�r programmet avslutter.


%% Initialiserer NXT
%
COM_CloseNXT all                % lukker alle NXT-h�ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % Ser etter NXT USB enheter
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h�ndtak


%% Initialiserer sensorer
OpenUltrasonic(SENSOR_4);
%OpenLight(SENSOR_3,'ACTIVE'); %Lys sensor

%%
sUltra = [0];% Ultravektor
ultraStart = 1 ;
ProgStart = 1; % Variabel for WHile kontroll
Fremover = NXTMotor('BC') ;
Venstre = NXTMotor('C', 'Power', 40, 'TachoLimit', 90); % 40% kraft p� venstre motor med 90 graders grense for hjul spin.
Hoyre = Venstre;
Hoyre.Port = 'B';
Hoyre.Power = -Venstre.Power; % Kopierer Venstre motor sin oppf�rsel andre veien
Objfolg = GetLight(SENSOR_3);
% Hjulene sin Diameter = 3cm, omkrets = 9.42
%Ultra l�kke
Omkrets = 9.42 ;


        
while ProgStart == 1
    
        sUltra(end+1) = GetUltrasonic(SENSOR_4);
        subplot(2,1,2)
        plot(sUltra);
        title('Ultralyd m�ling');

        if GetUltrasonic(SENSOR_4) < 40
             Fremover.Stop('brake');
             Venstre.SendToNXT();
             Venstre.WaitFor();
             Hoyre.SendToNXT();
             Hoyre.WaitFor();          
         
             continue
        elseif GetUltrasonic(SENSOR_4) > 40
            Fremover.Power = 20;
            Fremover.SendToNXT();
        
        end
end
posdata = Fremover.ReadFromNXT();

disp(sprintf('NXT har kj�rt %d', posdata.Position));

%%
% Steng ned sensorer
  CloseSensor(SENSOR_3);
  CloseSensor(SENSOR_4);

% Close NXT connection.
COM_CloseNXT(handle_NXT);

