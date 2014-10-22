%% GUI to create choices for the various projects
n=1
while n>0
    switch menu('Int100 prosjekt', 'Robot kj?ring', 'Andre program', 'Avslutt')
       case 1
           m1=1
           while m1>0
            switch menu('Robot kj?ring', 'Manuell kj?ring', 'Automatisk kj?ring', 'Kj?ring med verifisering', 'Tilbake')
                case 1
                    main()
                case 2
                    %Auto kj?ringsrutine
                case 3
                    %Verifiserings kj?ringsrutine
                case 4
                    m1 = 0;
            end
           end
            
        case 2
            m2 = 1
            while m2>0
                switch menu('Int100 prosjekt', 'CannonGame', 'MusicGames', 'RobotFollow', 'Tilbake')
                    case 1
                        cannonGame()
                    case 2
                        %MusicGames
                    case 3
                        %RobotFollow
                    case 4
                        m2 = 0;
                end
            end
       case 3
           n = 0; % Avslutt has been pressed n is set to 0 to end while loop and terminate
    end
end