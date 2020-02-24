% function to visualize network data at a given iteration in runtime
function id_maxv = visualize_results(sensory_data, populations, learning_params)
%% hidden function, learnt function and overlyed max value ot decode
figure;
set(gcf, 'color', 'white');
% sensory data
subplot(4, 1, [1 2]);
plot(sensory_data.x, sensory_data.y, '-g'); xlabel('X'); ylabel('Y'); box off;
% extract the max weight on each row (if multiple the first one)
id_maxv = zeros(populations(1).lsize, 1);
for idx = 1:populations(1).lsize
    [~, id_maxv(idx)] = max(populations(1).Wcross(idx, :));
end
% update range for visualization
minVal = min(id_maxv);
maxVal = max(id_maxv);
id_maxv = (((id_maxv - minVal) * (1 - (-1))) / (maxVal - minVal)) + (-1);
% adjust interpolation to match data size
upsample_factor = 10;
datax = id_maxv';
idx_data = 1:length(datax);
idx_upsampled_data = 1:1/upsample_factor:length(datax);
datax_extrapolated = interp1(idx_data, datax, idx_upsampled_data, 'linear');
% get the error and plot it as errorbar
deviation = sensory_data.y - datax_extrapolated;
hold on; 
% plot(sensory_data.x, datax_extrapolated,'r.', 'LineWidth', 2);
errorbar(sensory_data.x(1:20:end), datax_extrapolated(1:20:end), deviation(1:20:end));
title('Output Analysis');
legend('Encoded relation','Decoded learnt relation');
% learned realtionship encoded in the Hebbian links
subplot(4, 1, [3 4]);
% for 3rd order or higher order add some overlay
imagesc(rot90(populations(1).Wcross), [0, 1]); box off; colorbar;
xlabel('neuron index'); ylabel('neuron index');
%% learning parameters in different figures
figure; set(gcf, 'color', 'w');
plot(learning_params.alphat, 'k', 'LineWidth', 3); box off; ylabel('SOM Learning rate'); 
xlabel('SOM training epochs'); 
figure; set(gcf, 'color', 'w');
plot(parametrize_learning_law(populations(1).lsize/2, 1, learning_params.t0, learning_params.tf_learn_in, 'invtime'), 'k', 'LineWidth', 3); 
box off; ylabel('SOM neighborhood size'); xlabel('SOM training epochs'); 
% hebbian learning 
figure; set(gcf, 'color', 'w');
etat = parametrize_learning_law(0.1, 0.001, learning_params.t0, learning_params.tf_learn_cross, 'invtime');
plot(etat, 'm', 'LineWidth', 3); box off; ylabel('Hebbian Learning rate'); xlabel('Hebbian learning epochs'); 
% % show the topology learning (self organization)
figure; set(gcf, 'color', 'w');
subplot(2,1,1);
plot(populations(1).Winput, '.g'); xlabel('neuron index in pop 1'); ylabel('preferred value'); box off;
subplot(2,1,2);
plot(populations(2).Winput, '.b'); xlabel('neuron index in pop 2'); ylabel('preferred value'); box off;
end