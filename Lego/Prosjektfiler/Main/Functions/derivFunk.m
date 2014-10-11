function out = derivFunk(x,y)
%deriverer endrng i y delt på endring i y
%   y: vektor
%   dy: endring mellom siste og nest siste verdi i y
%   x: vektor
%   dx: endring mellom siste og nest siste verdi i x
    dy=y(end)-y(end-1);
    dx=x(end)-x(end-1);
    if dx==0
        dx=0.01;
    end
    out=dy/dx;
end