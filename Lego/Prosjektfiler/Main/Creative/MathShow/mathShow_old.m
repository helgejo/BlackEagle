function mathShow()
%Animate nummeric integration and derivation
%   

%%
%user defines function
defFunct = 1;
x=[];
y = '';
while defFunct
    switch menu(['Formel: ' char(y)],'x','number','+','-','*','/','^','sin(x)','cos(x)','tan(x)','exp(x)','log(x)','freetext','backspace','reset','done')
        case 1
            y(end+1) = 'x';
        case 2
            switch menu('Number: ','1','2','3','4','5','6','7','8','9','0',',')
                case 1
                    y(end+1) = '1';
                case 2
                    y(end+1) = '2';
                case 3
                    y(end+1) = '3';
                case 4
                    y(end+1) = '4';
                case 5
                    y(end+1) = '5';
                case 6
                    y(end+1) = '6';
                case 7
                    y(end+1) = '7';
                case 8
                    y(end+1) = '8';
                case 9
                    y(end+1) = '9';
                case 10
                    y(end+1) = '0';
                case 11
                    y(end+1) = '.';
            end
        case 3
            y(end+1) = '+';
        case 4
            y(end+1) = '-';
        case 5
            y = [y '.*'];
        case 6
            y = [y './'];
        case 7
            y = [y '.^'];
        case 8
            y = ['sin(' y ')'];
        case 9
            y = ['cos(' y ')'];
        case 10
            y = ['tan(' y ')'];
        case 11
            y = ['exp(' y ')'];
        case 12
            y = ['log(' y ')'];
        case 13
            initialFig(1);
            annotation('textbox', [0.1,0.9,0.75,0.05],'backgroundcolor', 'w', 'String', y);
            run = 1;
            shift=0;
            while run
                drawnow;
            end
        case 14
            y = y(1:end-1);
        case 15
            y = '';
        case 16
            try
                temp = eval(y);
                defFunct = 0;
            catch
                annotation('textbox', [0.1,0.9,0.75,0.05],'backgroundcolor', 'w', 'String', 'Equation not accept');
                pause(1);
                close gcf;
            end
    end
end

%%
%user defines limits
defLow = 1;
lowLim = '';
while defLow;
    switch menu(['Define lower limit: ' lowLim],'1','2','3','4','5','6','7','8','9','0','.','-','backspace','done')
        case 1
            lowLim(end+1) = '1';
        case 2
            lowLim(end+1) = '2';
        case 3
            lowLim(end+1) = '3';
        case 4
            lowLim(end+1) = '4';
        case 5
            lowLim(end+1) = '5';
        case 6
            lowLim(end+1) = '6';
        case 7
            lowLim(end+1) = '7';
        case 8
            lowLim(end+1) = '8';
        case 9
            lowLim(end+1) = '9';
        case 10
            lowLim(end+1) = '0';
        case 11
            lowLim(end+1) = '.';
        case 12
            lowLim(end+1) = '-';
        case 13
            lowLim = lowLim(1:end-1);
        case 14
            if(length(lowLim)>0)
                defLow = 0;
            end
    end
end

defHigh = 1;
highLim = '';
while defHigh
    switch menu(['Define high limit: ' highLim],'1','2','3','4','5','6','7','8','9','0','.','-','backspace','done')
        case 1
            highLim(end+1) = '1';
        case 2
            highLim(end+1) = '2';
        case 3
            highLim(end+1) = '3';
        case 4
            highLim(end+1) = '4';
        case 5
            highLim(end+1) = '5';
        case 6
            highLim(end+1) = '6';
        case 7
            highLim(end+1) = '7';
        case 8
            highLim(end+1) = '8';
        case 9
            highLim(end+1) = '9';
        case 10
            highLim(end+1) = '0';
        case 11
            highLim(end+1) = '.';
        case 12
            highLim(end+1) = '-';
        case 13
            highLim = highLim(1:end-1);
        case 14
            if(length(highLim)>0 && str2num(highLim) >= str2num(lowLim))
                defHigh = 0;
            elseif str2num(highLim) < str2num(lowLim)
                annotation('textbox', [0.1,0.9,0.75,0.05],'backgroundcolor', 'w', 'String', 'High limit must be higher and lower limit');
                pause(1);
                close gcf;
            end
    end
end

%%
% Initiate figure
    function initialFig(choice)
        screen = get(0,'screensize');
        figure('Position',[screen(3)/6, screen(4)/6,screen(3)/1.5, screen(4)/1.5]);
        if choice ==1
            set(gcf, 'KeyPressFcn', @keyDownListener1, 'KeyReleaseFcn', @keyUpListener);
        elseif choice == 2
            set(gcf, 'KeyPressFcn', @keyDownListener2, 'Name', 'Press any key to continue');
        end
    end

%%
% keyDownListener for freetext function
    function keyDownListener1(src, event)
        event.Key
        switch event.Key
            case 'return'
                run=0;
                close gcf;
            case 'backspace'
                y=y(1:end-1);
            case 'shift'
                shift=1;
            case 'period'
                y(end+1) = '.';
            case 'add'
                y(end+1) = '+';
            case 'subtract'
                y(end+1) = '-';
            case 'divide'
                y = [y './'];
            case 'multiply'
                y = [y '.*'];
            otherwise
                if ~shift
                    y(end+1) = event.Key;                    
                elseif event.Key == '8'
                    y(end+1) = '(';
                elseif event.Key == '9'
                    y(end+1) = ')';
                end
        end
        if run
            annotation('textbox', [0.1,0.9,0.75,0.05],'backgroundcolor', 'w', 'String', y);
        end
    end

%%
% keyuplistener for freetext
    function keyUpListener(src, event)
        try
        switch event.Key
            case 'shift'
                shift=0;
        end
        catch
        end
    end
%%
% KeyDownListener to stop program with esc button
    function keyDownListener2(src, event)
        run = 0;
    end

%%
% main while
initialFig(2);
run = 1;
hLim = str2num(highLim);
lLim = str2num(lowLim);
x=lLim:0.01:hLim;
FofX=eval(y);
comAxis=[lLim hLim min(FofX) max(FofX)];
subplot(4,1,1);
plot(x,FofX);
title(['Function graph:'])
axis(comAxis);
subplot(4,1,4);
bar(x,FofX);
title('Sum of integral for entire defined area:')
axis(comAxis);
maxTime = hLim - lLim;
x=lLim;
subplot(4,1,3);
title('Sum of integral from lower limit (starting point) until now:');
hold on
axis(comAxis);
tic;
i=1;
while run
    t=toc;
    if t <= maxTime
        x(end+1) = x(1)+t;
        i=i+1;
        FofX=eval(y);
        subplot(4,1,2);
        fill([x(i-1) x(i) x(i) x(i-1)], [0 0 FofX(i) FofX(i)], 'b')
        axis(comAxis);
        title(['deltaX(' num2str(x(end)-x(end-1)) 's)*f(x)']);
        subplot(4,1,3);
        fill([x(i-1) x(i) x(i) x(i-1)], [0 0 FofX(i) FofX(i)], 'b')                
    else
        i=1;
        x=lLim;
        subplot(4,1,3)
        cla;
        tic;
    end
    drawnow;
end
%%
close gcf
end

