function [sdom, tdom, x_ecc, y_ecc] = makeGraterDomain(xN,yN,ori,s_freq,t_period,altazimuth)

%Ian Nauhaus

global Mstate

P = getParamStruct;


switch altazimuth

    case 'none'  %For this case we assume that the screen is curved
        
        x_ecc = P.x_size/2;
        y_ecc = P.y_size/2;
        
        x_ecc = single(linspace(-x_ecc,x_ecc,xN));  %deg
        y_ecc = single(linspace(-y_ecc,y_ecc,yN));
        
        [x_ecc y_ecc] = meshgrid(x_ecc,y_ecc);  %deg

        
    case 'altitude'
        
        %%%Get the xy domain
        x_ecc = single(tan(P.x_size/2*pi/180)*Mstate.screenDist);  %cm
        y_ecc = single(tan(P.y_size/2*pi/180)*Mstate.screenDist);
        
        x_ecc = single(linspace(-x_ecc,x_ecc,xN)); %cm
        y_ecc = single(linspace(-y_ecc,y_ecc,yN));
        
        [x_ecc y_ecc] = meshgrid(x_ecc,y_ecc);
        
    case  'azimuth'
        
        %%%Get the xy domain
        x_ecc = single(tan(P.x_size/2*pi/180)*Mstate.screenDist);  %cm
        y_ecc = single(tan(P.y_size/2*pi/180)*Mstate.screenDist);
        
        x_ecc = single(linspace(-x_ecc,x_ecc,xN)); %cm
        y_ecc = single(linspace(-y_ecc,y_ecc,yN));
        
        [x_ecc y_ecc] = meshgrid(x_ecc,y_ecc);
             
end


%Rotate, distort (get degrees as a function of xy location), convert to cycles.
    
switch altazimuth
    
    case 'none'
        
        sdom = x_ecc*cos(ori*pi/180) - y_ecc*sin(ori*pi/180);    %deg
        
    case 'altitude'
        
        sdomx = x_ecc*cos(ori*pi/180 + pi/2) - y_ecc*sin(ori*pi/180 + pi/2);    %cm
        sdomy = x_ecc*sin(ori*pi/180 + pi/2) + y_ecc*cos(ori*pi/180 + pi/2);    %cm
        
        sdom = atan(sdomy.*cos(atan(sdomx/Mstate.screenDist))/Mstate.screenDist)*180/pi; %deg
        
    case 'azimuth' %The projection of azimuth onto a plane is the same as a cylinder on a plane
        
        sdom = x_ecc*cos(ori*pi/180) - y_ecc*sin(ori*pi/180);    %cm
        sdom = atan(sdom/Mstate.screenDist)*180/pi; %deg
        
end

sdom = sdom*s_freq*2*pi; %radians
tdom = single(linspace(0,2*pi,t_period+1));
tdom = tdom(1:end-1);
    

    