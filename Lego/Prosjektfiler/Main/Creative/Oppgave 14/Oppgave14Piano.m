%% NB Program fortsatt i BETA
%% Oppgave 14 "Piano" fra "Forslag til kreative oppgaver"
% ING100 Gruppe 1401 "Daniel Løvik" 2014

% Beskrivelse av program:
% Dette programmet simulerer noen tangenter slik som på et piano,
% Fjerde og femte tangenter kan foreløpig simuleres.
% Tast inn korresponderende bokstav men programmet kjører for å generere
% toner.
% Melodi for "Father Jacob" er lagt med under for å teste ut tastene.

clear;
%% Frekvenser for taster hentet fra: https://en.wikipedia.org/wiki/Piano_key_frequencies
% Trykk på angitt knapp på tastatur for å generere lyd. ASCII tabell til høyre for bokstaver.
A4=440;  % a 98
A5=880;  % q 113
B4=493.9;% s 115
B5=987.7;% w 119
C4=261.6;% d 100
C5=783.9;% e 101
D4=293.7;% f 102
E4=329.6;% g 103
F4=349.2;% h 104
G4=392;  % j 106
G3=196;  % k 107

% Vader Jacob
% |-c-d-e-c-|-c-d-e-c-|-e-f-g-|-e-f-g-|-g-a-g-f-e-c-|-g-a-g-f-e-c-|-c-c-|-c-c-|
% Konvertert til dette pianoet.
% |-d-f-g-d-|-d-f-g-d-|-g-h-j-|-g-h-j-|-j-a-j-h-g-d-|-j-a-j-h-g-d-|-k-k-|-k-k-|

%% Kode snutt under hentet og modifisert fra: http://www.mathworks.se/matlabcentral/fileexchange/26509-musical-notes
% Snutten under brukes til å generere forskjellige lyder basert på ASCI
% inntasting som oppstår ved inntasting av bokstaver fra tastatur.
Fs=10000;
t=0:2.1/(Fs):1

yA4=cos(A4*pi*t)
yA5=cos(A5*pi*t);
yB4=cos(B4*pi*t);
yB5=cos(B5*pi*t);
yC4=cos(C4*pi*t);
yC5=cos(C5*pi*t);
yD4=cos(D4*pi*t);
yE4=cos(E4*pi*t);
yF4=cos(F4*pi*t);
yG3=cos(G3*pi*t);
yG4=cos(G4*pi*t);
%% Initialisering
Plyd=1; % Setter variabel til "True" for While loop
while Plyd
Bwait = waitforbuttonpress; % Venter på tastetrykk
if Bwait
       T = get(gcf, 'CurrentCharacter');
       disp(T) % Viser hvilken tast/bokstav som ble trykket på.
       disp(double(T))  % Viser ASCII verdi til tast/bokstav. 
end    % http://www.cdrummond.qc.ca/cegep/informat/professeurs/alain/images/ASCII1.GIF


% Renses opp senere
% Snuttene under generer en tone ved trykk av korresponderende tast.
k = T;

if k == 97
    sound(yA4)
    
end

if k == 113
    sound(yA5)
    
end

if k == 115
    sound(yB4)
end

if k == 119
    sound(yB5)
end

if k == 100
    sound(yC4)
end

if k == 101
    sound(yC5)
end

if k == 102
    sound(yD4)
end

if k == 103
    sound(yE4)
end

if k == 104
    sound(yF4)
end

if k == 107
    sound(yG3)
end

if k == 106
    sound(yG4)
end

end