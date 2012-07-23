% InputParam data structures
load('CmlHome.mat');
[dc path_suffix] = strtok(cml_home, '/');
cml_home_remote = ['/rhome' path_suffix];

[sim_param sim_state] = ReadScenario('t_BerSim', 1);


% TaskParam data structures
FunctionPath = [cml_home_remote '/' 'mat'];
FunctionName = 'CmlWorker';


% create TaskParam
clear TaskParam;
TaskParam.FunctionName = FunctionName;
TaskParam.FunctionPath = FunctionPath;
TaskParam.InputParam.cml_home = cml_home_remote;
TaskParam.InputParam.JobParam = sim_param;
TaskParam.InputParam.JobState = sim_state;


% save task to file
save('cml_test_task.mat', 'TaskParam');