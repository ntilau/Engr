% Determine whether TESTNAME is valid variable name. 
% Concatenates a valid PREFIX if it is not.
function name = makeValidVarName(testName, prefix)

% convert prefix to lower case
prefix = lower(prefix);

if ~isvarname(testName)
    name = strcat(prefix, testName); 
else
    name = testName;
end

if ~isvarname(name)
    error('''%s'' is not a valid variable name', name);
end