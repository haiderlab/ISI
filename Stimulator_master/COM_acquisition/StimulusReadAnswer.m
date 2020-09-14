function out=StimulusReadAnswer
	out=[];
	global serialstate
	if length(serialstate.serialPortHandle) == 0
		disp(['StimulusTalk: Stimulus not configured']);
		return;
	end

	time=clock;
	done=0;
	while ~done
		n=get(serialstate.serialPortHandle,'BytesAvailable');
		if  n > 0
			temp=fread(serialstate.serialPortHandle,n); 
			out=[out temp];
			if temp(end)==13;
				done=1;
			end
			time=clock;
		end
		if etime(clock,time)>2
			disp('StimulusReadAnswer: Time out: no data in 2 secs');
			done=1;
		end
	end
		
