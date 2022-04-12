% Haozhe Tian, GROUP (EE4/MSc), 2021, Imperial College.
% Dec, 23rd, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation using spatio-temporal MUSIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbols_ext ((N*N_ext)*L Complex) = extended symbol matrix
% array (N*3 Integers) = Rx array coordinates
% gold_seq (W*1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
% DOA_est (n_path*2 Integers) = Estimates of each path's DOA
% delay_est (n_path*1 Integers) = Estimates of each path's delay 
% betas (M*1 Complex) = complex gains of wireless channels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (Px1 Integers) = P symbols representing the desired user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut] = fSTARBeamforming(symbols_ext,array,gold_seq,DOA_est,delay_est,betas)

    N_c = size(gold_seq,1);% length of gold sequence
    N_ext = 2*N_c;% observe two taps
    M = size(DOA_est, 1);% Number of users
    %% STAR-RAKE
    % The shifting matrix (N_ext x N_ext)
    J = [zeros(1, N_ext-1), 0; eye(N_ext-1), zeros(N_ext-1, 1)];
    % PN code
    c = [(1-2*gold_seq); zeros(N_c, 1)];
    H = [];
    for i = 1:M % Loop over all users
        % estimated channel coefficients
        delay = delay_est(i,:);
        DOA = DOA_est(i,:);
        theta = DOA(:,1)*pi/180;
        k = pi*[cos(theta),sin(theta),0]';
        % Array manifold vector
        S = exp(-1i * array * k);
        % Extended array manifold vector
        h = kron(S, (J^delay*c));
        H = [H, h];
    end
    % Beamformer weight
    w = H*betas;
    %% Spatio-temporal Beamforming
    symbolsOut = w'*symbols_ext;
    symbolsOut = symbolsOut.';
    mySTARPattern(array,w,gold_seq); colorbar;
    
end

