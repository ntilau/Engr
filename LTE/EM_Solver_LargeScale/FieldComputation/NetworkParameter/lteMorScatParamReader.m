% read EM_WaveModelReduction results 
%
% string fName:         file name 
% [double resistance]     Portimpedanz (Ohm)
function Dum = lteMorScatParamReader(fName, resistance)

fid = fopen(fName, 'r');
if fid == -1
    error('File not found: %s\n', fName);
end

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

% read s-parameters
S = cell(sMat_rows, sMat_cols);
lineCnt = 0;
while 1
    
    s_line = fgetl(fid);
    
    if ~ischar(s_line)
        break;
    elseif ischar(s_line)
        s_line = strtrim(s_line);
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
            S{ii,jj}(lineCnt,1) = re + 1i * im;
        end
    end

end

fclose(fid);

% aufsteigende Ordnung bzgl. Frequenz
if (f(1) > f(end))
    f = fliplr(f);
    for ii = 1:port_dim
        for jj = 1:port_dim
            S{ii,jj} = fliplr(S{ii,jj});
        end
    end
end

Dum.Nports = sMat_rows;
Dum.pindex = ones(sMat_rows);

Dum.isreciprocal = 0;
Dum.istime = 0;
Dum.isfreq = 1;
Dum.Creator = 'lte2DUM';
Dum.Comments = '';
Dum.ImpedanceUnits = 'Ohm';
Dum.Name = fName;
Dum.FrequencyUnits = 'Hz';
if nargin > 1
    Dum.R0 = resistance;
else
    Dum.R0 = 50;
end
Dum.f = f;
Dum.Fmax = f(end);
Dum.S = S;
Dum.sMat = sortNetworkParamsByMatrices(S);


