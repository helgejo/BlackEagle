function intOut = intFunk(x,y)
%integrer med hensyn på x vektorene x og y rundt nullpunkt np.
%   x: tid
%   y: verdi
%   sum: summen intergralet x-1.
    dt=x(end)-x(end-1);
    intOut=y(end-1)*dt;
end

