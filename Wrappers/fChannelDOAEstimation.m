% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 22nd, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate source DOA using the received signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (FxN Complex) = F channel symbol chips received by N receivers
% array (Nx3 Integers) = coordinates of N receivers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% DOA_estimate (Mx2 Integers) = Estimates of the azimuth and elevation of 
% each path of the desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DOA_estimate] = fChannelDOAEstimation(symbolsIn, array)

    % Transpose to calculate R_xx
    symbolsIn = symbolsIn.';
    % Number of symbols
    F = size(symbolsIn,2);
    % Calculate covariance
    R_xx = (symbolsIn*symbolsIn')./F;
    %% Use MDL to esitmate number of sources
    M = MDL(R_xx, F);
    %% Use MUSIC to estimate DOAs
    DOA_estimate = MUSIC(R_xx, array, M);
    
end

