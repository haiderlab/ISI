function UpdateACQExptName

global GUIhandles ACQserial Mstate

ScanImageBit = get(GUIhandles.main.twophotonflag,'Value');

ISIBit = get(GUIhandles.main.intrinsicflag,'Value');

% set(0,'DefaultTextFontName','helvetica','DefaultTextFontAngle','normal','DefaultTextColor',[0 0 0])
% button = questdlg(sprintf('Are you sure you want to save the data\nand advance to the next experiment?'));
% set(0,'DefaultTextFontName','helvetica','DefaultTextFontAngle','oblique','DefaultTextColor',[1 1 0])

if ScanImageBit
    
    msg = [Mstate.anim '_u' Mstate.unit '_' Mstate.expt];
 
    Stimulus_localCallback(msg);
    
end


if ISIBit
    
    %Send expt info to imager
    
    sendtoImager(['U ' Mstate.unit]);  
    sendtoImager(['E ' Mstate.expt]); 
    sendtoImager(['A ' Mstate.anim]);
    
end


