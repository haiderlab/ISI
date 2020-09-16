function [colordom] = getColorDomain(colorspace)

switch colorspace
    
    case 'gray' 
        
        colordom = 1;
    
    case 'L'
        
        colordom = 2;
                
    case 'M'
        
        colordom = 3;
        
    case 'S'
        
        colordom = 4;
        
    case 'LMS'
        
        colordom = [2 3 4];
        
    case 'DKL'
        
        colordom = [4 5 6];
        
        
end
    
    