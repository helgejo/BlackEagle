function [out] = test()
WheelCirc = 56*pi
dist = 32;
   function [out] = Dist2Deg(dist)
        out = (dist/ WheelCirc)*360;
   end
Dist2Deg(dist)
end