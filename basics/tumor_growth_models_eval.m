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
T = 1:DATASET_LEN_ORIG; T = T';
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
title('Growth models analysis');
legend('Data points', 'Neural Model', 'Gompertz','Logistic','vonBertalanffy','Holling');
legend('boxoff');
box off;

%% Evaluate SSE, RMSE, MAPE
% resample
y1g = interp1(1:length(y1g), y1g, linspace(1,length(y1g),length(M)))';
y1l = interp1(1:length(y1l), y1l, linspace(1,length(y1l),length(M)))';
y1v = interp1(1:length(y1v), y1v, linspace(1,length(y1v),length(M)))';
y1h = interp1(1:length(y1h), y1h, linspace(1,length(y1h),length(M)))';

% params as from [Benzekry et al., 2014c]
alfa = 0.84;
sigma = 0.2;

% locals
models = 1:5;
names = {'GLUECK'; 'Gompertz'; 'Logistic'; 'Bertalanffy'; 'Holling'};

% SSE
SSEn = model_sse(alfa, sigma, M, y1neuro);
SSEg = model_sse(alfa, sigma, M, y1g);
SSEl = model_sse(alfa, sigma, M, y1l);
SSEv = model_sse(alfa, sigma, M, y1v);
SSEh = model_sse(alfa, sigma, M, y1h);
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [SSEn, SSEg, SSEl, SSEv, SSEh],'k*');box off;
ylabel('SSE');
set(gca,'xtick', models, 'xticklabel', names);

% RMSE
RMSEn = model_rmse(alfa, sigma, M, y1neuro);
RMSEg = model_rmse(alfa, sigma, M, y1g);
RMSEl = model_rmse(alfa, sigma, M, y1l);
RMSEv = model_rmse(alfa, sigma, M, y1v);
RMSEh = model_rmse(alfa, sigma, M, y1h);
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [RMSEn, RMSEg, RMSEl, RMSEv, RMSEh],'k*');
ylabel('RMSE');
set(gca,'xtick', models, 'xticklabel', names);box off;

% MAPE
MAPEn = mean(abs((M-y1neuro)./M));
MAPEg = mean(abs((M-y1g)./M));
MAPEl = mean(abs((M-y1l)./M));
MAPEv = mean(abs((M-y1v)./M));
MAPEh = mean(abs((M-y1h)./M));
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [MAPEn, MAPEg, MAPEl, MAPEv, MAPEh],'k*');box off;
ylabel('MAPE');
set(gca,'xtick', models, 'xticklabel', names);

% AIC
AICn = model_aic(alfa, sigma, M, y1neuro);
AICg = model_aic(alfa, sigma, M, y1g);
AICl = model_aic(alfa, sigma, M, y1l);
AICv = model_aic(alfa, sigma, M, y1v);
AICh = model_aic(alfa, sigma, M, y1h);
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [AICn, AICg, AICl, AICv, AICh],'k*');
ylabel('AIC');
set(gca,'xtick', models, 'xticklabel', names);box off;

% R2
R2n = model_r2(M, y1neuro);
R2g = model_r2(M, y1g);
R2l = model_r2(M, y1l);
R2v = model_r2(M, y1v);
R2h = model_r2(M, y1h);
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [R2n, R2g, R2l, R2v, R2h],'k*');
ylabel('R^2');
set(gca,'xtick', models, 'xticklabel', names); box off;



