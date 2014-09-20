% game of joystick
% Hit the target.
% author Roberto G. Waissman 2001

% Load sound information in
% Creates variables y and Fs
load chirp
v = y; clear y;

% Create the connection to the joystick
% Add 2 channels. One for x and one for y
ai=analoginput('joy',1);
addchannel(ai,[1 2]);


% Set up the display
hFig=figure('DoubleBuffer','on');
hJoy = plot(0,0,'x','MarkerSize',10);
hold on;
hTarget=plot(0,0,'or','MarkerSize',10);
axis([-11 11 -11 11]);
hTitle=title('Hit the Target! Elapsed Time: ');

t0 = clock;
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
        set(hJoy,'XData',d(1),'YData',d(2));
        set(hTitle,'String',['Hit the Target! Elapsed Time: ' num2str(etime(clock,t0))]);
        drawnow

        m = m + 1;
        t1 = fix(d*10);
        if (t1 <= t2+2) & (t1 >= t2-2)
            sound(v,Fs)
            pause(1)
            delete (ai)
            clear all
            return
        end
    end
end 
 
