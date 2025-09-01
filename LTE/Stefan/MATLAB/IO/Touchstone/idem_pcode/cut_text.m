function text_out = cut_text(large_text,initial_line,n_lines);
%
%	text_out = cut_text(large_text,initial_line,n_lines)
%
% Utility function processing a cell array of strings <large_text>
% and returning a smaller cell array of strings <text_out> extracting
% <n_lines> starting from line <initial_line>. Care is taken when
% limits are outside the length of input cell array.
