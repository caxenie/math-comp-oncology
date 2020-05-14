% Compare scalar models for tumor growth
function [t, y] = tumor_growth_model_fit(t1, t2, m, minv)
% This program attempts to find values for r and K in logistic
% model that best fit a given set of data by using fminsearch
close all;
global T M r K model miu min0
% data points from experiment or ...
% Assume the mass of a tumor has a weight of 0.5 grams
% on day 1, 1 gram on day 2, 3 grams on day 3,
% 4 grams on day 4, and 4.5 grams on day 5.
%T=[1,2,3,4,5]';
%M=[0.5,1,3,4,4.5]';
T = t1;
M = t2;
model =  m;
min0 = minv;
x0=[min0; length(T)];
% eventually 'MaxFunEvals',1000, 
[minv, ~]=fminsearch(@er,x0,optimset('TolX',1e-4,'MaxIter',1000, 'MaxFunEvals',5000));
r = minv(1);
K = minv(2);
miu = 2.7;
% choose model
%% @logistic, @vonbertalanffy, @gompertz, @bernoulli, @holling
switch model
    case 'logistic'
        [t,y]=ode23s(@logistic,[1 length(T)], min0);
    case 'vonBertalanffy'
        [t,y]=ode23s(@vonbertalanffy,[1 length(T)], min0);
    case 'Gompertz'
        [t,y]=ode23s(@gompertz,[1 length(T)], min0);
    case 'Bernoulli'
        [t,y]=ode23s(@bernoulli,[1 length(T)], min0);
    case 'Holling'
        [t,y]=ode23s(@holling,[1 length(T)], min0);
end
end

%function for ode solver
function z=er(x)
global T M r K model miu k min0
tt=0:1:length(T);
% data points from experiment
%T=[1,2,3,4,5]';
%M=[0.5,1,3,4,4.5]';
r=x(1);
K=x(2);
miu = 2.7;
k = 0.05;
y0 = min0;
switch model
    case 'logistic'
        [~, y1] = ode23s(@logistic, tt, y0);
        saturation_val = y1(end);
        if length(y1) < length(T)
            y1(length(T)) = 0;
            y1(y1==0) = saturation_val;
        end
    case 'vonBertalanffy'
        [~, y1] = ode23s(@vonbertalanffy, tt, y0);
    case 'Gompertz'
        [~, y1] = ode23s(@gompertz, tt, y0);
    case 'Bernoulli'
        [~, y1] = ode23s(@bernoulli, tt, y0);
    case 'Holling'
        [~, y1] = ode23s(@holling, tt, y0);
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

% Holling type 2 model
function yp = holling(~,y)
global r K k
yp = y;
yp(1) = r*y(1)*((K - (k + y(1)))/(K*(k+y(1))));
end