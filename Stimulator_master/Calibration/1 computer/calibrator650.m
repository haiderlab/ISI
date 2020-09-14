
PR650 = serial('COM1','BaudRate',9600,'InputBufferSize',4096);
fopen(PR650)
fprintf(PR650,'S1,,,,,0,1,1')
pause(1)


n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
end  %
sprintf('%c',bout)

%%
screenNum=0;
bufLUT = (0:255)/255;
bufLUT = bufLUT'*[1 1 1];
Screen('LoadNormalizedGammaTable', screenNum, bufLUT)
ptr = Screen('OpenWindow',screenNum,0);
dom = [0:5:255];

fid = fopen('luminance_LCD','w');
for i=1:3
    for k=1:length(dom)
        j = dom(k);
        RGB = [0 0 0];
        RGB(i) = j;
        Screen('FillRect',ptr,RGB);  %Call Psychtoolbox
        Screen('Flip',ptr);
        pause(2);

        sprintf('Measuring Gun #%d = %d\n',i,j)

        fwrite(PR650,['M1' 13]);  %Make measurement
        
        n = 0;
        while n == 0
            n = get(PR650,'BytesAvailable');
        end
        pause(4) %let it get the rest of the string
                
        n = get(PR650,'BytesAvailable');
        bout = fread(PR650,n);
        sprintf('%c',bout)

        n = get(PR650,'BytesAvailable');
        if n > 0
            bout = fread(PR650,n); 
        end

        fprintf(fid,'%c',bout);

    end
end
fclose(fid)
Screen('CloseAll')

%%

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

bufLUT = (0:255)/255;
bufLUT = bufLUT'*[1 1 1];
Screen('LoadNormalizedGammaTable', screenNum, bufLUT)

fprintf(PR650,'S1,,,,,0,1,1')
n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
end %clear buffer
pause(1)

%%
screenNum = 0
ptr = Screen('OpenWindow',screenNum,0);

fid = fopen('spectrum_red_LCD','w');   %now measure spectrum
Screen('FillRect',ptr,[255 0 0]);  %Call Psychtoolbox
Screen('Flip',ptr);
pause(.5)
fwrite(PR650, ['M5' 13]); 
pause(2)

n = 0;
while n == 0
    n = get(PR650,'BytesAvailable');
end
pause(10) %let it get the rest of the string

n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
end
fprintf(fid,'%c',bout);
fclose(fid);
Screen('CloseAll')

%%

ptr = Screen('OpenWindow',screenNum,0);

fid = fopen('spectrum_green_LCD','w');   %now measure spectrum
Screen('FillRect',ptr,[0 255 0]);  %Call Psychtoolbox
Screen('Flip',ptr);
pause(.5)
fwrite(PR650, ['M5' 13]); 
pause(2)

n = 0;
while n == 0
    n = get(PR650,'BytesAvailable');
end
pause(10) %let it get the rest of the string

n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
end
fprintf(fid,'%c',bout);
fclose(fid);
Screen('CloseAll');

%%

ptr = Screen('OpenWindow',screenNum,0);

fid = fopen('spectrum_blue_LCD','w');   %now measure spectrum
Screen('FillRect',ptr,[0 0 255]);  %Call Psychtoolbox
Screen('Flip',ptr);
pause(.5)
fwrite(PR650, ['M5' 13]); 
pause(2)

n = 0;
while n == 0
    n = get(PR650,'BytesAvailable');
end
pause(10) %let it get the rest of the string

n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
end
fprintf(fid,'%c',bout);
fclose(fid);
Screen('CloseAll');

%%