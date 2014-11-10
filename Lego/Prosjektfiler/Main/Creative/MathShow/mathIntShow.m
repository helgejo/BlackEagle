function mathIntShow()
%Animate nummeric integration
%   Allow user to define a function of x
%   User defines lower and higher limits of the integral
%   Subplot 1: Show the function graph
%   Subplot 2: Show the current loops addition to the integral
%   Subplot 3: Show the integral from the lower limit until the current
%   loop
%   Subplot 4: Show the integral for the entire defined area
%   Subplot 5: Graph for integral of f(x)

%%
%user defines function
userInputs = inputdlg({'Define function with variable x: ', 'Define lower limit: ', 'Define higher limit: '}, 'User inputs', 1, {'','',''});
y = char(userInputs(1)); %function to be integrated
lowLim = char(userInputs(2)); %lower limit of integral (in string form)
highLim = char(userInputs(3)); %higher limit of integral (in string form)

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
try %try settinging up and running the program
    hLim = str2num(highLim); %convert higher limit to number
    lLim = str2num(lowLim); % convert lower limit to number
    if hLim < lLim %make sure higher limit is higher than lower limit
        temp = hLim;
        hLim = lLim;
        lLim = temp;
    end
    increment = 0.001; %increment for the initial x vector
    x=lLim:increment:hLim; %define an x vector with steps of 0.001, to be used in initial calculations
    while length(x) > 10000 %code to ensure the x vector does not get to big for the program
        increment = increment + 0.001;
        x=lLim:increment:hLim;
    end
    FofX=eval(y); %convert function from string to matlab expression thus creating a vector based upon the defined x vector
    comAxis=[lLim hLim min(FofX) max(FofX)]; %create a common axis for all plots
    sumInt = 0; %Sum of integral variable, to be used both for showing the sum of the entire integral and from startingpoint until now
    for i = 2:length(x) %create a sum for the entire integral. (nummeric integration)
        sumInt = sumInt + FofX(i)*(x(i)-x(i-1));
    end
    subplot(5,1,1); % set up subplot 1 to show the graph of the function
    plot(x,FofX);
    title(['Function graph: f(x)=' y])
    axis(comAxis); %end of subplot 1
    subplot(5,1,4); %set up subplot 4 to show the integral of the entire function
    bar(x,FofX);
    title(['Sum of integral for entire defined area: ' num2str(sumInt)])
    axis(comAxis); %end of subplot 4
    subplot(5,1,3); %set up sublpot 3 to show the integral as far as the program has come
    title('Sum of integral from lower limit (starting point) until now:');
    hold on
    axis(comAxis); %end of subplot 3
    IntofF = 0;
    x=lLim; %set x vector to start at lower limit
    subplot(5,1,5);% set up subplot 5
    intPlot = plot(x,IntofF);
    grid on;
    title('Integral of f(x): '); %end set up subplot 5
    maxTime = hLim - lLim; %define the max for the x vector
    sumInt = 0; %reset sum of integral variable to use for starting point until now sum.
    run = 1; %variable to run the main loop, stops by keydownlistner
    i=1; %counter
    tic; %start stop clock
    while run %main loop
        t=toc;  %get current time on stop clock
        if t <= maxTime %if current time within the defined limits, update plots
            x(end+1) = x(1)+t; %update time (x-vector)
            i=i+1; %update counter
            FofX=eval(y); % recreate the function vector based upon the updated x vector
            currentInt = FofX(i)*(x(i)-x(i-1)); %calculate the current loops integration value
            IntofF(end+1) = IntofF(end) + currentInt; %add the current loops integration value to the sum from starting point until now
            subplot(5,1,2); %subplot 2 showing a bar of the current loops integration value
            fill([x(i-1) x(i) x(i) x(i-1)], [0 0 FofX(i) FofX(i)], 'b')
            axis(comAxis);
            title(['deltaX(' num2str(x(end)-x(end-1)) 's)*f(x)=' num2str(currentInt)]); %end of subplot 2
            subplot(5,1,3); %subplot 3 add the current loops integral bar to the sum from starting point until now
            fill([x(i-1) x(i) x(i) x(i-1)], [0 0 FofX(i) FofX(i)], 'b')
            title(['Sum of integral from lower limit (starting point) until now: ' num2str(IntofF(end))]); %end subplot 3
            subplot(5,1,5) %update subplot 5
            set(intPlot, 'Ydata', IntofF, 'Xdata', x);
            axis([comAxis(1) comAxis(2) (min(IntofF)-0.1) (max(IntofF)+0.1)]);  % end update subplot 5
        else %x value exceeds the limits of the integral, reset and start at the begining
            i=1; % counter reset
            x=lLim; % x reset
            sumInt = 0; % sum reset
            IntofF = 0; % reset integral of f(x)
            subplot(5,1,3) % subplot 3 reset
            cla; %end suplot 3 reset
            tic; % reset stop clock
        end
        drawnow; % force graphics to update
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
close gcf %close current figure and end program
end

