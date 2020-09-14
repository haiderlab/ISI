function saveSyncs

global analogIN Mstate

samples =  get(analogIN,'samplesAcquired');

syncs = getdata(analogIN,samples);

synctimes = processSyncs(syncs);

title = ['syncs ' Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
location = ['C:\neurodata\syncs\' title] ;

save(location,'synctimes')  %Save only the time points (sec)

flushdata(analogIN)