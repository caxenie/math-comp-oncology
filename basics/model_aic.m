% Akaike Information Criterion, AIC
% as from [Burnham and Anderson, 2003]
function aic = model_aic(alfa, sigma, M, y)
N = length(M);
sum_sse = model_sse(alfa, sigma, M, y);
aic = N * log(sum_sse / N);
end