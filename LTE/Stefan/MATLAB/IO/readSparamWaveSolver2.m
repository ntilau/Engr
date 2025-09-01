function [f S] = readSparamWaveSolver2(lteFileName)

fid = fopen(lteFileName, 'r');

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

fclose(fid);