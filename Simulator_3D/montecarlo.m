%% montecarlo 3D

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Snippets'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Rocket_Definition_Final.txt');
Environment = environnementReader('Environnement_Definition.txt');
SimOutputs = SimOutputReader('Simulation_outputs.txt');

%% variable parameter definition

% parameter name
param_struct = {'Environment', 'Rocket'};
param_name = {'V_inf', 'motor_fac'};
param_mean = [0 1];
param_std  = [5 0.05];

% param_struct = {'Rocket'};
% param_name = {'rocket_m'};
% param_mean = [17.9];
% param_std  = [2];

%% simulation definition

% number of simulations
n_sim = 10;

% apogee record
apogee_rec = zeros(1, n_sim);

%% process parameters

% parameter stats
n_param = length(param_name);

% check params
if (~(length(param_mean)==n_param || length(param_std)==n_param))
    error('Error: in montecarlo parameter definition, vectors must be of same length');
end

% plot parameter distributions
threshold = 1e-2; 
frame = sqrt(2*param_std.^2*log(threshold^(-1)));
figure; 
param_plt_w = floor(sqrt(n_param));
param_plt_h = n_param/param_plt_w;
for i = 1:n_param
    X = linspace(param_mean(i)-frame(i), param_mean(i)+frame(i),100);
    subplot(param_plt_w, param_plt_h, i);
    plot(X, normpdf(X, param_mean(i), param_std(i)))
    title(param_name{i}, 'Interpreter', 'none');
    ylabel('\phi(x)'); xlabel('x');
end
drawnow;

%% run simulations

fh = figure; hold on;
param_rec = zeros(n_sim, n_param);
for i = 1:n_sim
    
    % set variable field values
    for j = 1:n_param
        param_rec(i,j) = normrnd(param_mean(j), param_std(j));
        if ( strcmp(param_struct{j},'Environment'))  
            Environment = setfield(Environment, param_name{j}, param_rec(i,j));
        elseif (strcmp(param_struct{j},'Rocket'))
            Rocket = setfield(Rocket, param_name{j}, param_rec(i,j));
        else
            error('Error: In montecarlo random parameter calculation, structure name must be either Environment or Rocket.')
        end
    end
    
    SimObj = Simulator3D(Rocket, Environment, SimOutputs);
    
    %% ------------------------------------------------------------------------
    % 6DOF Rail Simulation
    %--------------------------------------------------------------------------

    [T1, S1] = SimObj.RailSim();

    %% ------------------------------------------------------------------------
    % 6DOF Flight Simulation
    %--------------------------------------------------------------------------
    
    [T2, S2] = SimObj.FlightSim(T1(end), S1(end,2));
    
    apogee_rec(i) = S2(end, 3);
    
    plot(T2, S2(:,3));
    
    drawnow;
    
end