function [motorB,motorC] = motorPaadrag(joyFB,joyS)
%Beregner pådrage til hver motor ut fra y og x akse posisjon til joystick
%   Gir ut motorB og motorC pådrag som vektor
    temp = 0.5*abs(joyS); % halve abseluttverdien til sideveis posisjon
    if joyS > 0
        motorB = joyFB - 0.8*temp; %Bidraget fra sideveis pos ytterligere redusert
        motorC = joyFB + temp;
    elseif joyS < 0
        motorB = joyFB + temp;
        motorC = joyFB - 0.8*temp; %Bidraget fra sideveis pos ytterligere redusert
    else
        motorB = joyFB;
        motorC = joyFB;
    end
    
    if motorB > 100
        motorB = 100;
    elseif motorB < -100;
        motorB = -100;
    end
    
    if motorC > 100
        motorC = 100;
    elseif motorC < -100;
        motorC = -100;
    end
    motorB = floor(motorB);
    motorC = floor(motorC);
end

