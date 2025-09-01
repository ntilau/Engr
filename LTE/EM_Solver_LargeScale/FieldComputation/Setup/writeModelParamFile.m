function writeModelParamFile(...
    Model, fExp, nMaterialParams, isImpForm, nPorts)

fname = strcat(Model.resultPath, 'modelParam.txt');
fid = fopen(fname, 'w');
if fid == -1
    error('Could not open file %s', fname);
end

fprintf(fid, 'f0\t%1.15e\n', fExp);
fprintf(fid, 'numMaterialParams\t%d\n', nMaterialParams);

if isImpForm
    abc = 'no';
else
    abc = 'yes';
end
fprintf(fid, 'ABC\t%s\n', abc);
fprintf(fid, 'NumLeftVecs\t%d\n', nPorts);

fclose(fid);