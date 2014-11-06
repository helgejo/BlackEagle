function [] = gui()
%% GUI to create choices to select the various projects
n=1
while n>0
    switch menu('Int100 prosjekt', 'Robot kjøring', 'Kreative oppgaver', 'Avslutt')
       case 1
           m1=1
           while m1>0
                switch menu('Robot kjøring', 'Manuell kjøring', 'Automatisk kjøring', 'Tilbake')
                    case 1
                        main()
                    case 2
                        auto()
                    case 3
                        m1 = 0; % Gå tilbake til forrige meny
                end
           end            
        case 2
            m2 = 1
            while m2 > 0
                switch menu('Kreative oppgaver', 'Spill', 'Musikk', 'Robo Fun','Plot test', 'Tilbake')
                    case 1
                           m2_1 = 1
                           while m2_1 > 0
                                switch menu('Spill', 'CannonGame', 'Reaksjonstest1','Reaksjonstest2','Tilbake')
                                    case 1
                                        cannonGame()
                                    case 2
                                        Reaction1()
                                    case 3
                                        Reaction2()
                                    case 4
                                        m2_1 = 0; % Gå tilbake til forrige meny
                                end
                           end
                    case 2
                           m2_2 = 1
                           while m2_2 > 0
                                switch menu('Musikk', 'Robo Read 2Music', 'Piano', 'Joystick Play', 'Tilbake')
                                    case 1
                                        graymusic()
                                    case 2
                                        piano()
                                    case 3
                                        joymusic()
                                    case 4
                                        m2_2 = 0; % Gå tilbake til forrige meny
                                end
                           end
                    case 3
                           m2_3 = 1
                           while m2_3 > 0
                                switch menu('Robo Fun', 'Robo Clap', 'Robo Follow', 'Robo Wall', 'Tilbake')
                                    case 1
                                        lydsensorclap()
                                    case 2
                                        ultrahandfollow()
                                    case 3
                                        ultrawall()
                                    case 4
                                        m2_3 = 0; % Gå tilbake til forrige meny
                                end
                            end
                    case 4
                        plotTime();
                    case 5
                        m2 = 0; % Avslutt has been pressed n is set to 0 to end while loop and terminate
                end
            end
       case 3
           n = 0; % Avslutt has been pressed n is set to 0 to end while loop and terminate
    end
end
end