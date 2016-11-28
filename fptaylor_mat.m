function [ bounds, abs_err ] = fptaylor_mat( file1, file2 )
%fptaylor_mat Summary of this function goes here
%   Detailed explanation goes here
str1 = 'fptaylor -c ';
str2 = ' ';
% file_1 = string(file1);
% file_2 = string(file2);
command = [ str1 file1 str2 file2 ];
[status, cmdout] = system(command);

sprintf('%d\n%d', status, cmdout);

bounds_str = 'Bounds (without rounding): ';
bounds_start = strfind(cmdout, bounds_str);
% bounds_end = bounds_start+length(bounds_str);

abs_err_str = 'Absolute error (approximate): ';
abs_err_start = strfind(cmdout, abs_err_str);
if abs_err_start == 0;
    abs_err_str = 'Absolute error (exact): ';
abs_err_start = strfind(cmdout, abs_err_str);
end

bounds = cmdout(bounds_start:abs_err_start);

abs_err_end = abs_err_start+length(abs_err_str);
abs_err = cmdout(abs_err_start:abs_err_end);

end

