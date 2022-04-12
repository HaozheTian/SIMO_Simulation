% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 12th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform DS-QPSK Modulation on a vector of bits using a gold sequence
% with channel symbols set by a phase phi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitsIn (Px1 Integers) = P bits of 1's and 0's to be modulated
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence to be used in the modulation process
% phi (Integer) = Angle index in degrees of the QPSK constellation points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (Rx1 Complex) = R channel symbol chips after DS-QPSK Modulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut]=fDSQPSKModulator(bitsIn,goldseq,phi)

    % Initialize symbolsOut
    symbolsOut = zeros((size(bitsIn, 1) / 2), 1);
    % Modulate (map symbols to constellation)
    for i = 1:size(symbolsOut, 1)
        temp = bitsIn(2*i-1:2*i);
        % Four cases for modulation
        if isequal(temp, [0; 0])
            symbolsOut(i) = sqrt(2) * (cos(phi) + 1i * sin(phi));
        elseif isequal(temp, [0; 1])
            symbolsOut(i) = sqrt(2) * (cos(phi + pi / 2) + 1i * sin(phi + pi / 2));
        elseif isequal(temp, [1; 1])
            symbolsOut(i) = sqrt(2) * (cos(phi + pi) + 1i * sin(phi + pi));
        elseif isequal(temp, [1; 0])
            symbolsOut(i) = sqrt(2) * (cos(phi + 3 * pi / 2) + 1i * sin(phi + 3 * pi / 2));
        end
    end
    % Add Gold Sequence
    goldseq = (1 - 2*goldseq); % convert to -1, 1
    symbolsOut = goldseq * symbolsOut.';
    symbolsOut = symbolsOut(:); % Converts to a column
    
end