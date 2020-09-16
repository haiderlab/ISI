function [sdom, tdom, x_ecc, y_ecc] = makeGraterDomainsAdapt(xN,yN,pID)

global Mstate DistortBit

DistortBit = 0;

Pstruct = getParamStruct;

%%This was used to get the screen distortion%%%%%%

if DistortBit;
    
    %%%Get the eccentricity domain
    x_ecc = single(tan(Pstruct.x_size/2*pi/180)*Mstate.screenDist);  %cm
    y_ecc = single(tan(Pstruct.y_size/2*pi/180)*Mstate.screenDist);
    
    x_ecc = single(linspace(-x_ecc,x_ecc,xN)); %cm
    y_ecc = single(linspace(-y_ecc,y_ecc,yN));
    
    [x_ecc y_ecc] = meshgrid(x_ecc,y_ecc);
    
    %%%%%%%%%%
else
    
    x_ecc = Pstruct.x_size/2;
    y_ecc = Pstruct.y_size/2;
    
    x_ecc = single(linspace(-x_ecc,x_ecc,xN));  %deg
    y_ecc = single(linspace(-y_ecc,y_ecc,yN));
    
    [x_ecc y_ecc] = meshgrid(x_ecc,y_ecc);  %deg
    
end

%Rotate, distort, convert to cycles.
if pID == 1
    
    if DistortBit
        %%%This was also used for screen distortion
        sdom = x_ecc*cos(Pstruct.ori*pi/180) - y_ecc*sin(Pstruct.ori*pi/180);    %cm
        sdom = atan(sdom/Mstate.screenDist)*180/pi;    %deg
        sdom = sdom*Pstruct.s_freq*2*pi;
        
    else
        
        sdom = x_ecc*cos(Pstruct.ori*pi/180) - y_ecc*sin(Pstruct.ori*pi/180);    %deg
        sdom = sdom*Pstruct.s_freq*2*pi; %radians
        
    end
    
    tdom = single(linspace(0,2*pi,Pstruct.t_period+1));
    tdom = tdom(1:end-1);
    
elseif pID == 2
    
    if DistortBit
        sdom = x_ecc*cos(Pstruct.ori2*pi/180) - y_ecc*sin(Pstruct.ori2*pi/180);
        sdom = atan(sdom/Mstate.screenDist)*180/pi;
        sdom = sdom*Pstruct.s_freq2*2*pi;
        
    else
        sdom = x_ecc*cos(Pstruct.ori2*pi/180) - y_ecc*sin(Pstruct.ori2*pi/180);    %deg
        sdom = sdom*Pstruct.s_freq2*2*pi; %radians
    end
    
    tdom = single(linspace(0,2*pi,Pstruct.t_period+1));
    tdom = tdom(1:end-1);
    
end


    
%     xcycles = Pstruct.s_freq * Pstruct.x_size;
%     thetax = single(linspace(0,2*pi*xcycles,xN+1));
%     thetax = thetax(1:end-1);
%     
%     ycycles = Pstruct.s_freq * Pstruct.y_size;
%     thetay = single(linspace(0,2*pi*ycycles,yN+1));
%     thetay = thetay(1:end-1);
%     
%     [thetax thetay] = meshgrid(thetax,thetay);
%     
%     sdom = thetax*cos(Pstruct.ori*pi/180) - thetay*sin(Pstruct.ori*pi/180);
%     
%     tdom = single(linspace(0,2*pi,Pstruct.t_period+1));
%     tdom = tdom(1:end-1);
    