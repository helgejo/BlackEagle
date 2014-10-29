 screen = get(groot,'screensize')
figure('Name','Main figur','Position',[screen(3)/8, 4.5*screen(4)/8, 3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off')%Main figur, Totalt avvik, Rettning p? n?v?rende avvik, Verdi, delta T
f1 = gcf
figure('Name','Motor figur','Position',[screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off')%Motor figur, p?drag h?yre motor, p?drag venstre motor
f2 = gcf
figure('Name','Integrert Avvik figur','Position',[4.5*screen(3)/8, 4.5*screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off')%IntAvvik figur, Lysverdi fra sensor ink nullpunkt, avvik rundt nullpunkt, integrert lysverdi
f3 = gcf
figure('Name','Derivert Avvik figur','Position',[4.5*screen(3)/8, screen(4)/8,3*screen(3)/8, 2.8*screen(4)/8],'NumberTitle','off')%DerAvvik figur, lysverdi, filtrert lysverdi, filtrert derivert 
f4 = gcf

% fig = gcf; % current figure handle
% fig.Color = [0 0.5 0.5];
% fig.ToolBar = 'none';

% Make the figure h current, but do not change its visibility or stacking with respect to other figures:
% set(groot,'CurrentFigure',h);