%%%illuminator serial 
% Armel commented all because illumination is not here yet
sit = serial('COM1','Tag','ilser','Terminator','CR','DataTerminalReady',...
    'on','RequestToSend','on');
fopen(sit);
handles.sit = sit;
