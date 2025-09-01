function writeNetworkMatrixLteFormat(mat, freq, filename)

if ~isempty(freq) && ~isempty(mat)    
    fid = fopen( filename, 'w' );
    
    fprintf(fid, 'Number of parameters: %i \n', 1);
    fprintf(fid, 'FREQUENCY %i \n', length(freq));
    
    [nRows nCols] = size(mat{1});
    fprintf(fid, 'Dimensions scattering matrix: %i %i \n', nRows, nCols);
    
    
    for fCnt = 1:length(freq)
        cmdStr = 'fprintf(fid,''%e ';
        data = [];
        data(1) = freq(fCnt);
        S = mat{fCnt};
        for iRow = 1:nRows
            for iCol = 1:nCols
                data = [data, real(S(iRow,iCol)), imag(S(iRow,iCol))];
                cmdStr = [cmdStr  ' s_' num2str(iRow) '_' num2str(iCol) ...
                    ': (%18.17e, %18.17e) '];
            end
        end
        cmdStr = [cmdStr  ' \n'', data);'];
        eval(cmdStr);
    end
    fclose( fid );
end