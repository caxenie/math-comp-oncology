% Assume the mass of a tumor has a weight of 0.5 grams
% on day 1, 1 gram on day 2, 3 grams on day 3,
% 4 grams on day 4, and 4.5 grams on day 5.

% Find a set of parameters that
% best  fits  the  data  to  the growth model of interest

function tumor_growth_model_fit()

% This program attempts to find values for r and K in logistic
% model that best fit a given set of data by using fminsearch
clear all;
close all;
global T M r K
x0=[0.8; 5];
[min, fval]=fminsearch(@er,x0,optimset('TolX',1e-6,'MaxIter',200));
min(1)=r; 
min(2)=K;
[t,y]=ode23s(@vonbertalanffy,[1 5],0.5);
plot(t,y,T,M,'r*');

end

%function for ode solver
function z=er(x)
global T M r K
tt=0:1:60;
% data points from experiment
T=[1,2,3,4,5]'; 
M=[0.5,1,3,4,4.5]';
r=x(1); 
K=x(2);
y0 = [0.1]; 
y = y0;
model =  'vonBertalanffy'; % 'logistic', 'vonBertalanffy', 'Gompertz'
switch model
    case 'logistic'
        [t1, y1] = ode23s(@logistic, tt, y0);
    case 'vonBertalanffy'
        [t1, y1] = ode23s(@vonbertalanffy, tt, y0);
    case 'Gompertz'
        [t1, y1] = ode23s(@gompertz, tt, y0);
end
z=sum((y1(T)-M).^2); % minimize the squared error criteria
end

function yp = logistic(t,y)
global r K
yp = y; 
yp(1) = r*y(1)*(1 - y(1)/K);
end

function yp = vonbertalanffy(t,y)
global r K
yp = y; 
yp(1) = r*y(1)*(1/(y(1)^(1/3)) - 1/K);
end

function yp = gompertz(t,y)
global r K
yp = y; 
yp(1) = r*y(1)*(1/K - log(y(1)));
end