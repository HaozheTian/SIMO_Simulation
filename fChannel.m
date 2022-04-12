% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 12th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Models the wireless channels in the system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% paths (Mx1 Integers) = Number of paths for each source in the system.
% For example, if 3 sources with 1, 3 and 2 paths respectively then
% paths=[1;3;2]
% symbolsIn (MxR Complex) = Signals being transmitted in the channel
% delay (Cx1 Integers) = Delay for each path in the system starting with
% source 1
% beta (Cx1 Integers) = Fading Coefficient for each path in the system
% starting with source 1
% DOA = Direction of Arrival for each source in the system in the form
% [Azimuth, Elevation]
% SNR = Signal to Noise Ratio in dB
% array (Nx3 Integers) = Array locations in half unit wavelength. If there 
% is only one receiver, array = [0,0,0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (FxN Complex) = F channel symbol chips received by each
% antenna, note that F = R + max(delay)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut]=fChannel(paths,symbolsIn,delay,beta,DOA,SNR,array)

    M = size(symbolsIn, 1); % Number of paths
    N = size(array, 1); % Number of receivers
    R = size(symbolsIn, 2); % Number of input symbols
    F = R + max(delay); % Number of output symbols
    symbolsOut = zeros(F, N); % Initialilze output
    %% Transmit over each path
    path_i = 1;
    for i = 1:M % Loop over Tx
        for j = 1:paths(i) % Loop over each path of the particular Tx
            % Path delay simulation
            path_delay = delay(path_i); % Get path delay
            source_symbols = zeros(1, F);
            source_symbols(:, path_delay+1:(path_delay+R)) = symbolsIn(i, :);
            % Map doa
            theta = DOA(i, 1)*pi/180;
            phi = DOA(i, 2)*pi/180;
            k = pi*[cos(theta)*cos(phi); sin(theta)*cos(phi); sin(phi)];
            % Calculate array manifold vector
            S = exp(-1i*array*k);
            % Calculate sink symbols
            sink_symbols = S * (beta(path_i) .* source_symbols);
            symbolsOut = symbolsOut + sink_symbols.';
            % Next path_i
            path_i = path_i + 1;
        end
    end
    %% AWGN during transmission
    % Calculate norm of a symbol
    symbol_norm = abs(symbolsIn(1, 1));
    % Calculate signal power of the desired signal
    P_sig = 10*log10(sum(abs((beta(1:paths(1))).*symbol_norm).^2));
    % Calculate noise power
    P_n = 10.^((P_sig-SNR)/10);
    % Generate AWGN
    AWGN = sqrt(P_n/2) * (randn(size(symbolsOut)) + 1i*randn(size(symbolsOut)));
    % Add AWGN to symbolsOut
    symbolsOut = symbolsOut + AWGN;
    
end