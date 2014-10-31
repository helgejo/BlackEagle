    function [out] = LtoHZ(l)
        x= 13800/1023;
        out = ((x * l)+200)/2
        if out > 10000
            out = 10000
        end
        
        if out < 2500
            out = 2500
        end
    end