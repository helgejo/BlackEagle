    function [out] = Lfilter(in, Prec)
        %Filtrerer en input vektor til et tall ut  
        temp = in(end)-in(end-1);
        % if change is less than +-Prec then take last value instead
        if temp < Prec && temp > -Prec
            out = in(end-1);
        % else take the new light reading
        else
            out = in(end);
        end
    end