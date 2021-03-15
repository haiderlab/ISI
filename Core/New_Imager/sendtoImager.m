%% Testing sendtoImager v3 - Replaces built in sendtoImager

function sendtoImager(cmd)
global imagerhandles h FPS GUIhandles analyzer dataTT dataTTReal analogIN cameraInterface

switch(cmd(1))
    case 'A'  %% animal
        set(findobj('Tag','animal'),'String',deblank(cmd(3:end)));
        deblank(cmd(3:end))
        %sprintf('case A activated')
    case 'E' %% expt
        set(findobj('Tag','exptcb'),...
            'String',num2str(deblank(cmd(3:end))));
        %sprintf('case E activated')
    case 'U'  %% unit
        set(findobj('Tag','unitcb'),...
            'String',num2str(deblank(cmd(3:end))));
        %sprintf('case U activated')
        %     case 'T'  %% time tag
        %         set(findobj('Tag','tagtxt'),...
        %             'String',deblank(sprintf('%03d',str2num(cmd(3:end)))));
        
    case 'M'  %% set mode
        m = str2num(cmd(3:end-1));
        %sprintf('case M activated')
    case 'I'  %% total_time
        set(findobj('Tag','timetxt'),'String',deblank(cmd(3:end)));
        preallocateTensor
        %sprintf('case I activated')
        total_time = str2num(cmd(3:end));
        
        
        
    case 'S'  %% start sampling...
        sprintf('case S activated')
        trial = str2num(cmd(3:end));
        
        global nframes maxframes ...
            Tfname running NBUF parport;
        
        
        animal = get(findobj('Tag','animal'),'String');
        %animal = 'xx1';
        unit = get(findobj('Tag','unitcb'),'String');
        %unit = '001';
        expt = get(findobj('Tag','exptcb'),'String');
        %expt = '001';
        datadir = get(findobj('Tag','analyzerRoots'),'String');
        %datadir = 'C:\neurodata';
        %tag = get(findobj('Tag','tagtxt'),'String');
        %tag = 'sometag';
        
        dd = [datadir '\' lower(animal) '\u' unit '_' expt];
        
        global inputM; %DS modified, saving directory.  
        fname = [inputM.analyzerRoot '\' inputM.mouseID '\' inputM.date '\' num2str(inputM.ses)];
        fname = [fname '\' sprintf('%03d',trial)];
        
        nframes = 1;
        
        %recording part
        handles = imagerhandles;
        total_time =  GUIhandles.main.timetxt;
        j = total_time * FPS; %total number of frames to record
        ims = [];
        
        configSyncInput
        lh = analogIN.addlistener('DataAvailable', @plotData);
        analogIN.startBackground();
        
        %% managing camera
        startSave = tic;
        timevecReal = [];
        timeSt = [];
        pause('on');
        c2 = clock;
        timeSt = [timeSt (c2(4)*3600 + c2(5)*60 + c2(6)) *1000];
        if cameraInterface.useExecutable
            imagerhandles.m = 0; %disconnect matroxcam
            handles.m = 0; %fully disconnect matroxcam
            [ims, timevecReal] = grabFrames(j, FPS, cameraInterface.frameDimensions, cameraInterface.exePath, cameraInterface.tempStoragePath, handles.ROI);
        else
            for i = 1:j %Capture images from feed
                % Recording frame time stamps
                c2 = clock;
                timevecReal = [timevecReal (c2(4)*3600 + c2(5)*60 + c2(6)) *1000];
                % Record & save snaps
                frame = snapshot(handles.m);
                I = imcrop(frame,handles.ROI);
                %I = cropDim;
                ims = [ims {I}];
                pause((1/FPS)- 0.035)
            end
        end
        c2 = clock;
        timeSt = [timeSt (c2(4)*3600 + c2(5)*60 + c2(6)) *1000];
        %%
        
        ims;
        %
        cropDim = imcrop(ims{1},handles.ROI);
        timeStim    = dataTT;
        timeStimReal = dataTTReal;

        
        disp('Videos Done')
        global Pstate;
        %save(fname,'ims','timevecReal','timeStim','timeSt','cropDim','timeStimReal','-v7.3')
        save(fname,'ims','timevecReal','timeStim','timeSt','cropDim','timeStimReal','Pstate','-v7.3','-nocompression')
        %quickAnalysis;
        quickAnalysis2(ims,timevecReal,timeStim,timeSt,cropDim,timeStimReal);
        sprintf('Images saved to %s', fname);
        endSave = toc(startSave);
        save([fname '_saveTime'],'endSave');
        fprintf('It took %4.2f seconds to process & save the file \n',endSave)
        clearvars -global dataTT dataTTReal;
        delete(lh);
        clear(func2str(@plotData));
        stop(analogIN);
        %daq.reset;
end



