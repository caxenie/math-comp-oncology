% Evaluate the tumor growth models against the ML approach
% prepare environment
clear;
clc; close all; 
% data points from experiment along our ML model
dataset = dir('./Experiment_dataset_*');
% or the other(s) ML models
% load('../models/cook-et-al/Experiment_dataset_*.mat');

% make file locally available
% movefile([dataset.folder,'/',dataset.name], './')
load(dataset.name);
T = 1:length(sensory_data.x)';
M = sensory_data.y';

% or ... assume the mass of a tumor has a weight of 0.5 grams
% on day 1, 1 gram on day 2, 3 grams on day 3,
% 4 grams on day 4, and 4.5 grams on day 5.
% T=[1,2,3,4,5]'; 
% M=[0.5,1,3,4,4.5]';

% evaluate classical models 
[t1g, y1g] = tumor_growth_model_fit(T, M,'Gompertz');
[t1l, y1l] = tumor_growth_model_fit(T, M,'logistic');
[t1v, y1v] = tumor_growth_model_fit(T, M,'vonBertalanffy');
[t1h, y1h] = tumor_growth_model_fit(T, M,'Holling');
[t1b, y1b] = tumor_growth_model_fit(T, M,'Bernoulli');
% evaluate the neural model 
t1neuro = sensory_data.x;
y1neuro = neural_model;
% evalute visually 
figure();
set(gcf, 'color', 'w');hold on; box off;
% neural model 
plot(t1neuro, y1neuro);
% classical models
plot(t1g,y1g); 
plot(t1l,y1l);
plot(t1v,y1v);
plot(t1h,y1h);
plot(t1b,y1b, T,M,'r*');
title('Growth models analysis');
legend('Neural Model', 'Gompertz','Logistic','vonBertalanffy','Holling','Bernoulli', 'Data points (mass/day)');
legend('boxoff');
box off;