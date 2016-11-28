function [] = FPTaylor_file( C, V, D, E )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
LC = size(C,1);
LV = size(V,1);
LD = size(D,1);
LE = size(E,1);

filestring = 'Constants\n';
filename = fopen('FPTinput.txt','w');

for i = 1:LC
    filestring = [filestring,'\t',C{i,1},' = ',char(C{i,2})];
    if i == LC
        filestring = [filestring,'\n;\n\n'];
    else
        filestring = [filestring,',\n'];
    end
end

filestring = [filestring,'Variables\n'];
for v = 1:LV
    filestring = [filestring,'\t',V{v,1},' ',V{v,2},' in [',num2str(V{v,3}),']'];
    if v == LV
        filestring = [filestring,'\n;\n\n'];
    else
        filestring = [filestring,',\n'];
    end    
end

filestring = [filestring,'Definitions\n'];
for d = 1:LD
    filestring = [filestring,'\t',D{d,1},' ',D{d,2},'= ',char(D{d,3})];
    if d == LD
        filestring = [filestring,'\n;\n\n'];
    else
        filestring = [filestring,',\n'];
    end
end

filestring = [filestring,'Expressions\n'];
for e = 1:LE
    filestring = [filestring,'\t',E{e,1}];
    if e == LE
        filestring = [filestring,'\n;\n\n'];
    else
        filestring = [filestring,',\n'];
    end
end

fprintf(filename,filestring);
fclose(filename);
end

