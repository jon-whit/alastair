function [ bounds, abs_errs ] = fptaylor_mat( config_path, file_path )

cmd = 'fptaylor -c ';

command = [ cmd config_path ' ' file_path ];
[~, cmdout] = system(command);

Cstr = strsplit(cmdout, '\n');

bounds_str = 'Bounds (without rounding): ';
I = strfind(Cstr, bounds_str);
i = ~cellfun(@isempty,I);
outputs = Cstr(i~=0);

bounds = zeros(length(outputs), 2);
for j=1:length(outputs)
    scanned = textscan(outputs{j}, '%s %s %s [%f, %f]');
    bound = scanned(4:5);
    bounds(j, :) = cell2mat(bound);
end


abs_err_str = 'Absolute error (exact): ';
I = strfind(Cstr, abs_err_str);
i = ~cellfun(@isempty,I);
outputs = Cstr(i~=0);

abs_errs = zeros(length(outputs), 1);
for j=1:length(outputs)
    scanned = textscan(outputs{j}, '%s %s %s %f');
    abs_err = scanned{4};
    abs_errs(j, :) = abs_err;
end


end

