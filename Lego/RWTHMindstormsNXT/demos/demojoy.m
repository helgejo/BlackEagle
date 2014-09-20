% Demo game for 4 axis joystick 
% author Roberto G. Waissman 2001 (two axis only)
% upgrade by Uros Mali 2005 (four axis)

% Load sound information in
% Creates variables y and Fs
load chirp
v = y; clear y;

% Create the connection to the joystick
% Add 4 channels. One for x, y, z and r axis.
ai=analoginput('joy',3); % the number is an ID number of installed joystick (see Controller IDs in Control panel/Gaming options
% You should play around a little bit with IDs in control panel / Gaming
% options
addchannel(ai,[1 2 3 4 5 6]);
%channels 
% 1 - X axis
% 2 - Y axis
% 3 - Z axis
% 4 - R axis
% 5 - buttons pressed (quasy binary data - see below)
% 6 - no of buttons pressed at the time

% Set up the display
hFig=figure('DoubleBuffer','on');
hJoy = plot(0,0,'x','MarkerSize',10,'LineWidth', 4);
hold on;
hJoy2 = plot(0,0,'x','MarkerSize',20, 'LineWidth', 4);
hTarget=plot(0,0,'or','MarkerSize',10, 'LineWidth', 4);
axis([-11 11 -11 11]);
hTitle=title('Hit the Target! Elapsed Time: ');
hXAxis=xlabel('Buttons Pressed: 0, No. Of Buttons pressed: 0');

t0 = clock;
tt = [];
while 1
    % Target position
    x = rand * 20 - 10;
    y = rand * 20 - 10;
    set(hTarget,'XData',x,'YData',y);
    
    % m is the counter for when to change target position
    m = 0;
    
    t2 = fix([x y]*10);
    while m < 1000
        d = getsample(ai);
        d(2) = -d(2); d(3) = -d(3);
        % decoding the data from dll. You may play with the dll. Please see
        % JoyIn.cpp
        ButtonsPressed = round((10+d(5))*32768/10);
        bP = ButtonsPressed;
        NoOfButtonsPressed = round((10+d(6))*32768/10);
        nBP = NoOfButtonsPressed;        
        set(hJoy,'XData',d(1),'YData',d(2));
        set(hJoy2,'XData',d(4),'YData',d(3));        
        set(hTitle,'String',['Hit the Target! Elapsed Time: ' num2str(etime(clock,t0))]);
        set(hXAxis,'String',['Buttons Pressed: ',num2str(bP),' No. Of Buttons pressed: ',num2str(nBP)]);
        tt = [tt; etime(clock,t0)];
        drawnow

        m = m + 1;
        t1 = fix(d(1:2)*10);
        if (t1 <= t2+2) & (t1 >= t2-2)
            %sound(v,Fs)
            %pause(1)
            x = rand * 20 - 10;
            y = rand * 20 - 10;
            set(hTarget,'XData',x,'YData',y);
            t2 = fix([x y]*10);
            m=0;
            %delete (ai)
            %clear all
            %return
        end
    end
end