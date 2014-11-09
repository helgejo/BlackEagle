function [motorB,motorC] = Autofunc(avvikL)
%Beregner pådrage til hver motor ut fra lysverdi avvik fra nullpunkt. 
%   Gir ut motorB og motorC pådrag som vektor
    temp = 0.23*abs(avvikL); % bruker 22% av absolutt verdi til avviket. 
    Autospeed = 13;
    TopValue = 50;
    BotValue = -70;
    
    if avvikL > 0
        motorB = Autospeed - temp; 
        motorC = Autospeed + temp;
    elseif avvikL < 0
        motorB = Autospeed + temp;
        motorC = Autospeed - temp; 
    else
        motorB = Autospeed;
        motorC = Autospeed;
    end
    
    if motorB > TopValue
        motorB = TopValue;
    elseif motorB < BotValue;
        motorB = BotValue;
    end
    
    if motorC > TopValue
        motorC = TopValue;
    elseif motorC < BotValue;
        motorC = BotValue;
    end
    motorB = floor(motorB);
    motorC = floor(motorC);