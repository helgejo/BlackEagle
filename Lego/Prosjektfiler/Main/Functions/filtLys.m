function out = filtLys(in)
%Filtrerer en input vektor til et tall ut
%  
temp = in(end)-in(end-1);
% if change is less than +-2 then take last value
if temp < 2 && temp > -2
    out = in(end-1);
% filter joy input
else
    out = 0.6*in(end)+0.4*in(end-1);
end
end

