function [] = piano() 
%% NB Program fortsatt i BETA
%% Oppgave 14 "Piano" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel Løvik" 2014

% Beskrivelse av program:
% Dette programmet simulerer noen tangenter slik som på et piano,
% Fjerde og femte tangenter kan foreløpig simuleres.
% Bokstavene a til k brukes for Fjerde tangenter.
% Hvilken tangent som spilles av vises i figur vinduet.
% Tangenter for "Father Jacob" er lagt med i figuren.

clear;
%% Frekvenser for taster hentet fra: https://en.wikipedia.org/wiki/Piano_key_frequencies
%%          A4  A5  B4   B5     C4    C5    D4    E4    F4    G4  G3
TanFrek = [440,880,493.9,987.7,261.6,783.9,293.7,329.6,349.2,392,196]; % Frekvenser for tangenter i Hz
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

% Vader Jacob
% |-d-f-g-d-|-d-f-g-d-|-g-h-j-|-g-h-j-|-j-a-j-h-g-d-|-j-a-j-h-g-d-|-k-k-|-k-k-|

%% Kode snutt under hentet og modifisert fra: http://www.mathworks.se/matlabcentral/fileexchange/26509-musical-notes
% Snutten under brukes til å generere forskjellige lyder basert på ASCI
Fs=10000; % Samplingfrekvens, modifikasjon av verdi medfører endring i tonefall.
t=0:2.1/(Fs):1;

lyder = [];% Lyder vektor.
for i=1:length(TanFrek) % Teller fra 1 til lengden av vektoren Tanfrek.
    lyder(:,i)=cos(TanFrek(i).*pi*t); % Ganger valgt frekvens med Cosinus formel for å generere tone.
end

    
%% Initialisering
Plyd=1; % Setter variabel til "True" for While loop
while Plyd
Bwait = waitforbuttonpress; % Venter på tastetrykk
if Bwait
       T = get(gcf, 'CurrentCharacter'); % Henter inn tast som blir trykket på.
       disp(T) % Viser hvilken tast/bokstav som ble trykket på.
       disp(double(T))  % Viser ASCII verdi til tast/bokstav. 
       k = T; % http://www.cdrummond.qc.ca/cegep/informat/professeurs/alain/images/ASCII1.GIF
       lydnummer = 0; % Teller for lydnummer.
       % Korresponderende taster generer tone+ tekst på figur.
       if k == 'a'
           lydnummer = 1;
           lydTang = 'A4';
       elseif k=='q';
           lydnummer = 2;
           lydTang = 'A5';
       elseif k=='s'
           lydnummer = 3;
           lydTang = 'B4';
       elseif k=='w'
           lydnummer = 4;
           lydTang = 'B5';
       elseif k=='d'
           lydnummer = 5;
           lydTang = 'C4';
       elseif k=='e'
           lydnummer = 6;
           lydTang = 'C5';
       elseif k=='f'
           lydnummer = 7;
           lydTang = 'D4';
       elseif k=='g'
           lydnummer = 8;
           lydTang = 'E4';
       elseif k=='h'
           lydnummer = 9;
           lydTang = 'F4';
       elseif k=='j'
           lydnummer = 10;
           lydTang = 'G4';
       elseif k=='k'
           lydnummer = 11;
           lydTang = 'G3';
       elseif k== 27 % Ved trykk på Esc knapp.
           Plyd = 0; % Lukker figuren ned.
           % Meldingsboks med avsluttningstekst som venter til bruker trykker OK.
           uiwait(msgbox('Takk for at du brukte dette programmet!','Avslutter','modal')); 
           close(figure1);
       end
if Plyd == true;
      anolyd = lydTang; % Leser inn hvilken tast som blir trykket og gir det videre til tekstboxen.
      annotation(figure1,'textbox',...% Tekstbox for visning av tangent trykket.
      [0.100470957613815 0.182716049382716 0.656200941915228 0.662111536824181], 'String',{anolyd},...
      'HorizontalAlignment','center',...
      'FontSize',180,...
      'FitBoxToText','off',...
      'BackgroundColor',[1 1 1]);
end
           
       
       if lydnummer>0
           sound(lyder(:,lydnummer)); % Lydnummer fra tastetrykk leses av og rett frekvens hentes inn og tone genereres.
       end

end    
end
end