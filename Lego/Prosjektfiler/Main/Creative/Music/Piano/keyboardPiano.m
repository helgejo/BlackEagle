 function keyboardPiano()

%% Oppgave 14 "Piano" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel Løvik" 2014

% Beskrivelse av program:
% Dette programmet simulerer noen tangenter slik som på et piano,
% Utvalgte tangenter for melodien "Fader Jacob" er definert.
% Bokstavene a til k brukes for Fjerde tangenter.
% Hvilken tangent som spilles av vises i figuren.


%% Frekvenser for taster hentet fra: https://en.wikipedia.org/wiki/Piano_key_frequencies
%%          A4  A5  B4   B5     C4    C5    D4    E4    F4    G4  G3
TanFrek = [440,880,493.9,987.7,261.6,783.9,293.7,329.6,349.2,392,196]; % Frekvenser for tangenter i Hz
Tangnavn = {'A4','A5','B4','B5','C4','C5','D4','E4','F4','G4','G3',''} ; % Tangent navn.
figure1 =figure;
     annotation(figure1,'textbox',... % Tekstbox på figuren med informasjon om tangenter.
     [0.101616954474097 0.852380952380952 0.65541601255887 0.137891421159905],...
     'String',{'Fjerde tangenter for tastene a til k.'},...
     'HorizontalAlignment','center',...
     'FontSize',16,...
     'FontName','Agency FB',...
     'FitBoxToText','off',...
     'BackgroundColor',[1 1 1]);
 
 annotation(figure1,'textbox',... % Tekstbox på figuren med tangenter for "Father Jacob"
   [0.0767857142857143 0.0364168268204139 0.698214285714285 0.137891421159905],...
    'String',{'Father Jacob.','d-f-g-d-|-d-f-g-d-|-g-h-j-|-g-h-j-|-j-a-j-h-g-d-|-j-a-j-h-g-d-|-k-k'},...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FontName','Agency FB',...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);


set(figure1, 'KeyPressFcn', @KeyDownListener); % Figuren leser inn taster og funksjonen KeyDownListener utfører
% variabeloppdateringer som resulterer i tone + text på figuren.

%%
% Definerte tangenter koblet opp mot frekvens og sampling multiplikator.
     function KeyDownListener(src,event)
         k=event.Key;
         if k == 'a'
             lydnummer(end+1) = 1;
         elseif k=='q';
             lydnummer(end+1) = 2;
             
         elseif k=='s'
             lydnummer(end+1) = 3;
             
         elseif k=='w'
             lydnummer(end+1) = 4;
             
         elseif k=='d'
             lydnummer(end+1) = 5;
             
         elseif k=='e'
             lydnummer(end+1) = 6;
             
         elseif k=='f'
             lydnummer(end+1) = 7;
             
         elseif k=='g'
             lydnummer(end+1) = 8;
             
         elseif k=='h'
             lydnummer(end+1) = 9;
             
         elseif k=='j'
             lydnummer(end+1) = 10;
             
         elseif k=='k'
             lydnummer(end+1) = 11;
             
         elseif k=='escape' % Ved trykk på Esc knapp.
             Plyd = 0; % Lukker figuren ned.
         end      
     end

%% Kode snutt under hentet og modifisert fra: http://www.mathworks.se/matlabcentral/fileexchange/26509-musical-notes
% Snutten under brukes til å generere forskjellige lyder basert på ASCI
Fs=10000; % Samplings rate, modifikasjon av verdi medfører endring i tonefall.
t=0:2.1/(Fs):1;

lyder = [];% Lyder vektor.
for i=1:length(TanFrek) % Teller fra 1 til lengden av vektoren Tanfrek.
    lyder(:,i)=cos(TanFrek(i).*pi*t); % Ganger valgt frekvens med Cosinus formel for å generere tone.
end

    
%% Initialisering
Plyd=1; % Setter variabel til "True" for While loop.
lydnummer = []; % Vektor for tangentnummer.
while Plyd % True
    drawnow; % Oppdaterer figuren.
    if length(lydnummer) > 0 && Plyd % Gyldig så lenge lydnummer er større enn 0 og Plyd true.
        % Korresponderende taster generer tone+ tekst på figur.
        if lydnummer(end) > 0 && lydnummer(end) < 12; % Gyldig så lenge lydnummer verdien er mellom 0 og 12.
            anolyd = char(Tangnavn(lydnummer(1))); % Leser inn hvilken tast som blir trykket og gir det videre til tekstboxen.
            annotation(figure1,'textbox',...% Tekstbox for visning av tangent trykket.
                [0.100470957613815 0.182716049382716 0.656200941915228 0.662111536824181], 'String',{anolyd},...
                'HorizontalAlignment','center',...
                'FontSize',180,...
                'FitBoxToText','off',...
                'BackgroundColor',[1 1 1]);
            sound(lyder(:,lydnummer(1))); % Lydnummer fra tastetrykk leses av og rett frekvens hentes inn og tone genereres.
        end
        try % Exception handler, prøver koden under.
            lydnummer = lydnummer(2:end); % Hvis element 2 ikke eksisterer pga mangel på elementer i vektor fanges dette opp.
        catch % Koden under setter vektoren tom uten at bruker får en feilmelding på ovenvent kode.
            lydnummer = [];
        end
    end
end

uiwait(msgbox('Takk for at du brukte dette programmet!','Avslutter','modal')); % Meldingsboks som venter på brukerinput.
close gcf; % Stenger ned figuren.
end