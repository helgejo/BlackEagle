%InitNXT()
%% Initialiserer NXT
COM_CloseNXT all                % lukker alle NXT-h?ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

OpenLight(SENSOR_3, 'ACTIVE')
%SENSOR_3.WaitFor()
OpenSound(SENSOR_2,'DB');% Lydsensor i inngang 2
pause(5)
i=1;
light        = zeros(1,100);  % lagrer lyssignal
Lyd        = zeros(1,100);  % lagrer lydsignal

%% Initialiser figurer
% set(0,'DefaultFigureUnits','normalized')
% figure('Position',[0.01 0.51 0.4 0.4])
% figure('Position',[0.44 0.51 0.4 0.4])

%% get data
while i<100 
    light(i) = GetLight(SENSOR_3) % goes from 0 to 1023  
    %SENSOR_3.WaitFor()
   % pause(1)
    Lyd(i) = GetSound(SENSOR_2);
    %SENSOR_2.WaitFor()
    % oppdaterer tellevariabel
    %pause(0.5)
    i=i+1;
end

%% Plot
figure(1)
plot(light(end-90:end));
title('Lysverdi')

figure(2)
plot(Lyd(end-90:end));
title('Lydverdi')

%% Save to disk
save('lightsensordata.mat', 'light');
xlswrite('lightdata.xls', light);

%% Cleanup
% Steng ned sensorer
CloseSensor(SENSOR_3);

% Close NXT connection.
COM_CloseNXT(handle_NXT);