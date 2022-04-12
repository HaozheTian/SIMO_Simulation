% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 13th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conduct deiversity combining of received symbols. If the desired user 
% has only one path, P-N code was used to seperate the path. If multipath
% exists, RAKE and MRC was used. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (F*1 Integers) = F channel symbol chips received.;
% goldSeq (W*1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired signal to be used in the demodulation process
% delays_est (n_path*1 Integers) = Vector of the estimated delays
% betas (M*1 Complex) = complex gains of wireless channels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (Px1 Integers) = P symbols representing the desired user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [symbolsOut] = fDiversityCombine(symbolsIn, goldSeq, delays_est, betas)

    % Map gold sequence to -1 and 1
    goldSeq = (1 - 2*goldSeq);
    % Length of gold sequence
    W = size(goldSeq,1);
    % Length of input symbols
    F = size(symbolsIn,1);
    % Number of paths
    n_paths = size(delays_est, 1);
    % Truncate input symbols
    k = W*floor(F/W);
    % Initialize Output
    symbolsOut = zeros(k/W, 1);

    %% Diversity Combine
    if n_paths == 1 % Only one desired path, no diversity
        % Seperate the desired path using the RAKE receiver
        delay_symbols = symbolsIn(delays_est + 1:delays_est+k, 1);
        symbolsOut = (goldSeq'*reshape(delay_symbols, W, [])).'; 
    else % Conduct MRC combining
        for path = 1:n_paths
            % Estimated path delay
            path_delay = delays_est(path);
            % Seperate symbols in each path using the RAKE receiver
            delay_symbols = symbolsIn(path_delay + 1:path_delay+k, 1);
            path_symbol =  goldSeq'*reshape(delay_symbols, W, []);
            % MRC
            symbolsOut = symbolsOut + conj(betas(path)).*(path_symbol.');
        end
    end
    
end
