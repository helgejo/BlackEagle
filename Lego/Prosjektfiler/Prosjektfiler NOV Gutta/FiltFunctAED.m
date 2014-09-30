function out = FiltFunct( inp )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
% temp=0;
% if length(inp) >= 20 ;
%    for i = 0:19
%        temp = inp(end-i)+temp;
%    end
%    out = temp/20;
% else
%    % out=inp(end);
% end
out = inp(end) * 0.1 + inp(end-1) * 0.9 ;

end

