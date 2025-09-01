function Param = setParameters(varargin)

if mod(nargin, 2) ~= 0
    error('Number of input arguments must be a multiple of two');
end

Param = struct([]);

for k = 1:(nargin / 2)
    Param(k).name = varargin{2 * k - 1};
    Param(k).val = varargin{2 * k};
end
    