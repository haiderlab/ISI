  % Test for Creating a MatroxCam File using Matrox Toolbox
% View available board 
matroxlist
% Creating a matrox CAM object & DCF file
m = matroxcam(2,"Y:\haider\Docs\Armel Nsiangani\Frame Grabber\Final_DCF.dcf");
% Preview from Camera
pView = preview(m);
% Acquire Single Image 
% singleImage = snapshot(m);
% NOTE:
% If you want to trigger the Camera
% -------------------------------------------------------
% If your DCF file is configured for hardware triggering, 
% then you must provide the trigger to acquire images.
% To do that, call the snapshot function as you normally would acquire snapshot
% and then perform the hardware trigger to acquire the frame.
% Note that when you call the snapshot function with hardware 
% triggering set, it will not timeout as it normally would.
% Therefore, the MATLAB command-line will be blocked until you perform the hardware trigger.