% R2 score, informative of how good is the model fit compared to a 
% completely agnostic one that would result from assuming just 
% the mean of the data
function r2 = model_r2(M, y)
y_avg = mean(y);
r2 = 1 - (sum(y - M))/(sum(y - y_avg));
end
