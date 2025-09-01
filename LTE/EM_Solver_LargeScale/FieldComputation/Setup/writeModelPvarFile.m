function writeModelPvarFile(Model, fCutOff, nMaterialParams)

fname = strcat(Model.resultPath, 'model.pvar');
fid = fopen(fname, 'w');
if fid == -1
    error('Could not open file %s', fname);
end

nFreqs = length(fCutOff);
fprintf(fid, 'fCutOff { AR %d\n', nFreqs);


for k = 1:nFreqs
    fprintf(fid, '\t%1.15e\n', fCutOff(k));
end
fprintf(fid, '}\n');
fprintf(fid, 'numMaterialParams\t%d', nMaterialParams);

fclose(fid);