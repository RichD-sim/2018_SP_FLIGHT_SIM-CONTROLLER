clear all;
close all;

% Initialize
close all; clear all;
addpath(genpath('../Declarations'),...
        genpath('../Functions'),...
        genpath('../Simulator_1D'));

% Rocket Definition
Rocket = rocketReader('Rocket_Definition.txt');
Environnement = environnementReader('Environnement_Definition.txt');

% Define table generation parameters

H_target = 3048; N_H = 100; N_AB = 5; 

% shuriken
AB_span = [-190.5, -18.5];
drag_func = @drag_shuriken;
convert_func = @(x) interp1([-190.5, -18.5], [0, 172] , x, 'linear');

% flaps
% AB_span = [0, 60];
% drag_func = @drag_flaps;
% convert_func = @(x) x;

% generate table

Table_1D_Generator_R2(Rocket, Environnement, H_target, drag_func, convert_func, AB_span, N_H, N_AB);