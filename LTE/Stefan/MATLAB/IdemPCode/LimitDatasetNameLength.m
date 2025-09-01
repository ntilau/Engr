function datashort = LimitDatasetNameLength(datalong,N);
%
%	datashort = LimitDatasetNameLength(datalong,N)
%
% CG, 9-09-2005
% This function returns a shortened dataset name with length
% limited to N characters. If longer, the middle part of
% datalong is replaced by three dots ('...'). The beginning
% and ending part of the string are left unchanged.
% A check is done to make sure the fixed part of the
% string ('Current dataset: ') is not cut.
% This function is called in the Resize function of
% the figures containing a text control showing the DUM
% name and when a daughter figure updates the mother figure
% with a new DUM name (i.e. the daughters of data_operations.fig)
