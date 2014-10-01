function out = filtJoy(in)
%Filter joystick input
% less than 2 = 0
% 40% from new value, 60% form old
if length(in) > 1
    if in(end) < 2  && in(end) > -2
    out = 0;
    else
        out = 0.4*in(end)+0.6*in(end-1);
    end
else
    out = 0;
end
end

