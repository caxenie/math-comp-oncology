% Assume the mass of a tumor has a weight of 0.5 grams
% on day 1, 1 gram on day 2, 3 grams on day 3,
% 4 grams on day 4, and 4.5 grams on day 5.

% Find a set of parameters that
% best  fits  the  data  to  the growth model of interest

function tumor_growth_model_fit()

% This program attempts to find values for r and K in logistic
% model that best fit a given set of data by using fminsearch
clear;
close all;
global T M r K model miu
% choose model
%% 'logistic', 'vonBertalanffy', 'Gompertz', 'Bernoulli'
model =  'Bernoulli'; 
x0=[0.8; 5];
[min, ~]=fminsearch(@er,x0,optimset('TolX',1e-6,'MaxIter',200));
r = min(1); 
K = min(2);
miu = 2.7;
% choose model
%% @logistic, @vonbertalanffy, @gompertz, @bernoulli
[t,y]=ode23s(@bernoulli,[1 5],0.5); 
plot(t,y,T,M,'r*');
set(gcf, 'color', 'w');
title(sprintf('%s growth model', model));
legend('fit model', 'data points (mass/day)');
box off;

end

%function for ode solver
function z=er(x)
global T M r K model miu
tt=0:1:60;
% data points from experiment
T=[1,2,3,4,5]'; 
M=[0.5,1,3,4,4.5]';
r=x(1); 
K=x(2);
miu = 2.7;
y0 = 0.1; 
switch model
    case 'logistic'
        [~, y1] = ode23s(@logistic, tt, y0);
    case 'vonBertalanffy'
        [~, y1] = ode23s(@vonbertalanffy, tt, y0);
    case 'Gompertz'
        [~, y1] = ode23s(@gompertz, tt, y0);
    case 'Bernoulli'
        [~, y1] = ode23s(@bernoulli, tt, y0);
end
z=sum((y1(T)-M).^2); % minimize the squared error criteria
end

% logistic model
function yp = logistic(~,y)
global r K
yp = y; 
yp(1) = r*y(1)*(1 - y(1)/K);
end

% von Bertalanffy model
function yp = vonbertalanffy(~,y)
global r K
yp = y; 
yp(1) = r*y(1)*(1/(y(1)^(1/3)) - 1/K);
end

% Gompertz model
function yp = gompertz(~,y)
global r K
yp = y; 
yp(1) = r*y(1)*(1/K - log(y(1)));
end

% Bernoulli model
function yp = bernoulli(~,y)
global r K miu
yp = y; 
yp(1) = r*y(1)*(1 - (y(1)^(miu - 1))/K);
end