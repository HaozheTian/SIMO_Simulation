% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 13th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate channel delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (F*1 Complex) = F channel symbol chips received
% goldseq (W*1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
% n_path (Integer) = number of paths in the channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% delay_estimate (n_path*1 Integers) = Vector of estimates of the delays of
% each path of the desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delay_estimate]=fChannelDelayEstimation(symbolsIn, goldseq, n_path)

    %% Estimate delay
    % Number of bits in gold sequence
    W = size(goldseq, 1);
    % Number of input symbols
    F = size(symbolsIn, 1);
    % Map gold sequence to -1 to 1
    goldseq = 1 - 2*goldseq;

    %% Find maximum correlation
    cor = zeros(W-1, 1); % W-1 is the possible number of delays
    for delay = 1:W-1
        % Crop a part of SymbolsIn with length that diveides n_gold
        left = delay;
        right = (floor(F/W)-1)*W + delay;
        cor(delay) = mean(abs(goldseq'*reshape(symbolsIn(left:right-1), W, [])));
    end
    % Here the gold sequence of the desired user is used, therefore the m_path 
    % delays with the largest correlation are the delays of the desired paths
    [~,delay_estimate] = maxk(cor, n_path); % select n_path delays
    delay_estimate = sort(delay_estimate - 1);
   
end