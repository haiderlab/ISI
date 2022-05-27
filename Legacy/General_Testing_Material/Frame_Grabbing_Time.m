% Getting frame grabbing trigger time

c = clock;
[c tf] = clock;
Time_sec = c(4)*3600 + c(5)*60 + c(6);
Time_sec_2 = [];

for i = 1:1:60 
    c2 = clock;
    Time_sec_2(i) = (c2(4)*3600 + c2(5)*60 + c2(6)) - Time_sec;
    disp(Time_sec_2(i))
    pause(1.00);
end


