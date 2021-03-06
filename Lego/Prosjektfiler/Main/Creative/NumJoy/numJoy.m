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
derVec = [0]; % derivated vector
deltaT = [0]; % Loop time vector
linAllVec =[]; % Vector to display all linear approximations, Y-values
linAllXvec = []; % Vector to display all linear approximations, x-values
subplot(4,2,1) % Initial set up of subplot 1
sub1 = plot(timeVec,inputVec);
title('Function graph created by input: ');
hold on;
grid on; % End of initial setup sublplot 1
subplot(4,2,3) % Initial set up of subplot 3
hold on; % End of initial setup sublplot 3
subplot(4,2,4) % Initial set up of subplot 4
sub4 = plot(timeVec, cIntVec);
title('Integral function: ');
hold on; % End of initial setup sublplot 4
subplot(4,2,5) % Initial set up of subplot 5
sub5 = plot(timeVec, derVec);
title('Derivated function: ');
hold on; % End of initial setup sublplot 5
subplot(4,2,6) % Initial set up of subplot 6
sub6 = plot([0,0],[0,0]); % End of initial setup sublplot 6
subplot(4,2,7) % Initial set up of subplot 7
sub7 = plot([0,0],[0,0]);
hold on;
title('All Linear Approximations') % End of initial setup sublplot 7
subplot(4,2,8) % Initial set up of subplot 8
sub8 = plot([0,0],[0,0]);
hold on;
title('Delta Time') % End of initial setup sublplot 8

%%
%main program loop
run = 1;
tic; % Starting stop watch
while run
    inputVec(end+1) = getJoy(); % Get joystick input from getJoy() function
    timeVec(end+1) = toc; % Getting stop watch current time
    cAxis = comAxis(); % create/update a common axis
    deltaT(end+1)=timeVec(end)-timeVec(end-1); % calculate looptime from start of last loop until start of this loop
    cIntVec(end+1) = inputVec(end)*(deltaT(end)); % calculate current integrals value
    sIntVec(end+1) = sIntVec(end) + cIntVec(end); % calculate the sum of the integral
    derVec(end+1) = (inputVec(end)-inputVec(end-1))/(deltaT(end)); % The current derivated
    linVec(1)=(-derVec(end)*timeVec(end))+inputVec(end); % lower y-value for current linear approximation
    linVec(2)=(derVec(end)*cAxis(2)-derVec(end)*timeVec(end))+inputVec(end); % higher y-value for current linear approximation
    linXvec = [0 cAxis(2)]; % setting an x vector for the current linear approximation
    linAllVec = [linAllVec linVec]; % setting y values for all linear approximations
    linAllXvec = [linAllXvec linXvec]; % setting x values for all linear approximations
    
    
    subplot(4,2,1) % Loop update of subplot 1
    set(sub1,'Ydata', inputVec,'Xdata',timeVec);
    axis(cAxis); % set current common axis
    
    subplot(4,2,2) % Loop update of subplot 2
    fill([timeVec(end-1) timeVec(end) timeVec(end) timeVec(end-1)], [0 0 inputVec(end) inputVec(end)], 'b')
    axis(cAxis) % set current common axis
    title(['Current loop integral: ' num2str(cIntVec(end))]); % update title including the current integral
   
    subplot(4,2,3) % Loop update of subplot 3
    fill([timeVec(end-1) timeVec(end) timeVec(end) timeVec(end-1)], [0 0 inputVec(end) inputVec(end)], 'b')
    axis(cAxis) % set current common axis
    title(['Sum of integral: ' num2str(sIntVec(end))]); % update the title including the sum of the integral
    
    subplot(4,2,4) % Loop update of subplot 4
    set(sub4, 'Ydata', sIntVec, 'Xdata', timeVec);
    axis([cAxis(1) cAxis(2) (min(sIntVec)-1) (max(sIntVec)+1)]); % set current common x-axis and plot specific y-axis
    
    subplot(4,2,5) % Loop update of subplot 5
    set(sub5, 'Ydata', derVec, 'Xdata', timeVec);
    axis([cAxis(1) cAxis(2) (min(derVec)-1) (max(derVec)+1)]); % set current common x-axis and plot specific y-axis
    
    subplot(4,2,6) % Loop update of subplot 6
    set(sub6, 'Ydata', linVec, 'Xdata', linXvec);
    title('Current Linear Approximation')
    axis(cAxis) % set current common axis
    
    subplot(4,2,7) % Loop update of subplot 7
    set(sub7, 'Ydata', linAllVec, 'Xdata', linAllXvec);
    axis(cAxis) % set current common axis
    
    subplot(4,2,8) % Loop update of subplot 8
    set(sub8, 'Ydata', deltaT, 'Xdata', timeVec);
    axis([cAxis(1) cAxis(2) (min(deltaT)-0.1) (max(deltaT)+0.1)]); % set current common x-axis and plot specific y-axis
    
    drawnow; % force graphics to update
end

close gcf % close current figure before exiting program
end