% test whether 2PM idea can be used on FCS data
clear
close all
clc

bin_size = 1;       % bin size: 1
dt = 2e-6;          % sampling rate: 2 us

load('Cy5.mat');
data = f;
% bin the photon count
data = double(data(1:floor(length(data)/bin_size)*bin_size));      
data = sum(reshape(data, bin_size, []), 1)';             

% plot the photon count
figure('color', 'w')
plot((1:length(data)).*dt, data); 
xlabel('t/s'); ylabel('Photon Counts');
axis square

tau_n = 2:1000;
mI = mean(data);            % average intensity

% calculate g2 from data
g2 = zeros(length(tau_n), 1);
for i = 1:length(tau_n)
    i      
    data_tmp = (data).*(data([tau_n(i):end 1:tau_n(i)-1]));
    g2(i) = mean(data_tmp)/mI^2;
end

% calculate K_{2P}^2 from data
tau_n2 = round(10.^(0:0.1:3));
tau_n2 = tau_n2(tau_n2>=2);
Ksq_2P = zeros(length(tau_n2), 1);
for i = 1:length(tau_n2)
    i
    data_tmp = data + data([tau_n2(i):end 1:tau_n2(i)-1]);
    Ksq_2P(i) = var(data_tmp)/mean(data_tmp)^2;
end

% plot photon count, g2 and K_{2P}^2
f = figure('color', 'w');
subplot(1,3,1);
plot((1:length(data)).*dt, data, 'LineWidth', 2); 
xlabel('t/s'); ylabel('# of detected photons');
axis square; ax = gca; ax.FontSize = 15;
subplot(1,3,2);
plot(log10(tau_n.*dt), g2-1, 'LineWidth', 2);
xlabel('lg(\tau)'); ylabel('g_2(\tau)-1');
axis square; ax = gca; ax.FontSize = 15;
subplot(1,3,3);
plot(log10(tau_n2.*dt), Ksq_2P, 'LineWidth', 2); 
xlabel('lg(T)'); ylabel('K_{2P}^2');
axis square; ax = gca; ax.FontSize = 15;

% plot normalized g2 and K_{2P}^2
figure('color', 'w')
subplot(1,2,1);
plot((1:length(data)).*dt, data); 
xlabel('t/s'); ylabel('# of detected photons');
axis square;
subplot(1,2,2);
s = scatter(log10(tau_n.*dt), maxmin_normalize(g2, [mean(g2(end-10:end)) g2(1)]), 70, 'o', 'MarkerFaceColor', [0.83 0.14 0.14]); hold on
alpha(s, 0.2);
plot(log10(tau_n2.*dt), maxmin_normalize(Ksq_2P, [mean(Ksq_2P(end-2:end)) Ksq_2P(1)]), 'Color', [0.83 0.14 0.14], 'LineWidth', 3 ); hold off
xlabel('lg(\tau)'); 
axis square; box on
% xlabel([]); ylabel([]);
ax = gca;
ax.FontSize = 15;
legend('$\widetilde{g_2}(\tau)$', '$\widetilde{K_{2P}^2}(T)$', 'interpreter','latex', 'FontSize', 15);

% save results
save(sprintf('%s_g2_Ksq.mat',filename), 'dt', 'tau_n', 'g2', 'tau_n2', 'Ksq_2P');