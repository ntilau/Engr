% Read S-Parameter produced by EM_WaveSolver
function Dum = lteWsScatParamReader(file)

fid = fopen(file, 'r');

if fid == -1 
    fprintf('File %s not found', file);
    Dum = 0;
    return;
end


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
    
    if mod(lineCnt, port_dim) == 1 || port_dim == 1
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
        S{row,col}(s_mat_cnt,1) = re + 1i * im;
    end
end

% ascending order of frequencies
if (f(1) > f(end))
    f = fliplr(f);
    for ii = 1:port_dim
        for jj = 1:port_dim
            S{ii,jj} = fliplr(S{ii,jj}.');
        end
    end
end


% fields are named corresponding to IdEM-standard
Dum.Nports = port_dim;
Dum.pindex = ones(port_dim);

Dum.isreciprocal = 0;
Dum.istime = 0;
Dum.isfreq = 1;
Dum.Creator = 'lte_ws2DUM';
Dum.Comments = '';
Dum.ImpedanceUnits = 'Ohm';
Dum.Name = 'sParam';
Dum.FrequencyUnits = 'Hz';
Dum.R0 = 50;
Dum.f = f';
Dum.Fmax = f(end);
Dum.S = S.';
Dum.sMat = sortNetworkParamsByMatrices(Dum.S);

fclose(fid);


