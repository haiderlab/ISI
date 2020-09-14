function saveOnlineAnalysis

global F1 GUIhandles

if get(GUIhandles.main.analysisFlag,'value')

    f1m = F1;

    A = get(GUIhandles.main.animal,'string');
    U = get(GUIhandles.main.unitcb,'string');
    E = get(GUIhandles.main.exptcb,'string');
    UE = [U '_' E];
    path = 'C:\neurodata\Processed Data\';
    filename = strcat(path,A,'_',UE);
    %save(filename,'F1')
    uisave('f1m',filename)

end