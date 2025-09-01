% Ermitteln des Faktors zur Frequenzumrechnung in Hz
% String Xhz -> umzurechnende Einheit
function hzFactor = to_hz(Xhz)

xhz = lower(Xhz);

switch xhz 
    case 'mhz'
        hzFactor = 1e6;
    case 'khz'
        hzFactor = 1e3;
    case 'ghz'
        hzFactor = 1e9;
    otherwise
        hzFactor = 1;
end
        
   