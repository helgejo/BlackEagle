function Out = filtrer(time,In,OldOut,i,orden,para)

% her kan de lage all slags tester på riktig format

switch orden
    case 1
        if size(time,1)>1
            Out = para(1)*In(i) + (1-para(1))*OldOut(i-1);
        end
    case 2
        if size(time,1)>2
            Out = para(1)*In(i)...
                + (1-para(1))*OldOut(i-1) ...
                + (1-para(1)-para(2))*OldOut(i-2);
        end
end        