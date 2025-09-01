% Konvertieren des LTE_MOR-S-Parameter-Datenformats in TouchStone
% TouchStone/DUM
% Daten werden in dB, Hz, Ohm rausgeschrieben
%
% string data_path:     Pfad zur LTE-Datei
% string fname:         Name der LTE-Datei (ohne Endung)
% double resistance     Portimpedanz (Ohm)
function dum = lte_mor2DUM(data_path, fname, resistance)

% Verzeichnis beinhaltet den eigentlichen Konverter
addpath('..\idem_pcode');

output_path = '';

lte_fname = sprintf('%s\\%s.txt', data_path, fname);

fid = fopen(lte_fname, 'r');

para_line = fgetl(fid);
nrOfParams = strtrim( para_line(strfind(para_line, ':')+1:end) );
nrOfParams = str2double(nrOfParams);

freq_line = fgetl(fid);
freq_line = freq_line(strfind(freq_line, ' ') + 1:end);
nrOfFreqs = str2double(freq_line);

sMat_line = fgetl(fid);
sMat_line = strtrim(sMat_line(strfind(sMat_line, ':') + 1:end));

sMat_rows = strtrim(sMat_line(1:strfind(sMat_line, ' ')));
sMat_cols = strtrim(sMat_line(strfind(sMat_line, ' '):end));
sMat_rows = str2double(sMat_rows);
sMat_cols = str2double(sMat_cols);

nrOfSParams = sMat_rows * sMat_cols;

% read s-parameters
S = cell(sMat_rows, sMat_cols);
lineCnt = 0;
while 1
    
    s_line = fgetl(fid);
    
    if ~ischar(s_line)
        break;
    end
    
    lineCnt = lineCnt + 1;
    
    f(lineCnt) = str2double(s_line(1:strfind(s_line, ' ')-1));

    openParanthesesPos = strfind(s_line, '(');
    commaPos = strfind(s_line, ',');
    closeParanthesesPos = strfind(s_line, ')');

    for ii = 1:sMat_rows
        for jj = 1:sMat_cols
            sParamCnt = (ii-1)*sMat_rows + jj;
            re = strtrim(s_line(openParanthesesPos(sParamCnt)+1:commaPos(sParamCnt)-1));
            re = str2double(re);
            im = strtrim(s_line(commaPos(sParamCnt)+1:closeParanthesesPos(sParamCnt)-1));
            im = str2double(im);
            S{ii,jj}(lineCnt) = re + i*im;
        end
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

dum.Nports = sMat_rows;
dum.pindex = ones(sMat_rows);

dum.isreciprocal = 0;
dum.istime = 0;
dum.isfreq = 1;
dum.Creator = 'lte2DUM';
dum.Comments = '';
dum.ImpedanceUnits = 'Ohm';
dum.Name = fname;
dum.FrequencyUnits = 'Hz';
dum.R0 = resistance;
dum.f = f;
dum.Fmax = f(end);
dum.S = S;

fclose(fid);

% TouchStone-File erzeugen
DUM2TouchStone(output_path, fname, dum);
