function plotTime()
%Illustrate how much time different ways of plotting takes pr run through the loop.
%   Subplot 1: plot() call each time
%   Subplot 2: set with X and Y data
%   Subplot 3: refreshdata
%   End with summary display

%%
% Initiate figure
screen = get(0,'screensize');
figure('Position',[screen(3)/6, screen(4)/6,screen(3)/1.5, screen(4)/1.5]);
set(gcf, 'KeyPressFcn', @keyDownListener, 'Name', 'Press any key to continue');

%%
% KeyDownListener to stop program any button
    function keyDownListener(src, event)
        run = 0;
    end

%%
%Initialte variables
run = 1;
plotTime = [0]; % time vector for plot
setTime = [0]; % time vector for set
refreshTime = [0]; % time vector for refresh
loops = [0]; % vector for number of loops
avgPT = [0]; % vector for average plot time
avgST = [0]; % vector for average set time
avgRT = [0]; % vector for average refresh time
subplot(3,1,1) % set up subplot 1 for plot
hold on;
plotplot = plot(loops,plotTime, '-b');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time to plot in s'); % end setup of subplot 1
subplot(3,1,2) % set up subplot 2 for set
hold on;
setPlot = plot(setTime, loops, '-r');
set(setPlot,'Ydata', setTime, 'Xdata', loops);
xlabel('Number of times through the loop/size of time vector');
ylabel('Time to plot in s'); % end setup of subplot 2
subplot(3,1,3) % set up subplot 3 for refresh
hold on
refreshPlot = plot(refreshTime, loops,'-g');
set(refreshPlot, 'YDataSource', 'refreshTime', 'XDataSource', 'loops');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time to plot in s'); % end setup of subplot 3
drawnow; % force the plots to draw

%%
%main loop, displaying the plot time realtime
tic; % start stop clock
while run
    subplot(3,1,1) % plot function
    time = toc; %time before plot
    plotplot = plot(loops,plotTime, '-b'); % do the plot
    plotTime(end+1) = toc - time; % time after plot
    avgPT(end+1) = sum(plotTime)/(length(plotTime)-1); % calculate average
    title(['Plot average time: ' num2str(avgPT(end)) 's']);
    
    subplot(3,1,2) % set plots
    time = toc; %time before plot
    set(setPlot,'Ydata', setTime, 'Xdata', loops); % do the plot
    setTime(end+1) = toc - time; % time after plot
    avgST(end+1) = sum(setTime)/(length(setTime)-1); % calculate average
    title(['Set plot average time: ' num2str(avgST(end)) 's']);
    
    subplot(3,1,3) % refresh plot
    time = toc; % time before plot
    refreshdata(refreshPlot, 'caller') % do the plot
    refreshTime(end+1) = toc - time; % time after plot
    avgRT(end+1) = sum(refreshTime)/(length(refreshTime)-1); % calculate average
    title(['Refresh plot average time: ' num2str(avgRT(end)) 's']);
    
    loops(end+1) = loops(end) + 1; % update number of loops
    drawnow; % force plots to draw
end

%%
%Summary display
clf; % clear current figure
comAxis = [0 loops(end) -0.0001 (max([avgPT avgST avgRT])+0.0001)]; % set common axis
subplot(3,1,1) % plot average time for plot
plot(loops,avgPT,'-b');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time in seconds');
title(['Average time to plot using plot function: ' num2str(avgPT(end)) 's']);
axis(comAxis);

subplot(3,1,2) % plot average time for set
plot(loops,avgST,'-r');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time in seconds');
title(['Average time to plot using set function: ' num2str(avgST(end)) 's']); 
axis(comAxis);

subplot(3,1,3) % plot average time for refresh
plot(loops,avgRT,'-g');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time in seconds');
title(['Average time to plot using refreshdata function: ' num2str(avgRT(end)) 's']); 
axis(comAxis);

run = 1;
while run % show until user is ready to continue, controlled by keydownlistener
    drawnow;
end

%%
% end the program
close gcf;
end

