% decompose string STR using delimiters in char-array DELIM
function C = str_explode(str, delim)

C = {};
while true
    [part str] = strtok(str, delim);
    if ~isempty(part)
        C = [C, part];
    else
        break;
    end
end
