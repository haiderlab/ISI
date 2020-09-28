function out=serialTalk(in)
	out=[];
	global serialstate

	if length(serialstate.serialPortHandle) == 0
		disp(['StimulusTalk: Stimulus not configured']);
		return;
	end
 
	if nargin < 2
		verbose=0;
	end 

	n=get(serialstate.serialPortHandle,'BytesAvailable');
	if n > 0
		temp=fread(serialstate.serialPortHandle,n); 
	end

	fwrite(serialstate.serialPortHandle, [in 13]);
	
	temp=StimulusReadAnswer;
	temp=temp';
	if length(temp)==0
		disp('StimulusTalk: Stimulus Timed out without returning anything');
	else
		if length(temp)>1 | temp(1)~=13
			disp(['StimulusTalk: Stimulus did not return 13']);
		end

		disp(['StimulusTalk: Stimulus returned [' num2str(double(temp)) '] = ' char(temp(1:end-1))]);
	end
	out=temp;
		
