function PlotTime()
%Illustrate how much time different ways of plotting takes pr run through the loop.
%   plot() call each time
%   set with datasets
%   refreshdata
%%
% Initiate figure
screen = get(0,'screensize');
figure('Position',[screen(3)/6, screen(4)/6,screen(3)/1.5, screen(4)/1.5]);
set(gcf, 'KeyPressFcn', @keyDownListener, 'Name', 'Press any key to continue');

%%
% KeyDownListener to stop program with esc button
    function keyDownListener(src, event)
        run = 0;
    end

%%
%Initialte variables
run = 1;
plotTime = [0];
setTime = [0];
refreshTime = [0];
loops = [0];
avgPT = [0];
avgST = [0];
avgRT = [0];
subplot(3,1,1)
hold on;
plotplot = plot(loops,plotTime, '-b');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time to plot in s');
subplot(3,1,2)
hold on;
setPlot = plot(setTime, loops, '-r');
set(setPlot,'Ydata', setTime, 'Xdata', loops);
xlabel('Number of times through the loop/size of time vector');
ylabel('Time to plot in s');
subplot(3,1,3)
hold on
refreshPlot = plot(refreshTime, loops,'-g');
set(refreshPlot, 'YDataSource', 'refreshTime', 'XDataSource', 'loops');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time to plot in s');
drawnow;

%%
%main loop, displaying the plot time realtime
while run
    subplot(3,1,1)
    time = cputime;
    plotplot = plot(loops,plotTime, '-b');
    plotTime(end+1) = cputime - time;
    avgPT(end+1) = sum(plotTime)/(length(plotTime)-1);
    title(['Plot average time: ' num2str(avgPT(end)) 's']);
    
    subplot(3,1,2)
    time = cputime;
    set(setPlot,'Ydata', setTime, 'Xdata', loops);
    setTime(end+1) = cputime - time;
    avgST(end+1) = sum(setTime)/(length(setTime)-1);
    title(['Set plot average time: ' num2str(avgST(end)) 's']);
    
    subplot(3,1,3)
    time = cputime;
    refreshdata(refreshPlot, 'caller')
    refreshTime(end+1) = cputime - time;
    avgRT(end+1) = sum(refreshTime)/(length(refreshTime)-1);
    title(['Refresh plot average time: ' num2str(avgRT(end)) 's']);
    
    loops(end+1) = loops(end) + 1;
    drawnow;
end

%%
%Finally display
clf;
comAxis = [0 loops(end) -0.0001 (max([avgPT avgST avgRT])+0.0001)];
subplot(3,1,1)
plot(loops,avgPT,'-b');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time in seconds');
title(['Average time to plot using plot function: ' num2str(avgPT(end)) 's']);
axis(comAxis);

subplot(3,1,2)
plot(loops,avgST,'-r');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time in seconds');
title(['Average time to plot using set function: ' num2str(avgST(end)) 's']); 
axis(comAxis);

subplot(3,1,3)
plot(loops,avgRT,'-g');
xlabel('Number of times through the loop/size of time vector');
ylabel('Time in seconds');
title(['Average time to plot using refreshdata function: ' num2str(avgRT(end)) 's']); 
axis(comAxis);

run = 1;
while run
    drawnow;
end

%%
% end the program
close gcf;
end

