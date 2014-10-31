    function [out] = Dist2Deg(dist)
        WheelCirc = 56*pi;
        out = (dist/WheelCirc)*360;
    end