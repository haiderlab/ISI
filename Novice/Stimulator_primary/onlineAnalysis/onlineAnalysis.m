
function onlineAnalysis(c,r,syncInfo)

global Tens looperInfo F1 GUIhandles

GUIhandles.main.analysisFlag = 0;
if GUIhandles.main.analysisFlag
    Grabtimes = syncInfo.acqSyncs; 
    %Stimulus starts on 2nd sync, and ends on the second to last.  I also
    %get rid of the last bar rotation (dispSyncs(end-1)) in case it is not an integer multiple
    %of the stimulus trial length
    Disptimes = syncInfo.dispSyncs(2:end-2); 

    %T = getparam('t_period')/60;
    T = mean(diff(Disptimes)); %This one might be more accurate

    fidx = find(Grabtimes>Disptimes(1) & Grabtimes<Disptimes(end));  %frames during stimulus

    framest = Grabtimes(fidx)-Disptimes(1);  % frame sampling times in sec
    frameang = framest/T*2*pi;
    
    k = 1;
    for j=fidx(1):fidx(end)
        
        img = 4096-double(Tens(:,:,j));
        if j==fidx(1)
            acc = zeros(size(img));
        end
        acc = acc + exp(1i*frameang(k)).*img;
        k = k+1;
    end
    F0 = 4096-double(mean(Tens(:,:,fidx(1):fidx(2)),3));
    acc = acc - F0*sum(exp(1i*frameang)); %Subtract f0 leakage
    acc = 2*acc ./ (k-1);
    if r == 1
        F1{c} = acc;
    else
        F1{c} = F1{c} + acc;
    end

    nc = length(looperInfo.conds);
    figure(99)
    subplot(1,nc,c), imagesc(angle(F1{c})), drawnow    
end
Tens = Tens*0;