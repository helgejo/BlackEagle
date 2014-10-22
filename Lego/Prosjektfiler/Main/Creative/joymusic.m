function [] = joymusic()
%JOYMUSIC spiller musikk med joystick

%% Initialiserer variabler
run = true; % loop variabel, settes til false for ? avslutte programmet
Mlen = 50; %ms the tone should last for

%% Initialiserer joystick
joymex2('open',0);                  % ?pner joystick
joystick = joymex2('query',0);      % sp?r etter data fra joystick
JoyMainSwitch = joystick.buttons(1);   % Knapp 1, for ? stoppe program

while run
    joystick = joymex2('query',0);
    joyFB(end+1) = (-joystick.axes(2))/(3.2768); % henter joystick posisjon p? "y"-aksen som angir lave toner
    joyS(end+1) = ((joystick.axes(1))/(3.2768))*2; % henter joystick posissjon p? "x"-aksen som angir h?ye toner
    
    NXT_PlayTone((joyFB(end)+joyS(end))/2, Mlen);
    
    JoyMainSwitch   = joystick.buttons(1);
    if JoyMainSwitch
        run = false;
    end
end

end

