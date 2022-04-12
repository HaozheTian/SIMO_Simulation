% Haozhe Tian, GROUP (EE4/MSc), 2021, Imperial College.
% Dec, 23rd, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extends received symbols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (FxN Complex) = F channel symbol chips received by each antenna
% N_c (Integer) = length of gold seq
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbols_ext ((N*N_ext)*L Complex) = extended symbol matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbols_ext] = fExtension(symbolsIn, N_c)

    symbolsIn = symbolsIn.';
    [N,L] = size(symbolsIn);
    % length of tapped delay line
    N_ext = 2 * N_c;
    % number of complete symbols
    n = floor(L/N_c);
    symbols_ext = zeros(N*N_ext, n);
    for i = 1:n
        % define left and right range of a capture
        left = (i-1) * N_c + 1;
        right = (i-1) * N_c + N_ext;
        % capture
        if right > L
            temp = zeros(N, N_ext);
            temp(:,1:L-left+1) = symbolsIn(:,left:L);
        else
            temp = symbolsIn(:,left:right);
        end
        symbols_ext(:,i) = reshape(temp.',[N*N_ext, 1]);
    end
    
end

