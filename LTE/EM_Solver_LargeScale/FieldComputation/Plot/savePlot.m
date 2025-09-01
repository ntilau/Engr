% save plot to different file formats.
% cell-array EXTENSIONLIST contains file extensions to determine,
% which formats should be saved ('jpeg', 'epsc', 'fig', ...)
function savePlot(figHandle, fNameRaw, extensionList)

nFigs = length(figHandle);
for  iFig = 1:nFigs    
    % remain figure size for export
    set(figHandle(iFig), 'PaperPositionMode','auto');
    
    if nFigs > 1
        fName = sprintf('%s_%d', fNameRaw, iFig);
    else
        fName = sprintf('%s', fNameRaw);
    end
    
    for k = 1:length(extensionList)
        ext = extensionList{k};
        if strcmp(ext, 'fig')
            saveas(figHandle(iFig), fName, 'fig');
        else
            ext = sprintf('-d%s', ext);
            print(figHandle(iFig), ext, fName);
        end
    end
end


