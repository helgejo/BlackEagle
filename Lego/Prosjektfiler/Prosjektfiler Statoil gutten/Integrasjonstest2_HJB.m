%% Initialiserer NXT
COM_CloseNXT all                % lukker alle NXT-h?ndtak 
close all                       % lukker alle figurer  
clear all                       % sletter alle variable 
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak
OpenLight(SENSOR_3, 'ACTIVE');

%% Initialiserer joystick
joymex2('open',0);                     % ?pner joystick
joystick      = joymex2('query',0);    % sp?r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);   % henter verdien fra knapp nr 1 som er stoppknappen 

%% Integrasjon
nullpunkt = GetLight(SENSOR_3); % 50% gr?tt (senterstrek) goes from 0 to 1023
k=1;                            % diskret tellevariabel
Lys(k)   = GetLight(SENSOR_3);  % f?rste m?ling av lys
Tcl{k}      = clock;
Tid(k)   = 0;                % starttidspunkt
A(k)     = 0   ;                 % initialverdi areal, A(1)=0
k=k+1;                          % ?ker diskret indeks og g?r inn i while-l?kke

%% loop
while ~JoyMainSwitch
    %% f? tak i joystickdata
    joystick        = joymex2('query',0);       % sp?r etter data fra joystick
    JoyMainSwitch   = joystick.buttons(1);
    
    %% Finn Areal og avvik fra midtpunkt
    Lys(k)   = GetLight(SENSOR_3);          % ny m?ling av lys
    Tcl{k}   = clock;                       % ny tidsverdi
    Tid(k)   = Tid(k-1) + etime(Tcl{k},Tcl{k-1})       % Sekunder mellom måling
    Ts(k-1)  = Tid(k)-Tid(k-1);             % beregn tidsskritt i sekund
    avvik(k-1) = Lys(k-1)-nullpunkt;        % beregn avvik fra nullpunkt
    A(k)     = A(k-1) + avvik(k-1)*Ts(k-1); % numerisk integrerer
    
    k=k+1;                                  % oppdaterer tellevariabel
end


%% Draw figure
figure
subplot(3,1,1)
plot(Tid,Lys)
hold on
%plot(Tid,nullpunkt.*size(Lys)-1)
xL = get(gca,'XLim');
line(xL,[nullpunkt(1),nullpunkt(1)],'Color','r');

subplot(3,1,2)
plot(Tid(1:end-1),avvik)

subplot(3,1,3)
plot(Tid,A)
xlabel('tid [sekund]')
ylabel('areal A')

light = {A,Tid,avvik,Ts,Lys,nullpunkt};

%% Save to disk
matfname = sprintf('lightdata_%s_%0.4f.mat', date, rem(now,1));
xlfname = sprintf('lightdata_%s_%0.4f.xls', date, rem(now,1));
save(matfname, 'light')
xlswrite(xlfname, light');

%% cleanup
% Clear MEX-file to release joystick
clear joymex2

% Steng ned sensorer
CloseSensor(SENSOR_3);

% Close NXT connection.
COM_CloseNXT(handle_NXT);


