function [motorB,motorC] = Autofunc(avvikL)
%Beregner pådrage til hver motor ut fra lysverdi avvik fra nullpunkt. 
%   Gir ut motorB og motorC pådrag som vektor
    temp = 0.23*abs(avvikL); % bruker 22% av absolutt verdi til avviket. 
    if avvikL > 0
        motorB = 15 - temp; 
        motorC = 15 + temp;
    elseif avvikL < 0
        motorB = 15 + temp;
        motorC = 15 - temp; 
    else
        motorB = 15;
        motorC = 15;
    end
    
    if motorB > 50
        motorB = 50;
    elseif motorB < -70;
        motorB = -70;
    end
    
    if motorC > 50
        motorC = 50;
    elseif motorC < -70;
        motorC = -70;
    end
    motorB = floor(motorB);
    motorC = floor(motorC);