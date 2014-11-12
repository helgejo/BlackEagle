function [] = joymusic()
%JOYMUSIC spiller musikk med joystick

%% Initialiserer variabler
run = true;     % loop variabel, settes til false for ? avslutte programmet
Mlen = 50;      % ms the tone should last for
joyFB = 0;      % vektor for forover/bakover bevegelse av joystick
joyS = 0;       % vektor for sideveis bevegelse av joystick
Mtone = 0;
%% Initialiserer NXT
initNXT();
handle_NXT = COM_OpenNXT();     % etablerer nytt h?ndtak
COM_SetDefaultNXT(handle_NXT);	% setter globalt standard-h?ndtak

%% Initialiserer joystick
joymex2('open',0);                      % ?pner joystick
joystick = joymex2('query',0);          % sp?r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);    % Knapp 1, for ? stoppe program

while run
    joystick = joymex2('query',0);                  % sp?r etter data fra joystick
    joyFB(end+1) = (-joystick.axes(2))/(32.768);    % henter joystick posisjon p? "y"-aksen som angir lave toner
    joyS(end+1) = ((joystick.axes(1))/(32.768))*2;  % henter joystick posissjon p? "x"-aksen som angir h?ye toner
    if ((joyFB(end)+joyS(end))/2) > 0;              % Hvis joystick posisjon st?rre enn 0
        Mtone = LtoHZ((joyFB(end)+joyS(end))/2);    % Konverter joystick signal til hz
        NXT_PlayTone(Mtone, Mlen);                  % Spill tone
    end
    JoyMainSwitch   = joystick.buttons(1);          % Definer avsluttings program
    if JoyMainSwitch
        run = false;                                % Hvis knapp trykket avsluttes programmet
    end
end

end

