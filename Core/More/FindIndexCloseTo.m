% finding index 
function index = FindIndexCloseTo(array, val)
% This function helps you to find the closest number to a given VALUE in an
% ARRAY 
dist = abs(array - val);
index = find(dist == min(dist));
end

