% Tests TESTNAME if it is a valid variable name. 
% Concatenates a valid PREFIX if TESTNAME is not valid

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