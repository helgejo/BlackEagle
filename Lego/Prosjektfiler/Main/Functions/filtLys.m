function out = filtLys(in)
%Filtrerer en input vektor til et tall ut
%  
temp = in(end)-in(end-1);
if temp < 2 && temp > -2
    out = in(end-1);
else
    out = 0.6*in(end)+0.4*in(end-1);
end
end

