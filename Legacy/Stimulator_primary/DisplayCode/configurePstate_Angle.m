function configurePstate_Angle
%periodic grater

global Pstate

Pstate = struct; %clear it

Pstate.type = 'AG';

Pstate.param{1} = {'predelay'  'float'      2       0                'sec'};
Pstate.param{2} = {'postdelay'  'float'     2       0                'sec'};
Pstate.param{3} = {'stim_time'  'float'     1       0                'sec'};

Pstate.param{4} = {'x_pos'       'int'      600       0                'pixels'};
Pstate.param{5} = {'y_pos'       'int'      400       0                'pixels'};
Pstate.param{6} = {'radius'      'float'      3       1                'deg'};


Pstate.param{7} = {'stim_angle'      'int'     0       1                'deg'};
Pstate.param{8} = {'stim_acute'      'int'     45       1                'deg'};
Pstate.param{9} = {'stim_smooth'      'int'     0       1                ''};

Pstate.param{10} = {'background'      'int'   128       0                ''};
Pstate.param{11} = {'redgain' 'float'   1       0             ''};
Pstate.param{12} = {'greengain' 'float'   1       0             ''};
Pstate.param{13} = {'bluegain' 'float'   1       0             ''};
Pstate.param{14} = {'redbase' 'float'   .5       0             ''};
Pstate.param{15} = {'greenbase' 'float'   .5       0             ''};
Pstate.param{16} = {'bluebase' 'float'   .5       0             ''};



