function mathDerShow()
%Animate nummeric derivation
%   Allow user to define a function of x
%   User defines a starting x and ending x
%   Subplot 1: Show the function graph, show the x an y axis in the plot
%   Subplot 2: Show the graph of the derivate (deltaY/deltaX)
%   Subplot 3: Show the current linear approximation (tangent line) 
%   Subplot 4: Show all linear approximations

%%
%user defines function
userInputs = inputdlg({'Define function with variable x: ', 'Define starting x: ', 'Define highest x: '}, 'User inputs', 1, {'','',''});
y = char(userInputs(1)); %function
startXinput = char(userInputs(2)); %Starting x
endXinput = char(userInputs(3)); %highest x

%%
% Initiate figure, getting screensize and defining size based updon this.
% In addition add a keydownlistener to the figure and a title with
% instrucitons
    function initialFig()
        screen = get(0,'screensize');
        figure('Position',[screen(3)/6, screen(4)/6,screen(3)/1.5, screen(4)/1.5]);
        set(gcf, 'KeyPressFcn', @keyDownListener, 'Name', 'Press any key to continue');

    end
%%
% KeyDownListener to stop program by pressing any button button
    function keyDownListener(src, event)
        run = 0;
    end

%%
% main part of program
initialFig(); %initiate the figure
try %try setting up and running program
    startX=str2num(startXinput);
    endX=str2num(endXinput);
    if endX<startX %make sure endX is higher than startX
        temp=endX;
        endX=startX;
        startX=temp;
    end
    increment = 0.001;%increment for the initial x vector
    x=startX:increment:endX; %initial x vector to plot function graph
    while length(x) > 10000 %code to ensure the x vector does not get to big for the program
        increment = increment + 0.001;
        x=startX:increment:endX;
    end
    FofX=eval(y); % convert the input function to a vector using initial x vector
    comAxis=[startX endX min(FofX) max(FofX)]; %create a common axis for all plots
    subplot(4,1,1) %subplot 1: set up to show function graph
    plot(x,FofX,'b',[startX endX], [0 0], 'k', [0 0], [comAxis(3) comAxis(4)], 'k');
    title(['Function graph: f(x)=' y])
    axis(comAxis); %end subplot 1
    dfdx=0; %vector for the derivated function
    x=startX; %set x vector to start at startX
    subplot(4,1,2) %set up subplot 2
    dfdxPlot = plot(x,dfdx);
    grid on
    hold on
    title('deltaY/deltax graph') %end se up of subplot 2
    run = 1; % variable to run the main loop, stops by keydownlistener
    i=1; %counter
    tic; %start stop clock
    while run
        x(end+1) = x(1)+toc; % add to x by the time spent by program
        if x(end)<endX % check that within defined x area
            FofX=eval(y); % recreate the function vecotr based upon the updated x vector;
            i = i+1; %update counter
            dfdx(end+1)= (FofX(i)-FofX(i-1))/(x(i)-x(i-1)); %current loop value of the derivation
            subplot(4,1,2) % subplot2 update deltaY/deltaX grap
            set(dfdxPlot, 'Ydata', dfdx, 'Xdata', x);
            axis([comAxis(1) comAxis(2) (min(dfdx)-0.1) (max(dfdx)+0.1)]); % end subplot 2 update
            y1=((dfdx(end)*startX)-(dfdx(end)*x(end)))+FofX(end); % calculate low x using linear approximation
            y2=((dfdx(end)*endX)-(dfdx(end)*x(end)))+FofX(end); % calculate high x using linear approximation
            subplot(4,1,3) %set up / update subplot 3
            plot([startX endX], [y1 y2]);
            grid on
            title('Current Linear Approximation')
            axis(comAxis) % end subplot 3
            subplot(4,1,4) %set up / update subplot 4
            plot([startX endX], [y1 y2]);
            grid on
            hold on
            title('All Linear Approximations')
            axis(comAxis) % end subplot 4
        else
            i=1; %counter reset
            x=startX; %x reset
            dfdx=0; % dfdx reset
            subplot(4,1,2); %subplot 2 reset
            cla; 
            dfdxPlot = plot(x,dfdx);%end subplot 2 reset
            subplot(4,1,4); %subplot 4 reset
            cla;
            tic; %reset stop clock
        end
        drawnow;
    end
catch %setting up/running program failed, give user error message and terminate
    errorMessage=msgbox('Error with function or limits');
    pause(1); % pause for 1 sec to let user see error message
    try % try to delete msgbox if it has not been removed by user
        delete(errorMessage);
    catch
    end
end

%%
close gcf % close current figure and end program
end
