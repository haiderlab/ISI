function Stimulator(secondaryIP)

global FrameRate numberOfruns directionValue correctionValue arrayDir

% Number of stim display
vect = [];

if directionValue == 1 % Azimuth
   if correctionValue == 1 % Forward + Backward
       for i = 1:numberOfruns
        vect(end+1) = 0;
        vect(end+1) = 180;
       end
   else % Forward only
       for i = 1:numberOfruns
        vect(end+1) = 0;
       end
   end
   
else % Elevation
    if correctionValue % Forward + Backward
       for i = 1:numberOfruns
        vect(end+1) = 270;
        vect(end+1) = 90;
       end
    else % Forward only
       for i = 1:numberOfruns
        vect(end+1) = 270;
       end
    end
end
% transform to string array
stringVect = '';
for i = 1:length(vect)
    stringVect = [stringVect, ' ', num2str(vect(i))];
end
stringVect(1) = '[';
stringVect(end+1) = ']';
    
arrayDir = stringVect;
%arrayDir = vect;


%Initialize stimulus parameter structures
configurePstate('PG')
configureMstate(secondaryIP);
configureLstate

%Host-Host communication
configDisplayCom    %stimulus computer
FrameRate = 10; % input('Enter frame rate: ');
configSyncInput


%Open GUIs
% MainWindow
% Looper
% paramSelect



