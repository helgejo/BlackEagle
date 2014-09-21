InitNXT()
%% Initialiserer NXT
%COM_CloseNXT all                % lukker alle NXT-h?ndtak 
%close all                       % lukker alle figurer  
%clear all                       % sletter alle variable 
%handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
%COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

OpenLight(SENSOR_3, 'ACTIVE');
i=1;
light        = zeros(1,100);  % lagrer lyssignal
%% Initialiser figurer
set(0,'DefaultFigureUnits','normalized')
figure('Position',[0.01 0.51 0.4 0.4])
figure('Position',[0.44 0.51 0.4 0.4])

%% get data
while i<100 
    light(i) = GetLight(SENSOR_3); % goes from 0 to 1023     
    % oppdaterer tellevariabel
    i=i+1;
end

%% Plot
figure(1)
plot(light(end-90:end));
title('Lysverdi')

%% Save to disk
save('lightsensordata.mat', 'light');
xlswrite('lightdata.xls', 'light');

%% Cleanup
% Steng ned sensorer
CloseSensor(SENSOR_3);

% Close NXT connection.
COM_CloseNXT(handle_NXT);