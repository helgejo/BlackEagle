%% Explanation here

% while loop for at avslutt knappen skal virke
choice = menu('Int100 prosjekt', 'Robot kj?ring', 'Andre program', 'Avslutt')

switch if length(choice)>0
   case choice = 1
      choice2 = menu('Robot kj?ring', 'Manuell kj?ring', 'Automatisk kj?ring', 'Kj?ring med verifisering')
        switch
            case choice2 = 1
                %Manuell kj?ringsrutine
            case choice2 = 2
                %Auto kj?ringsrutine
            otherwise
                %Verifiserings kj?ringsrutine
      
   case choice = 2
      choice2 = menu('Int100 prosjekt', 'Robot kj?ring', 'Andre program')
        switch
            case choice2 = 1
                %Manuell kj?ringsrutine
            case choice2 = 2
                %Auto kj?ringsrutine
            otherwise
                %Verifiserings kj?ringsrutine
   otherwise
    % avslutt
end