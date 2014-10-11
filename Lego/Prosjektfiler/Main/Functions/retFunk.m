function out = retFunk(in,p)
%Finner rettningsendringer dersom ingen endring   
    if in<0
        out=-1;
    elseif in>0
        out=1;
    else
        out=p;
    end
end

