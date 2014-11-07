function joyPos = getJoy()
%The sum of joystick axis 2 and return it as output
%   Initialize joystick, query, set output value as sum and close
%   connection
    
    % Initialize joystick
    joymex2('open',0);
    joyPos = 0;
    for i=1:3
    % Query joystick
    a = joymex2('query',0);
    % Set output value as axis 2
    joyPos = joyPos + a.axes(2);
    end
    joyPos/3;
    if joyPos < 5000 && joyPos > -5000
        joyPos = 0;
    end
    % close connection
    clear joymex2
    
end

