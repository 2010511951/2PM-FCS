% calculate g2 and K_{2P}^2 from the raw FCS data 

clear; close all;clc;

% data:[col1 col2], col1: macro time, col2:
% micro time
% time unit in col1: 1 represents 1 in 50 MHz
% time = col1./50MHz;
filename = '10nM_GFP_trial1';
load(sprintf('%s.mat',filename)); 


dt = 1e-3;                                      % bin length = 1ms
data = bin_FCS_asc(data, dt, 5e7);            % bin the asc data with bin=1ms, laser frequency=50 MHz    

tau_n = 2:1000;

mI = mean(data);            % average intensity

% calculate g2
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

% plot data and g2
figure('color', 'w')
subplot(1,3,1);
plot((1:length(data)).*dt, data); 
xlabel('t/s'); ylabel('# of detected photons');
axis square;
subplot(1,3,2);
plot(log10(tau_n.*dt), g2);
xlabel('lg(\tau)'); ylabel('g_2(\tau)-1');
axis square;
subplot(1,3,3);
plot(log10(tau_n2.*dt), Ksq_2P); 
xlabel('lg(T)'); ylabel('K_{2P}^2');
axis square;

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
xlabel('lg(\tau)'); ylabel('g_2(\tau)-1');
axis square; box on
% xlabel([]); ylabel([]);
ax = gca;
ax.FontSize = 15;
legend('$\widetilde{g_2}(\tau)$', '$\widetilde{K_{2P}^2}(T)$', 'interpreter','latex', 'FontSize', 15);

% figure('color', 'w')
% plot((1:length(data)).*dt, data); 
% xlabel('t/s'); ylabel('# of detected photons');
% axis square;
% xlabel([]); ylabel([]);
% ax = gca;
% ax.FontSize = 15;

% save results
save(sprintf('%s_g2_Ksq.mat',filename), 'dt', 'tau_n', 'g2', 'tau_n2', 'Ksq_2P');
    