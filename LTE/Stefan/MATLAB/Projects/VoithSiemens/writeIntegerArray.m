function writeIntegerArray(fId, intArray)


% begin block
fprintf(fId, '{ AI %i ', length(intArray));
for intCnt = 1 : length(intArray)
  fprintf(fId, '%i ', intArray(intCnt));
end
% end block
fprintf(fId, '}\n');

