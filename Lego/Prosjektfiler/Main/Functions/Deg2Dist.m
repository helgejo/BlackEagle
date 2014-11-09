    function [out] = Deg2Dist(deg)
        WheelCirc = 56*pi; %56mm
        out =  WheelCirc*(deg/360);
    end