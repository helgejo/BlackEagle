function [] = Reaction1()
%% Høyre / Venstre reaksjon

% Anders Svalestad
% 10.11.2014

% Beskrivelse: Et spill som lar deg teste reaksjonstiden. 
% Høyre eller venstre blir vist i en figur. Bruker må taste høyre eller
% venstre piltast på tastatur ut fra vist retning. 
%%

clear
clc

%%
% keyDownListener. Brukes til å detektere tastatur input i figur. Laget for
% å slippe input + Enter tast

    function keyDownListener(src, event)
        resultat=event.Key;

% Hvis riktig tastatur piltast ble trykket, stoppes klokke, og
% figur med resultat åpnes.
        try
            if resultat == rett
                steg = 0;
                tid = toc;
            end
        catch
        end
    end

%%
% keyDownListener. Brukes til å detektere tastatur input i figur. Laget for
% å slippe input + Enter tast

    function keyDownListener2(src, event)
        event.Key
% Etter figur med resultat har blit åpnet. Kan du trykke "space" - tast 
% for å returnere til menu, eller "escape" tast for å avslutte spill.      
        try
            if event.Key == 'space'
                steg2 = 0;
                spilligjen = 1;
            end
        catch
            try
                if event.Key == 'escape'
                    spilligjen = 0 ;
                    steg2 = 0;
                end
            catch
            end
        end
    end

%%
% Meny åpnes for å starte / avslutte spill. Når spill startes, går det
% mellom 0 og 5 sec før "høyre/venstre" retning blir vist. 

switch menu('Start/Avbryt','Start','Avslutt')
    case 1
        steg = 1;
        steg2=1;       
        pause(rand*5);
    case 2
        steg = 0;
        steg2 = 0;
end
%%
% Hvis spill blir startet, åpnes en figur som skriver ut vilkårlig retning,
% "venstre/høyre" i en figur. 
if steg
    clf
    figure(1)
% Skalering av figur.  
% Riktig piltast blir definert ut fra hvilekn retning som blir generert.   
    axis([-10 10 -10 10]);
    if rand < 0.5
        A = 'venstre'
        rett = 'leftarrow';
    else
        A = 'høyre'
        rett = 'rightarrow';
    end
    
    retning = text(-10,0,A);
    set(gca,'visible','off');
    set(retning,'fontsize',100);
    set(gcf,'keyPressFcn',@keyDownListener)
    tic;
    while steg == 1;
        drawnow;
    end
end
    

%%
% Figur for resultat

if steg2
    clf
    figure(1)
    set(gcf,'Name','"space" = Spill igjen. "Esc" = Avslutt ')
    axis([-10 10 -10 10]);
    tekst1 = text(-10,10,['Du trykket ' A]);
    tekst2 = text(-10,5, ['Reaksjonstid: ' num2str(tid) 's']);
    set(gca,'visible','off');
    set(tekst1,'fontsize',30);
    set(tekst2,'fontsize',30);
    set(gcf,'keyPressFcn',@keyDownListener2);
    while steg2 == 1;
        drawnow;
    end
    
    if spilligjen
        close gcf;
        Reaction1();
    end
end
close gcf;


end

