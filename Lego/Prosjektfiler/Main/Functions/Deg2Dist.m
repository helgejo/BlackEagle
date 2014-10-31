    function [out] = Deg2Dist(deg)
        WheelCirc = 56*pi;
        out =  WheelCirc*(deg/360);
    end