function pathshort = LimitPathLength(pathlong,N);
%
%	pathshort = LimitPathLength(pathlong,N)
%
% This function returns a shortened path with length
% limited to N characters. If longer, the middle part of
% pathlong is replaced by three dots ('...'). The beginning
% and ending part of the string are left unchanged.
