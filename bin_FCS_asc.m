function data_binned = bin_FCS_asc(data, T, fs)
    
    % bin the raw FCS data
    % data: [col-1 col-2], col-1: the macrotime, col-2: the microtime
    % T: the length of temporal binning window, unit: s
    % fs: the laser pulse frequency, unit: Hz
    
    if nargin < 3
        fs = 5e7;   % default laser pulse frequence: 50 MHz
    end
    
    
    data1 = data(:, 1);
    data1 = ceil(data1./fs./T);     % discretize the macrotime
    
    N = max(data1);      % recording length
    data_binned = zeros(N, 1);
    
    cnt = 1;
    acc = 0;        % # of detected photons within the bin
    for i = 1:length(data1)
        if data1(i)==cnt
            acc = acc +1;
        else
            data_binned(cnt) = acc;
            cnt = data1(i);      % move to the next bin
            acc = 1;             % reset the accumulated photon number to 1
        end
    end
    
%     figure('color', 'w')
%     plot((1:N).*T, data_binned); 
%     xlabel('t/s'); ylabel('# of detected photons');
%     axis square;



end