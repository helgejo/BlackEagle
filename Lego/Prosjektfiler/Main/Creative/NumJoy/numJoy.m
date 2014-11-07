function numJoy()
%A function that show nummeric integration and derivation from the joystick
%input.
%   Subplot 1: Function graph created by joystick input
%   Subplot 2: The current loop nummeric integral
%   Subplot 3: The sum of the integral including this loop
%   Subplot 4: The nummeric integral function graph
%   Subplot 5: The nummeric derivation of the function.
%   Subplot 6: The current linaer approximation of the function
%   Subplot 7: All linaer approximation of the function
%   Subplot 8: Delta Time

%%
% Initiate figure, getting screensize and defining size based updon this.
% In addition add a keydownlistener to the figure and a title with
% instrucitons
    function initialFig()
        screen = get(0,'screensize');
        figure('Position',[screen(3)/8, screen(4)/8,screen(3)/1.3, screen(4)/1.3]);
        set(gcf, 'KeyPressFcn', @keyDownListener, 'Name', 'Press Esc to end program');
    end

%%
% KeyDownListener to stop program by pressing escape button
    function keyDownListener(src, event)
        if event.Key == 'escape'
            run = 0;
        end
    end

%%
% subfunction to calculate commonAxis
    function commonAxis = comAxis()
        commonAxis = [0 (max(timeVec)+5) (min(inputVec)-10) (max(inputVec)+10)];
    end       

%%
% Initialization
initialFig(); %initiate the figure
inputVec = [0]; % input vector
timeVec = [0]; % time vector
cIntVec = [0]; % current integral vector
sIntVec = [0]; % sum of ingegral vector
derVec = [0];% derivated vector
deltaT = [0];
linAllVec =[];
linAllXvec = [];
subplot(4,2,1)
sub1 = plot(timeVec,inputVec);
title('Function graph created by input: ');
hold on;
grid on;
subplot(4,2,3)
hold on;
subplot(4,2,4)
sub4 = plot(timeVec, cIntVec);
title('Integral function: ');
hold on;
subplot(4,2,5)
sub5 = plot(timeVec, derVec);
title('Derivated function: ');
hold on;
subplot(4,2,6)
sub6 = plot([0,0],[0,0]);
subplot(4,2,7)
sub7 = plot([0,0],[0,0]);
hold on;
title('All Linear Approximations')
subplot(4,2,8)
sub8 = plot([0,0],[0,0]);
hold on;
title('Delta Time')

run = 1;

%%
%main program loop
tic;
while run
    inputVec(end+1) = getJoy();
    timeVec(end+1) = toc;
    cAxis = comAxis();
    deltaT(end+1)=timeVec(end)-timeVec(end-1);
    cIntVec(end+1) = inputVec(end)*(deltaT(end));
    sIntVec(end+1) = sIntVec(end) + cIntVec(end);
    derVec(end+1) = (inputVec(end)-inputVec(end-1))/(deltaT(end));
    linVec(1)=(-derVec(end)*timeVec(end))+inputVec(end);
    linVec(2)=(derVec(end)*cAxis(2)-derVec(end)*timeVec(end))+inputVec(end);
    linXvec = [0 cAxis(2)];
    linAllVec = [linAllVec linVec];
    linAllXvec = [linAllXvec linXvec];
    
    
    subplot(4,2,1)
    set(sub1,'Ydata', inputVec,'Xdata',timeVec);
    axis(cAxis);
    
    subplot(4,2,2)
    fill([timeVec(end-1) timeVec(end) timeVec(end) timeVec(end-1)], [0 0 inputVec(end) inputVec(end)], 'b')
    axis(cAxis)
    title(['Currents loop integral: ' num2str(cIntVec(end))]);
   
    subplot(4,2,3)
    fill([timeVec(end-1) timeVec(end) timeVec(end) timeVec(end-1)], [0 0 inputVec(end) inputVec(end)], 'b')
    axis(cAxis)
    title(['Sum of integral: ' num2str(sIntVec(end))]);
    
    subplot(4,2,4)
    set(sub4, 'Ydata', sIntVec, 'Xdata', timeVec);
    axis([cAxis(1) cAxis(2) (min(sIntVec)-1) (max(sIntVec)+1)]);
    
    subplot(4,2,5)
    set(sub5, 'Ydata', derVec, 'Xdata', timeVec);
    axis([cAxis(1) cAxis(2) (min(derVec)-1) (max(derVec)+1)]);
    
    subplot(4,2,6)
    set(sub6, 'Ydata', linVec, 'Xdata', linXvec);
    title('Current Linear Approximation')
    axis(cAxis)
    
    subplot(4,2,7)
    set(sub7, 'Ydata', linAllVec, 'Xdata', linAllXvec);
    axis(cAxis)
    
    subplot(4,2,8)
    set(sub8, 'Ydata', deltaT, 'Xdata', timeVec);
    axis([cAxis(1) cAxis(2) (min(deltaT)-0.1) (max(deltaT)+0.1)]);
    
    drawnow;
end

close gcf
end