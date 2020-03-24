% Bayesian Information Criterion, BIC
function bic = model_bic(alfa, sigma, p, M, y)
N = length(M);
sum_sse = model_sse(alfa, sigma, M, y);
bic = N * log(sum_sse / N) + p*log(N);
end