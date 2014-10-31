prompt={'How long in ms should the sound play per cm? Default is 1000 (1cm=1s). Higher number give longer tones',...
        'Input robot speed? Default is 10 and maks is 100',...
        'Input robot light reading precision between 0 - 100? Lower number is more accurate. Default is 75'};
name='Input for light to music function';
numlines=1;
defaultanswer={'1000','10','75'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
