function mathShowMain()
% Main funcion for mathshow program
%   Program 1: show nummeric integration
%   Program 2: show nummeric derivation

%%
% Main program
run = 1; %Loop variable
while run
    choice = menu('Choose math function to show: ', 'Integration', 'Derivation', 'Exit');
    switch choice
        case 1 %Show nummeric integration
            mathIntShow();
        case 2 %Show nummeric derivation
            mathDerShow();
        case 3 %Exit program
            run = 0;
    end
end
end

