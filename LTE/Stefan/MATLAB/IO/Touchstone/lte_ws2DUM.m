% Konvertieren des LTE_WaveSolver-S-Parameter-Datenformats in
% TouchStone/DUM
% Daten werden in dB, Hz, Ohm rausgeschrieben
%
% string data_path:     Pfad zur LTE-Datei
% string fname:         Name der LTE-Datei (ohne Endung)
% double resistance     Portimpedanz (Ohm) 
function dum = lte_ws2DUM(data_path, fname, resistance)

% Verzeichnis beinhaltet den eigentlichen Konverter
addpath('..\idem_pcode');

output_path = '';

lte_fname = sprintf('%s\\%s.txt', data_path, fname);

fid = fopen(lte_fname, 'r');


lineCnt = 0;
while 1
    
    s_line = fgetl(fid);
    
    if ~ischar(s_line)
        break;
    elseif strcmp(strtrim(s_line), '')
        continue;      
    end
       
    lineCnt = lineCnt + 1;    
    
    freq = sscanf(s_line, '%f', 1);
    spacePos = strfind(s_line, ' ');
    s_line = strtrim(s_line(spacePos(3)+1:end));

    clear spacePos;
    spacePos = strfind(s_line, ' ');
    
    if (lineCnt == 1)
        % calculate number of ports
        port_dim = 0.5 * (length(spacePos) + 1);
    end
    
    s_mat_cnt = ceil(lineCnt/port_dim);
    row = mod(lineCnt, port_dim);
    if row == 0
        row = port_dim;
    end
    
    if mod(lineCnt, port_dim) == 1
        f(s_mat_cnt) = freq;
    end
    
    openParanthesesPos = strfind(s_line, '(');
    commaPos = strfind(s_line, ',');
    closeParanthesesPos = strfind(s_line, ')');

       
    for col = 1:port_dim
        re = strtrim(s_line(openParanthesesPos(2*col)+1:commaPos(col)-1));
        re = str2double(re);
        im = strtrim(s_line(commaPos(col)+1:closeParanthesesPos(2*col)-1));
        im = str2double(im);
        S{row,col}(s_mat_cnt) = re + i*im;
    end
end

% aufsteigende Ordnung bzgl. Frequenz
if (f(1) > f(end))
    f = fliplr(f);
    for ii = 1:port_dim
        for jj = 1:port_dim
            S{ii,jj} = fliplr(S{ii,jj});
        end
    end
end

dum.Nports = port_dim;
dum.pindex = ones(port_dim);

dum.isreciprocal = 0;
dum.istime = 0;
dum.isfreq = 1;
dum.Creator = 'lte_ws2DUM';
dum.Comments = '';
dum.ImpedanceUnits = 'Ohm';
dum.Name = fname;
dum.FrequencyUnits = 'Hz';
dum.R0 = resistance;
dum.f = f;
dum.Fmax = f(end);
dum.S = S;

fclose(fid);

DUM2TouchStone(output_path, fname, dum);

