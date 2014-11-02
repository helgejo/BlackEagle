function [] = reaction()
%% Reaksjon test. 
%   Gruppe 1401
% Skrevet av: Anders Svalestad 
%   23.10.2014

%%
clear
clc

% Starter While loop
n=1;

while n == 1;
% lukker alle figurer
    close all;

% Lar bruker velge test eller avslutt
        valg = menu('Test Reaksjon','Finn bokstaven','Avslutt');
    if  valg == 1;
    else gui();
    end

% Velger en vilkårlig bokstav mellom A og Z
        liste = 'abcdefghijklmnopqrstuvwxyz';
        bokstav = liste(ceil(length(liste)* rand));

% Setter opp figur og viser villkårlig bokstav
        figure(1)
        axis([-2 2 -2 2]);
        bokstavvisning = text(0,0,bokstav);
        set(gca,'visible','off');
        set(bokstavvisning, 'fontsize',100);

% Starter stoppeklokke
        tic;
% Finn vist bokstav. Tast bokstaven via tastatur og trykk enter  
        resultat = input('tast in vist bokstav: ','s');
% Hvis bokstav er riktig, Stopp klokke og vis reultat.  
    if  resultat == bokstav;
        toc;
        tid = toc;
        disp (['Rigtig bokstav. Du brukte: ' num2str(tid) ' sekund']);
% Hvis feil bokstav blir tastet, prøv igjen.
    else
        disp ('Feil bokstav, pr�v igjen') 
    end
end
end
