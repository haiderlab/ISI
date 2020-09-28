function roots = parseString(rootstring,del)

%Takes a string delimited by 'del', and converts it into a cell array;

if ~strcmp(rootstring(1),del)
    rootstring = [del rootstring];
end
if ~strcmp(rootstring(end),del)
    rootstring = [rootstring del];
end

id = find(rootstring == del);

for i = 1:length(id)-1
    
    roots{i} = strtrim(rootstring(id(i)+1:id(i+1)-1));
    
end