    function [out] = LtoHZ(l)
        x= 13800/1023;
        out = ((x * l)+200)/2;
        if out > 14000;
            out = 14000;
        end
        
        if out < 200;
            out = 200;
        end
    end