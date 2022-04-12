% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 22nd, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation. Estimate both amplitude and phaseshift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Rx1 Complex) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% delay_estimate = Vector of estimates of the delays of each path of the
% desired signal
% DOA_estimate = Estimates of the azimuth and elevation of each path of the
% desired signal
% beta_estimate = Estimates of the fading coefficients of each path of the
% desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delay_estimate, betas]=fChannelEstimationHist(symbolsIn,goldseq,pathNum)

    %% Estimate delay
    % Number of bits in gold sequence
    n_gold = size(goldseq, 1);
    % Number of input symbols
    n_in = size(symbolsIn, 1);
    % Map gold sequence to -1 to 1
    goldseq = 1 - 2*goldseq;
    % For each delay, find correlation
    cor = zeros(n_gold-1, 1);
    % Crop a part of SymbolsIn 
    for delay = 1:n_gold-1
        % Crop a part of SymbolsIn with length that diveides n_gold
        left = delay;
        right = (floor(n_in/n_gold)-1)*n_gold + delay;
        cor(delay) = mean(abs(goldseq'*reshape(symbolsIn(left:right-1), n_gold, [])));
    end
    % Here the first gold sequence is used, therefore the three delays with
    % largest correlation are the delays of the desired paths
    [~,delay_estimate] = maxk(cor, pathNum);
    delay_estimate = sort(delay_estimate - 1);
    %% Estimate beta
    %Record path power
    betas = [];
    k = n_gold*floor(n_in/n_gold);
    % Seperate symbols in each path
    phase_gt = [0,-40,80];
    for path = 1:pathNum
        % Estimated path delay
        d = delay_estimate(path);
        % Seperate multipah
        delay_symbols = symbolsIn(d + 1:d+k, 1);
        path_symbols =  goldseq'*reshape(delay_symbols, n_gold, []);
        % Use a function I wrote to estimate beta for each path
        % Phase is estimated using histogram
        fprintf('\nInput Estimated Phase Shift for this Path\n');
        fprintf(strcat('Ground-truth Phase Shift is', 32, num2str(phase_gt(path)), ' degrees for this Path\n'));
        [beta] = EstimateBeta(path_symbols);
        betas = [betas; beta];
    end
    
end