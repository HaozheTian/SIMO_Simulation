% Haozhe Tian, GROUP (EE4/MSc), 2021, Imperial College.
% Jan, 3rd, 2022

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs superresolution beamforming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (FxN Complex) = F channel symbol chips received by N receivers
% DOA_est (Mx2 Integers) = Estimates of the azimuth and elevation of each
% path of the desired signal
% array (Nx3 Integers) = Coordinates of N receivers
% desired_index (Integer) = Index of desired user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% desired_symbols (Fx1) = symbols from the desired user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [desired_symbols] = fSuperresBeamforming(symbolsIn, DOA_est, array, desired_index)

    symbolsIn = symbolsIn.';
    %% Calculate S for desired DOA and interference DOAs
    azi = DOA_est(:,1)*pi/180;
    ele = DOA_est(:,2)*pi/180;
    k = pi*[cos(azi).*cos(ele), sin(azi).*cos(ele), sin(ele)].';
    S_J = exp(-1i*array*k);
    % Remove desired signal's spv to get noise spvs
    S_desired = S_J(:,desired_index);
    S_J(:,desired_index) = [];
    %% Get weight w
    % Projection on noise subspace
    P = S_J*inv(S_J'*S_J)*S_J';
    P = eye(size(P)) - P;
    % beamforming weight
    w = P*S_desired;
    myPattern(array,w);
    my3DPattern(array, w);
    desired_symbols = (w'*symbolsIn).';
    
end

