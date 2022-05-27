function configurePstate_Adapt
%periodic grater

global Pstate

Pstate = struct; %clear it

Pstate.type = 'AD';

Pstate.param{1} = {'predelay'  'float'      2       0                'sec'};
Pstate.param{2} = {'postdelay'  'float'     2       0                'sec'};
Pstate.param{3} = {'stim_time'  'float'     2       0                'sec'};
Pstate.param{4} = {'adapt_cycles'  'int'     24       0                ''};

Pstate.param{5} = {'x_pos'       'int'      600       0                'pixels'};
Pstate.param{6} = {'y_pos'       'int'      400       0                'pixels'};
Pstate.param{7} = {'x_size'      'float'      3       1                'deg'};
Pstate.param{8} = {'y_size'      'float'      3       1                'deg'};
Pstate.param{9} = {'mask_type'   'string'   'disc'       0                ''};
Pstate.param{10} = {'mask_radius' 'float'      6       1                'deg'};
Pstate.param{11} = {'x_zoom'      'int'   1       0                ''};
Pstate.param{12} = {'y_zoom'      'int'   1       0                ''};

Pstate.param{13} = {'contrast'    'float'     100       0                '%'};
Pstate.param{14} = {'ori'         'int'        0       0                'deg'};
Pstate.param{15} = {'phase'         'float'        0       0                'deg'};
Pstate.param{16} = {'st_profile'  'string'   'square'       0                ''};
Pstate.param{17} = {'s_freq'      'float'      4      -1                 'cyc/deg'};
Pstate.param{18} = {'s_duty'      'float'   0.5       0                ''};
Pstate.param{19} = {'t_period'    'int'       20       0                'frames'};

Pstate.param{20} = {'fixOri'    'int'       1       0                ''};
Pstate.param{21} = {'n_ori'    'int'       12       0                ''};
Pstate.param{22} = {'rseed'    'int'   1       0                ''};
Pstate.param{23} = {'n_dir'    'int'   6       0                ''};


Pstate.param{24} = {'contrast2'    'float'     100       0                '%'};
Pstate.param{25} = {'ori2'         'int'        0       0                'deg'};
Pstate.param{26} = {'phase2'         'float'        0       0                'deg'};
Pstate.param{27} = {'st_profile2'  'string'   'square'       0                ''};
Pstate.param{28} = {'s_freq2'      'float'      4      -1                 'cyc/deg'};
Pstate.param{29} = {'s_duty2'      'float'   0.5       0                ''};

Pstate.param{30} = {'background'      'int'   128       0                ''};

Pstate.param{31} = {'redgain' 'float'   1       0             ''};
Pstate.param{32} = {'greengain' 'float'   1       0             ''};
Pstate.param{33} = {'bluegain' 'float'   1       0             ''};
Pstate.param{34} = {'redbase' 'float'   .5       0             ''};
Pstate.param{35} = {'greenbase' 'float'   .5       0             ''};
Pstate.param{36} = {'bluebase' 'float'   .5       0             ''};
Pstate.param{37} = {'colormod'    'int'   1       0                ''};
Pstate.param{38} = {'eye_bit'    'int'   1       0                ''};
Pstate.param{39} = {'Leye_bit'    'int'   1       0                ''};
Pstate.param{40} = {'Reye_bit'    'int'   1       0                ''};

Pstate.param{41} = {'altazimuth'    'string'   'none'       0                ''};
