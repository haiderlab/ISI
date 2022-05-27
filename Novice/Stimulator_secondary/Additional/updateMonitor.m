function updateMonitor


global Mstate screenPTR 


switch Mstate.monitor
    
    case 'LCD'
        
        Mstate.screenXcm = 33.7;  %Smaller LCD
        Mstate.screenYcm = 27;
        
        load('/Matlab_code/calibration_stuff/measurements/LCD (big) 1-8-11/LUT.mat','bufLUT')
        
    case 'CRT'
        
        Mstate.screenXcm = 29;  %old crt
        Mstate.screenYcm = 22; 
        
        load('/Matlab_code/calibration_stuff/measurements/CRT 7-9-11 UDT/LUT.mat','bufLUT')
        
    case 'LIN'   %load a linear table
        Mstate.screenXcm = 56.6*2; %Armel changed from 52.6
        Mstate.screenYcm = 29.9;        
        bufLUT = (0:255)/255;
        bufLUT = bufLUT'*[1 1 1];
        
   case 'TEL'  
        
        Mstate.screenXcm = 121;
        Mstate.screenYcm = 68.3;        
        
        load('/Matlab_code/calibration_stuff/measurements/TELEV 9-29-10/LUT.mat','bufLUT')
        
   case '40in'  
        
        Mstate.screenXcm = 88.8;
        Mstate.screenYcm = 50;        
        %load('/Matlab_code/calibration_stuff/measurements/LCD (big) 1-8-11/LUT.mat','bufLUT')
        load('/Matlab_code/calibration_stuff/measurements/NEWTV 3-15-12/LUT.mat','bufLUT')
        
end


Screen('LoadNormalizedGammaTable', screenPTR, bufLUT);  %gamma LUT

