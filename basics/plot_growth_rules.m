% simple / scalar plot of the growth rules
close all;
N = linspace(0, 1);
alpha = 1;
beta = 1;
k = 0.05;
logistic = alpha*N.*(1 - beta*N.^2);
gompertz = N.*(beta - alpha*log(N));
bertalanffy = alpha * N.^(2/3) - beta * N;
holling = (alpha * N)./(k + N) - beta * N;
figure; set(gcf, 'color', 'w');
plot(logistic,'k--'); hold on;
plot(bertalanffy, 'k-');
plot(gompertz,'k.');
plot(holling, 'k:');box off;
legend('Logistic','Bertalanffy', 'Gompertz', 'Holling'); legend boxoff;
xlabel('N - number of cells'); ylabel('Tumor growth function');
ylim([0,1])