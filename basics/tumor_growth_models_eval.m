% Evaluate the tumor growth models against the ML approach
% prepare environment
clear;
clc; close all; 
% data points from experiment along our ML model
% FIXME check folder or parametrize for experiment id
% dataset = dir('../models/axenie-et-al/Experiment_dataset_M*');

% or the other(s) ML models
% load('../models/cook-et-al/Experiment_dataset_*.mat');

% make file locally available
%copyfile([dataset.folder,'/',dataset.name], './')
%load(dataset.name);

load Experiment_dataset_clonal_growth_data.csv_ml_model_runtime.mat
load Experiment_dataset_growth_kinetics_data.csv_ml_model_runtime.mat

global T M
T = 1:DATASET_LEN_ORIG; T = T';
M = sensory_data_orig.y;

% or ... assume the mass of a tumor has a weight of 0.5 grams
% on day 1, 1 gram on day 2, 3 grams on day 3,
% 4 grams on day 4, and 4.5 grams on day 5.
% T=[1,2,3,4,5]';
% M=[0.5,1,3,4,4.5]';

%%  ODE integration is sensitive to initial conditions
% some experiments have a scale 3 order of magnitude larger as others
% adjust the initial condition for these two experiments

% Dataset 1: Rodallec, Anne et al, Tumor growth kinetics of human MDA-MB-231
% Dataset 2: Gaddy et al, Mechanistic modeling quantifies the influence of
% tumor growth kinetics, Volk11b sub-dataset
if experiment_dataset == 1 || (experiment_dataset == 2 && strcmp(study_id, 'Volk11b'))
    minv = 0.2;
else
    minv = 0.02;
end

%% evaluate classical models 
[t1g, y1g] = tumor_growth_model_fit(T, M,'Gompertz', minv);
[t1l, y1l] = tumor_growth_model_fit(T, M,'logistic', minv);
[t1v, y1v] = tumor_growth_model_fit(T, M,'vonBertalanffy', minv);
[t1h, y1h] = tumor_growth_model_fit(T, M,'Holling', minv);
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
legend('Data points', 'GLUECK', 'Gompertz','Logistic','vonBertalanffy','Holling');
legend('boxoff');
box off;
%% boxplot evaluation
figure; set(gcf,'color', 'w'); box off;
% combine the prediction in unified vector
x = [M;y1neuro;y1g;y1l;y1v;y1h];
% create a grouping variable
g1 = repmat({'Data'}, length(M), 1);
g2 = repmat({'GLUECK'}, length(y1neuro), 1);
g3 = repmat({'Gompertz'}, length(y1g), 1);
g4 = repmat({'Logistic'}, length(y1l), 1);
g5 = repmat({'vonBertalanffy'}, length(y1v), 1);
g6 = repmat({'Holling'}, length(y1h), 1);
g=[g1;g2;g3;g4;g5;g6];
boxplot(x, g); box off;
%% load all boxplot data for each dataset for global plot
d1 = load('plasma_pred.mat');
d2 = load('mda_pred.mat');
d3 = load('lm2_pred.mat');
d4 = load('llc_pred.mat');
d5 = load('biomark_pred.mat');
d6 = load('tan_pred.mat');
d7 = load('volk08_pred.mat');
d8 = load('volk11b_pred.mat');
d9 = load('volk11a_pred.mat');
d10 = load('roland_pred.mat');
figure; set(gcf,'color', 'w'); box off;
subplot(2, 5, 1); boxplot(d1.x, d1.g); box off; title('Plasmacytoma');
subplot(2, 5, 2); boxplot(d2.x, d2.g); box off; title('MDA');
subplot(2, 5, 3); boxplot(d3.x, d3.g); box off; title('LM2');
subplot(2, 5, 4); boxplot(d4.x, d4.g); box off; title('LLC');
subplot(2, 5, 5); boxplot(d5.x, d5.g); box off; title('Biomark');
subplot(2, 5, 6); boxplot(d6.x, d6.g); box off; title('Tan');
subplot(2, 5, 7); boxplot(d7.x, d7.g); box off; title('Volk08');
subplot(2, 5, 8); boxplot(d8.x, d8.g); box off; title('Volk11a');
subplot(2, 5, 9); boxplot(d9.x, d9.g); box off; title('Volk11b');
subplot(2, 5, 10); boxplot(d10.x, d10.g); box off; title('Roland');

% ECML GLUECK paper plots
figure; set(gcf,'color', 'w'); box off;
subplot(2, 2, 1); boxplot(d2.x, d2.g); box off; ylabel('Tumor volume (mm^3)'); title('Breast cancer MDA-MB-231 dataset');
subplot(2, 2, 2); boxplot(d9.x, d9.g); box off; ylabel('Tumor volume (mm^3)'); title('Breast cancer MDA-MB-435 dataset');
subplot(2, 2, 3); boxplot(d4.x, d4.g); box off; ylabel('Tumor volume (mm^3)'); title('Lung cancer dataset');
subplot(2, 2, 4); boxplot(d1.x, d1.g); box off; ylabel('Tumor volume (mm^3)'); title('Leukemia dataset');
% CBMS PRINCESS paper plots
figure; set(gcf,'color', 'w'); box off;
subplot(4, 1, 1); boxplot(d2.x, d2.g); box off; ylabel('Tumor volume (mm^3)'); title('Breast cancer MDA-MB-231 dataset');
subplot(4, 1, 2); boxplot(d9.x, d9.g); box off; ylabel('Tumor volume (mm^3)'); title('Breast cancer MDA-MB-435 dataset');
subplot(4, 1, 3); boxplot(d6.x, d6.g); box off; ylabel('Tumor volume (mm^3)'); title('Breast cancer MCF‐7, T47D cell lines dataset');
subplot(4, 1, 4); boxplot(d3.x, d3.g); box off; ylabel('Tumor volume (mm^3)'); title('Breast cancer LM-4LUC+ dataset');
%% Evaluate SSE, RMSE, MAPE

% resample
y1g = interp1(1:length(y1g), y1g, linspace(1,length(y1g),length(M)))';
y1l = interp1(1:length(y1l), y1l, linspace(1,length(y1l),length(M)))';
y1v = interp1(1:length(y1v), y1v, linspace(1,length(y1v),length(M)))';
y1h = interp1(1:length(y1h), y1h, linspace(1,length(y1h),length(M)))';

% params as from [Benzekry et al., 2014c]
alfa = 0.84;
sigma = 0.21;

% locals, model sequence, names and param numbers from [Benzekry et al., 2014c]
models = 1:5;
names = {'GLUECK'; 'Gompertz'; 'Logistic'; 'Bertalanffy'; 'Holling'};
param_num = [0, 2, 2, 3, 3]; % param number for each model 

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
RMSEn = model_rmse(alfa, sigma, param_num(1), M, y1neuro);
RMSEg = model_rmse(alfa, sigma, param_num(2), M, y1g);
RMSEl = model_rmse(alfa, sigma, param_num(3), M, y1l);
RMSEv = model_rmse(alfa, sigma, param_num(4), M, y1v);
RMSEh = model_rmse(alfa, sigma, param_num(5), M, y1h);
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [RMSEn, RMSEg, RMSEl, RMSEv, RMSEh],'k*');
ylabel('RMSE');
set(gca,'xtick', models, 'xticklabel', names);box off;

% sMAPE
sMAPEn = mean(2*abs((M-y1neuro))./(abs(M) + abs(y1neuro)));
sMAPEg = mean(2*abs((M-y1g))./(abs(M) + abs(y1g)));
sMAPEl = mean(2*abs((M-y1g))./(abs(M) + abs(y1g)));
sMAPEv = mean(2*abs((M-y1g))./(abs(M) + abs(y1g)));
sMAPEh = mean(2*abs((M-y1h))./(abs(M) + abs(y1h)));
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [sMAPEn, sMAPEg, sMAPEl, sMAPEv, sMAPEh],'k*');box off;
ylabel('sMAPE');
set(gca,'xtick', models, 'xticklabel', names);

% AIC
AICn = model_aic(alfa, sigma, param_num(1), M, y1neuro);
AICg = model_aic(alfa, sigma, param_num(2), M, y1g);
AICl = model_aic(alfa, sigma, param_num(3), M, y1l);
AICv = model_aic(alfa, sigma, param_num(4), M, y1v);
AICh = model_aic(alfa, sigma, param_num(5), M, y1h);
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [AICn, AICg, AICl, AICv, AICh],'k*');
ylabel('AIC');
set(gca,'xtick', models, 'xticklabel', names);box off;

% BIC
BICn = model_bic(alfa, sigma, param_num(1), M, y1neuro);
BICg = model_bic(alfa, sigma, param_num(2), M, y1g);
BICl = model_bic(alfa, sigma, param_num(3), M, y1l);
BICv = model_bic(alfa, sigma, param_num(4), M, y1v);
BICh = model_bic(alfa, sigma, param_num(5), M, y1h);
%plot comparatively
figure(); set(gcf, 'color', 'w'); 
plot(models, [BICn, BICg, BICl, BICv, BICh],'k*');
ylabel('BIC');
set(gca,'xtick', models, 'xticklabel', names);box off;

% overview
disp 'SSE'; [SSEn, SSEg, SSEl, SSEv, SSEh]
disp 'RMSE'; [RMSEn, RMSEg, RMSEl, RMSEv, RMSEh]
disp 'sMAPE'; [sMAPEn, sMAPEg, sMAPEl, sMAPEv, sMAPEh]
disp 'AIC'; [AICn, AICg, AICl, AICv, AICh]
disp 'BIC'; [BICn, BICg, BICl, BICv, BICh]