%% Test time stamps from filenames
fns = dir('C:\Users\haider-lab\Downloads\frames\*.raw');
frameTimes = zeros(1,600);
dateTimesMs = zeros(1,600); %converted to milliseconds of the current day

for i = 1:length(fns)
    thing = regexp(fns(i).name, '(?<frameNum>\d+)_(?<timeSinceEpochInMs>\d+).raw', 'names');
    if ~isempty(thing)
        ind = str2num(thing.frameNum);
        frameTimes(ind) = str2double(thing.timeSinceEpochInMs);
        d = datetime(frameTimes(ind),'ConvertFrom','epochtime','TicksPerSecond',1000,'TimeZone','UTC');
        d.TimeZone = 'America/New_York'
        dateTimesMs(ind) = (d.Hour*3600 + d.Minute*60 + d.Second) * 1000;
    end
end
plot(frameTimes); title('Time Since Epoch'); xlabel('Sample'); ylabel('Time (ms)');
figure
plot(dateTimesMs); title('Datetime Conversion'); xlabel('Sample'); ylabel('Time (ms)');
figure
x = diff(frameTimes);
plot(x,'.'); title('Time Since Epoch (diff)'); xlabel('Sample'); ylabel('Time diff (ms)');
x2 = diff(dateTimesMs);
figure
plot(x2,'.'); title('Datetime Conversion (diff)'); xlabel('Sample'); ylabel('Time diff (ms)');

%% Test write time stamps
fns = dir('C:\Users\haider-lab\Downloads\frames\*.raw');
timevec_create = [];
timevec_mod = [];
for j = 1:length(fns)
% Get file modification time
    path = [fns(j).folder '\' fns(j).name];
    d = System.IO.File.GetCreationTime(path); % was GetCreationTime
    dMilliseconds = (d.Hour*3600 + d.Minute*60 + d.Second) * 1000 + d.Millisecond;
    timevec_create = [timevec_create double(dMilliseconds)];
    
    d = System.IO.File.GetLastWriteTime(path); % was GetCreationTime
    dMilliseconds = (d.Hour*3600 + d.Minute*60 + d.Second) * 1000 + d.Millisecond;
    timevec_mod = [timevec_mod double(dMilliseconds)];
end
y1 = diff(timevec_create);
figure;
plot(y1,'.')
hold on
y2 = diff(timevec_mod);
%figure;
plot(y2,'.')
title('Creation/Modification Time Stamps (diff) - 20 Hz');
xlabel('Sample'); ylabel('Time difference (ms)');