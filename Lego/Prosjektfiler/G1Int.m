% Function for integration
% Responsible: Espen / Daniel

function [LysUt,TidUt,AUt] = G1Int(Lys,Tid,A,nullpunkt)
 
%% error check
 kL = length(Lys);
 kT = length(Tid);
 kA = length(A);
 if or(k ~= kT,k ~= kA, kT ~= kA)
     error('error input parameters have different size')
 end
 
 %% Perform integration to find Area
 k=kL+1
 Lys(k)   = GetLight(SENSOR_3);          % ny m?ling av lys
 Tid(k)   = rem(now,1);                  % ny tidsverdi
 Ts(k-1)  = Tid(k)-Tid(k-1);             % beregn tidsskritt i sekund
 avvik(k-1) = Lys(k-1)-nullpunkt;        % beregn avvik fra nullpunkt
 A(k)     = A(k-1) + avvik(k-1)*Ts(k-1); % numerisk integrerer
 
 %% Set out parameters
 LysUt = Lys;
 TidUt = Tid;
 AUt   = A;
 
 
end
