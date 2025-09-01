% Scale frequency from XHz to Hz
function hzFactor = scale2Hz(Xhz)

xhz = lower(Xhz);

switch xhz 
    case 'khz'
        hzFactor = 1e3;    
    case 'mhz'
        hzFactor = 1e6;
    case 'ghz'
        hzFactor = 1e9;
    otherwise
        hzFactor = 1;
end
        
   