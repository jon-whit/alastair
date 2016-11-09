function [] = FPTaylor_file( C, V, D, E )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
LC = size(C,1);
LV = size(V,1);
LD = length(D);
LE = length(E);

filestring = 'Constants\n';
filename = fopen('FPTinput.txt','w')

for i = 1:LC
    filestring = [filestring,'\t',C{i,1},' = ',char(C{i,2})];
    if i == LC
        filestring = [filestring,'\n;\n\n'];
    else
        filestring = [filestring,',\n'];
    end
end

filestring = [filestring,'Variables\n'];
for d = 1:LV
    filestring = [filestring,'\t',V{d,1},' ',V{d,2},' in [',num2str(V{d,3}),']'];
    if d == LV
        filestring = [filestring,'\n;\n\n'];
    else
        filestring = [filestring,',\n'];
    end    
end

fprintf(filename,filestring);

end

