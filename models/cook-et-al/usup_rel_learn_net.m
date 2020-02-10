%% SIMPLE IMPLEMENTATION OF THE UNSUPERVISED LEARNING OF RELATIONS NETWORK
% the demo dataset contains the y = f(x) relation
%% PREPARE ENVIRONMENT
clear all; clc; close all;
%% INIT SIMULATION
% enables dynamic visualization on network runtime
DYN_VISUAL      = 1;
% verbose in standard output
VERBOSE         = 0;
% number of populations in the network
N_POP           = 2;
% number of neurons in each population
N_NEURONS       = 200;
% max range value @ init for weights and activities in the population
MAX_INIT_RANGE  = 1;
% WTA circuit settling threshold
EPSILON         = 1e-3;
% init data
sensory_data.x = [];
sensory_data.y = [];
%% SELECT DATA SOURCE (arbitrary function or dataset)
DATASET = 1; % if dataset is 1 load dataset, otherwise demo sample function
if DATASET == 0
    %% INIT INPUT DATA - RELATION IS EMBEDDED IN THE INPUT DATA PAIRS
    % demo basic functionality in extracting arbitrary functions
    % set up the interval of interest (i.e. +/- range)ststr
    % set up the interval of interest
    MIN_VAL         = -1.0;
    MAX_VAL         = 1.0;
    % setup the number of random input samples to generate
    NUM_VALS        = 250;
    % generate NUM_VALS random samples in the given interval
    sensory_data.x  = MIN_VAL + rand(NUM_VALS, 1)*(MAX_VAL - MIN_VAL);
    sensory_data.y  = sensory_data.x.^3;
    DATASET_LEN     = length(sensory_data.x);
else
    % select the dataset of interest
    experiment_dataset = 2; % {1, 2, 3, 4, 5, 6}
    % read from sample datasets
    switch experiment_dataset
        case 1
            % Rodallec, Anne, Giacometti, Sarah, Ciccolini, Joseph, & Fanciullino, Rapha�lle. (2019). Tumor growth kinetics of human MDA-MB-231 cells transfected with dTomato lentivirus [Data set]. Zenodo. http://doi.org/10.5281/zenodo.3593919
            filename = '..\..\datasets\1\MDA-MB-231dTomato.csv';
            delimiter = ',';
            startRow = 2;
            formatSpec = '%f%f%f%[^\n\r]';
            % Open the text file.
            fileID = fopen(filename,'r');
            % Read columns of data according to the format.
            dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
            % Close the text file.
            fclose(fileID);
            
            % Create output variable as table
            MDAMB231dTomato = table(dataArray{1:end-1}, 'VariableNames', {'ID','Time','Observation'});
            % or as a simple matrix
            % MDAMB231dTomato = [dataArray{1:end-1}];
            
            % Clear temporary variables
            clearvars filename delimiter startRow formatSpec fileID dataArray ans;
            % check which ID one needs
            ID = 0; % ID is one of {0, 1, 2, 3, 4, 5, 6, 7}
            sensory_data.x =  MDAMB231dTomato.Time(MDAMB231dTomato.ID == ID);
            sensory_data.y =  MDAMB231dTomato.Observation(MDAMB231dTomato.ID == ID);
            
        case 2
            % Gaddy, Thomas D.; Wu, Qianhui; Arnheim, Alyssa D.; D. Finley, Stacey (2017): Mechanistic modeling quantifies the influence of tumor growth kinetics on the response to anti-angiogenic treatment. PLOS Computational Biology. Dataset. https://doi.org/10.1371/journal.pcbi.1005874
            % Import the data
            [~, ~, raw] = xlsread('..\..\datasets\2\S1_Table.xls','S1_Table','A2:L15');
            raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
            % Replace non-numeric cells with NaN
            R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
            raw(R) = {NaN}; % Replace non-numeric cells
            % Create output variable
            data = reshape([raw{:}],size(raw));
            % Create table
            S1Table = table;
            
            % Allocate imported array to column variable names
            S1Table.RolandTimedays = data(:,1);
            S1Table.RolandVolumecm3 = data(:,2);
            S1Table.ZibaraTimedays = data(:,3);
            S1Table.ZibaraVolumecm3 = data(:,4);
            S1Table.Volk2008Timedays = data(:,5);
            S1Table.Volk2008Volumecm3 = data(:,6);
            S1Table.TanTimedays = data(:,7);
            S1Table.TanVolumecm3 = data(:,8);
            S1Table.Volk2011aTimedays = data(:,9);
            S1Table.Volk2011aVolumecm3 = data(:,10);
            S1Table.Volk2011bTimedays = data(:,11);
            S1Table.Volk2011bVolumecm3 = data(:,12);
            
            % Clear temporary variables
            clearvars data raw R;
            
            % TODO Add filtering for sub-dataset
            
        case 3
            % TODO
        case 4
            % TODO
        case 5
            % TODO
        case 6
    end
    % change range
    sensory_data.range  = 1.0;
    % convert x axis data to [-sensory_data.range, +sensory_data.range]
    minVal = min(sensory_data.x);
    maxVal = max(sensory_data.x);
    sensory_data.x = (((sensory_data.x - minVal) * (sensory_data.range - (-sensory_data.range))) / (maxVal - minVal)) + (-sensory_data.range);
    % convert y axis data to [-sensory_data.range, +sensory_data.range]
    minVal = min(sensory_data.y);
    maxVal = max(sensory_data.y);
    sensory_data.y = (((sensory_data.y - minVal) * (sensory_data.range - (-sensory_data.range))) / (maxVal - minVal)) + (-sensory_data.range);
    % load the data and extrapolate for more density in x axis
    upsample_factor = 45;
    datax = sensory_data.x';
    idx_data = 1:length(datax);
    idx_upsampled_data = 1:1/upsample_factor:length(datax);
    datax_extrapolated = interp1(idx_data, datax, idx_upsampled_data, 'linear');
    % load the data and extrapolate for more density in y axis
    datay = sensory_data.y';
    idx_data = 1:length(datay);
    idx_upsampled_data = 1:1/upsample_factor:length(datay);
    datay_extrapolated = interp1(idx_data, datay, idx_upsampled_data, 'linear');
end
% re-assign data
sensory_data.x = datax_extrapolated;
sensory_data.y = datay_extrapolated;
DATASET_LEN     = length(sensory_data.x);
%% INIT NETWORK DYNAMICS
% epoch iterator in outer loop (HL, HAR)
t       = 1;
% network iterator in inner loop (WTA)
tau     = 1;
% constants for WTA circuit (convolution based WTA), these will provide a
% profile peaked at ~ TARGET_VAL_ACT
DELTA   = -0.005;                   % displacement of the convolutional kernel (neighborhood)
SIGMA   = 5.0;                      % standard deviation in the exponential update rule
SL      = 4.5;                      % scaling factor of neighborhood kernel
GAMMA   = SL/(SIGMA*sqrt(2*pi));    % convolution scaling factor
% constants for Hebbian linkage
ALPHA_L = 1.0*1e-2;                 % Hebbian learning rate
ALPHA_D = 1.0*1e-2;                 % Hebbian decay factor ALPHA_D >> ALPHA_L
% constants for HAR
C       = 0.005;                    % scaling factor in homeostatic activity regulation
TARGET_VAL_ACT  = 0.4;              % amplitude target for HAR
A_TARGET        = TARGET_VAL_ACT*ones(N_NEURONS, 1); % HAR target activity vector
% constants for neural units in neural populations
M       = 1; % slope in logistic function @ neuron level
S       = 10.0; % shift in logistic function @ neuron level
% activity change weight (history vs. incoming knowledge)
ETA     = 0.25;
%% CREATE NETWORK AND INITIALIZE
% create a network given the simulation constants
populations = create_init_network(N_POP, N_NEURONS, GAMMA, SIGMA, DELTA, MAX_INIT_RANGE, TARGET_VAL_ACT);
% buffers for changes in activity in WTA loop
act = zeros(N_NEURONS, N_POP)*MAX_INIT_RANGE;
old_act = zeros(N_NEURONS, N_POP)*MAX_INIT_RANGE;
% buffers for running average of population activities in HAR loop
old_avg = zeros(N_POP, N_NEURONS);
cur_avg = zeros(N_POP, N_NEURONS);
% the new rate values
delta_a1 = zeros(N_NEURONS, 1);
delta_a2 = zeros(N_NEURONS, 1);
%% NETWORK SIMULATION LOOP
% % present each entry in the dataset for MAX_EPOCHS epochs to train the net
for didx = 1:DATASET_LEN
    % pick a new sample from the dataset and feed it to the input (noiseless input)
    % population in the network (in this case X -> A -> | <- B <- Y)
    X = population_encoder(sensory_data.x(didx), max(sensory_data.x(:)),  N_NEURONS);
    Y = population_encoder(sensory_data.y(didx), max(sensory_data.y(:)),  N_NEURONS);
    % normalize input such that the activity in all units sums to 1.0
    X = X./sum(X);
    Y = Y./sum(Y);
    % clamp input to neural populations
    populations(1).a = X;
    populations(2).a = Y;
    % given the input sample wait for WTA circuit to settle and then
    % perform a learning step of Hebbian learning and HAR
    while(1)
        % compute changes in activity
        delta_a1 = compute_s(populations(1).h + populations(1).Wext*populations(2).a + populations(1).Wint*populations(1).a, M, S);
        delta_a2 = compute_s(populations(2).h + populations(2).Wext*populations(1).a + populations(2).Wint*populations(2).a, M, S);
        % update the activities of each population
        populations(1).a = (1-ETA)*populations(1).a + ETA*delta_a1;
        populations(2).a = (1-ETA)*populations(2).a + ETA*delta_a2;
        % current activation values holder
        for pop_idx = 1:N_POP
            act(:, pop_idx) = populations(pop_idx).a;
        end
        % check if activity has settled in the WTA loop
        q = (sum(sum(abs(act - old_act)))/(N_POP*N_NEURONS));
        if(q <= EPSILON)
            if VERBOSE==1
                fprintf('WTA converged after %d iterations\n', tau);
            end
            tau = 1;
            break;
        end
        % update history of activities
        old_act = act;
        % increment time step in WTA loop
        tau = tau + 1;
        % visualize runtime data
        if(DYN_VISUAL==1)
            visualize_runtime(sensory_data, populations, tau, t, didx);
        end
    end  % WTA convergence loop
    % update Hebbian linkage between the populations (decaying Hebbian rule)
    populations(1).Wext = (1-ALPHA_D)*populations(1).Wext + ALPHA_L*populations(1).a*populations(2).a';
    populations(2).Wext = (1-ALPHA_D)*populations(2).Wext + ALPHA_L*populations(2).a*populations(1).a';
    % compute the inverse time for exponential averaging of HAR activity
    omegat = 0.002 + 0.998/(t+2);
    % for each population in the network
    for pop_idx = 1:N_POP
        % update Homeostatic Activity Regulation terms
        % compute exponential average of each population at current step
        cur_avg(pop_idx, :) = (1-omegat)*old_avg(pop_idx, :) + omegat*populations(pop_idx).a';
        % update homeostatic activity terms given current and target act.
        populations(pop_idx).h = populations(pop_idx).h + C*(TARGET_VAL_ACT - cur_avg(pop_idx, :)');
    end
    % update averging history
    old_avg = cur_avg;
    % increment timestep for HL and HAR loop
    t = t + 1;
    % print epoch counter
    if VERBOSE==1
        fprintf('HL and HAR dynamics at iteration %d \n', t);
    end
end % end of all samples in the training dataset
% visualize post-simulation data
visualize_runtime(sensory_data, populations, 1, t, DATASET_LEN);