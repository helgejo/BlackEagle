 function [t] = USBPIC()
 loadlibrary mpusbapi _mpusbapi.h alias library;
 vid_pid_norm = libpointer('int8Ptr',[uint8('vid_04d8&pid_000c') 0])
 [PIC_connect] = calllib ('library','MPUSBGetDeviceCount', vid_pid_norm)
 out_pipe = libpointer ('int8Ptr',[uint8('\MCHP_EP1') 0])
 [my_out_pipe] = calllib('library','MPUSBOpen',uint8(0), vid_pid_norm,out_pipe, uint8(0), uint8 (0))
 in_pipe = libpointer ('int8Ptr',[uint8('\MCHP_EP1') 0])
 [my_in_pipe] = calllib('library','MPUSBOpen',uint8(0), vid_pid_norm,in_pipe, uint8 (1), uint8 (0))
 
 
 c=1
 data_in=uint8([0 0 0 0]);
 data_out=uint8([55 112 1 0]);
 
 timespan=100;
 ymin=0;
 ymax=10;
 t(1)=0;
 h=figure('Color',[0.3 0.3 0.3]);
 set(h,'KeyPressFcn',@keyHandler);
 paused=0;
display('Press w or s to change the timespan of the window');
display('Press a or z to change the lowerbound of vertical axis');
display('Press e or r to change the upperbound of vertical axis');
display('Press q to quit');
quit=0;
 
     
     while(paused~=1)
     tic;
      if(calllib('library', 'MPUSBWrite',my_out_pipe, data_out, uint8(1),uint8(64), uint8(1000)))
      [Aa, bb, data_in, dd] = calllib('library','MPUSBRead', my_in_pipe,data_in,uint8(3),uint8(64), uint8(1000));
      
       ADCVal=bitshift(double(data_in(3)),8)+double(data_in(2));
       adc(c,:)=ADCVal*0.00488;
       
        if c>1
            t(c) = toc;
            t(c)=t(c)+t(c-1);
          end
        if c>timespan
        plot(t(c-timespan:c),adc(c-timespan:c))
        xlim([t(c-timespan+1) t(c)]);
         
        else
            plot(t(c),adc(c))
            
        end
        xlabel('Time Elapsed (sec)');
        ylabel('Amplitude');
        ylim([ymin ymax]);
         
        %Samppersec(c,:)=1/(toc);
       
       
        
      end
     c=c+1;
      pause(0.0000000002)
     

 end
 function keyHandler(src,evnt)
        
      if evnt.Character == 'w'
            timespan=timespan+10;
        elseif evnt.Character == 's'
            timespan=max(2,timespan-10);
        elseif evnt.Character == 'a'
            ymin=max(0,ymin-10);
        elseif evnt.Character == 'z'
            ymin=min(ymax-10,ymin+10);
        elseif evnt.Character == 'e'
            ymax=max(ymin+10,ymax-10);
        elseif evnt.Character == 'r'
            ymax=ymax+10;
        elseif evnt.Character == 'p'
            paused = 1;
        elseif evnt.Character == 'q'
            quit=1;
        end
        
 end

 calllib('library','MPUSBClose',my_in_pipe);
 calllib('library','MPUSBClose',my_out_pipe);
 unloadlibrary library;
 end

