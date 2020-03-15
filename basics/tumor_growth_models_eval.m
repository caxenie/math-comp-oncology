% Evaluate the tumor growth models against the ML approach
% prepare environment
clear;
clc; close all; 
% data points from experiment along our ML model
dataset = dir('../models/axenie-et-al/Experiment_dataset_*');

% or the other(s) ML models
% load('../models/cook-et-al/Experiment_dataset_*.mat');

% make file locally available
copyfile([dataset.folder,'/',dataset.name], './')
load(dataset.name);
global T M
T = 1:length(sensory_data_orig.x); T = T';
M = sensory_data_orig.y;

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
t1neuro = T;
y1neuro = neural_model(T)';
% evalute visually 
figure();
set(gcf, 'color', 'w');hold on; box off;
% dataset points
plot(T,M,'r*'); 
% neural model 
plot(t1neuro, y1neuro);
% classical models
plot(t1g,y1g); 
plot(t1l,y1l);
plot(t1v,y1v);
plot(t1h,y1h);
plot(t1b,y1b);
title('Growth models analysis');
legend('Data points', 'Neural Model', 'Gompertz','Logistic','vonBertalanffy','Holling','Bernoulli');
legend('boxoff');
box off;
% evaluate SSE, RMSE, MAPE
% SSE
SSEn = norm(M-y1neuro,2)^2;
SSEg = norm(M-y1g(T),2)^2;
SSEl = norm(M-y1l(T),2)^2;
SSEv = norm(M-y1v(T),2)^2;
SSEh = norm(M-y1h(T),2)^2;
SSEb = norm(M-y1b(T),2)^2;
% RMSE
RMSEn = sqrt(mean((M-y1neuro).^2));
RMSEg = sqrt(mean((M-y1g(T)).^2));
RMSEl = sqrt(mean((M-y1l(T)).^2));
RMSEv = sqrt(mean((M-y1v(T)).^2));
RMSEh = sqrt(mean((M-y1h(T)).^2));
RMSEb = sqrt(mean((M-y1b(T)).^2)); 
% MAPE
MAPEn = mean(abs((M-y1neuro)./M));
MAPEg = mean(abs((M-y1g(T))./M));
MAPEl = mean(abs((M-y1l(T))./M));
MAPEv = mean(abs((M-y1v(T))./M));
MAPEh = mean(abs((M-y1h(T))./M));
MAPEb = mean(abs((M-y1b(T))./M));
