function [flag dd] = checkforOverwrite

global running

animal = get(findobj('Tag','animaltxt'),'String');
unit   = get(findobj('Tag','unittxt'),'String');
expt   = get(findobj('Tag','expttxt'),'String');
datadir= get(findobj('Tag','datatxt'),'String');

dd = [datadir '\' lower(animal) '\u' unit '_' expt]

flag = 0;

if(exist(dd))
    warndlg('Directory exists!!!  Make sure you are not overwritting old data!  Please check current animal, unit and expt values.  I will now abort this sampling request.','!!! Warning !!!')
    flag = 1;
end
