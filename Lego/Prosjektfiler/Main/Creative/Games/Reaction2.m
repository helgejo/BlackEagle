function [] = Reaction2()
%% Reaksjon test. 

% Anders Svalestad 
% 23.10.2014



%%
clear
clc

%%
% Inig
tid=[];

%%
%keyDownListener. Brukes til å detektere når riktig tast blir tastet på
%keyboard. 
    function keyDownListener(src, event)
        resultat=event.Key;
        % Hvis bokstav er riktig, Stopp klokke og vis reultat.
        if  resultat == bokstav;
            tid(end+1) = toc;
            disp = (['Rigtig bokstav. Du brukte: ' num2str(tid(end)) ' sekund']);
            funnetBokstav = 1;
        elseif resultat == 'space'
       close all
       Reaction2()
        end
    end

%%



% valg = menu('Hvor mange runder vil du prøve?','3','5','10')
switch menu('Hvor mange runder vil du prøve?','3','5','10','Avslutt')
    case 1
        runder=3;
    case 2
        runder=5
    case 3
        runder=10;
    case 4
        runder = 0
  
        
end


   for n = 1:runder
% lukker alle figurer
    clf;
% Velger en vilkårlig bokstav mellom A og Z
        liste = 'abcdefghijklmnopqrstuvwxyz';
        bokstav = liste(ceil(length(liste)* rand));

% Setter opp figur og viser villkårlig bokstav
        figure(1)
        axis([-2 2 -2 2]);
        antallrunder = text(0,0,bokstav);
        set(gcf,'name','trykk space for å avbryte')
        set(gca,'visible','off');
        set(antallrunder, 'fontsize',100);
        set(gcf, 'KeyPressFcn', @keyDownListener)        

% Starter stoppeklokke
        tic;
% Finn vist bokstav. Tast bokstaven via tastatur og trykk enter  
        %resultat = input('tast in vist bokstav: ','s');
        funnetBokstav = 0;
        while ~funnetBokstav
        drawnow;    
        end
  
    
   end
close all


  figure(1)
  
        axis([-20 00 -20 20]);
        antallrunder = text(-20,0,['Antall runder: ' num2str(runder)]);
        Tiden = text(-20,-4,[' Du brukte totalt: ' num2str(sum(tid)) 's']);
        set(gcf, 'name', 'Trykk space for å avslutte')
        set(gca,'visible','off');
        set(antallrunder, 'fontsize',20);
        set(Tiden, 'fontsize',20);

  if runder==0
      close gcf;
    gui();
  end
end

