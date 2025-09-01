function dum = createDumStruct(paramMatrix, f, resistance)

dum.Nports = size(paramMatrix, 1);
dum.pindex = ones(dum.Nports);

dum.isreciprocal = 0;
dum.istime = 0;
dum.isfreq = 1;
dum.Creator = 'createDumStruct';
dum.Comments = '';
dum.ImpedanceUnits = 'Ohm';
dum.Name = '';
dum.FrequencyUnits = 'Hz';
dum.R0 = resistance;
dum.f = f;
dum.Fmax = f(end);
dum.S = paramMatrix;

