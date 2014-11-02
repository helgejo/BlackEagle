function [] = joymusic()
%JOYMUSIC spiller musikk med joystick

%% Initialiserer variabler
run = true; % loop variabel, settes til false for ? avslutte programmet
Mlen = 50; %ms the tone should last for
joyFB = 0;                                      % vektor for forover/bakover bevegelse av joystick
joyS = 0;                                       % vektor for sideveis bevegelse av joystick
Mtone = 0;
   %% Initialiserer NXT
    initNXT();
    handle_NXT = COM_OpenNXT();     % etablerer nytt håndtak
    COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-håndtak

%% Initialiserer joystick
joymex2('open',0);                  % ?pner joystick
joystick = joymex2('query',0);      % sp?r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);   % Knapp 1, for ? stoppe program

while run
    joystick = joymex2('query',0);
    joyFB(end+1) = (-joystick.axes(2))/(32.768); % henter joystick posisjon p? "y"-aksen som angir lave toner
    joyS(end+1) = ((joystick.axes(1))/(32.768))*2; % henter joystick posissjon p? "x"-aksen som angir h?ye toner
    if ((joyFB(end)+joyS(end))/2) > 0;
        Mtone = LtoHZ((joyFB(end)+joyS(end))/2);
        NXT_PlayTone(Mtone, Mlen);
    end
    JoyMainSwitch   = joystick.buttons(1);
    if JoyMainSwitch
        run = false;
    end
end

end

