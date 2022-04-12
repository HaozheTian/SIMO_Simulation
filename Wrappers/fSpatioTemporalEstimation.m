% Haozhe Tian, GROUP (EE4/MSc), 2021, Imperial College.
% Dec, 23rd, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation using spatio-temporal MUSIC (STAR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbols_ext ((N*N_ext)*L Complex) = extended symbol matrix
% array (N*3 Integers) = Rx array coordinates
% gold_seq (W*1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% DOA_est (n_path*2 Integers) = Estimates of each path's DOA
% delay_est (n_path*1 Integers) = Estimates of each path's delay 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% symbols_ext : extended symbols
function [delay_est, DOA_est] = fSpatioTemporalEstimation(symbols_ext, array, gold_seq)

    % Two important dimension coeffcient in STAR
    N_c = length(gold_seq);
    N_ext = 2*N_c;
    % Other coefficients
    L = size(symbols_ext,2);
    N = size(symbols_ext,1)/N_ext;
    % Aurocorrelation
    R_xx = (symbols_ext*symbols_ext')/L;
    %% Spatial Temporal MUSIC
    % The shifting matrix (N_ext x N_ext)
    J = [zeros(1, N_ext-1), 0; eye(N_ext-1), zeros(N_ext-1, 1)];
    % PN code
    c = [(1-2*gold_seq); zeros(N_c, 1)];
    % Use MDL to esitmate number of sources
    M = MDL(R_xx, L); 
    % Eigenvalue decompostion of R_xx
    [V, D] = eig(R_xx);
    % Get sorted eigen values and corresponding eigen vectors
    [~, index] = sort(diag(D),'descend');
    V = V(:,index);
    % Eigen vectors that forms noise subspace
    E_n = V(:,M+1:end);
    % Projection operator on noise subspace
    P_n = E_n*inv(E_n'*E_n)*E_n';
    % Change azimuth and delay, calculate projection on noise subspace
    cost = zeros(181, N_c);
    for azi = 0:180 % Loop over possible azimuth
        for d = 0:N_c-1 % Loop over possible delay
            theta = azi*pi/180;
            k = pi*[cos(theta),sin(theta),0]';
            S = exp(-1i * array * k);
            h = kron(S, (J^d*c));
            cost(azi+1, d+1) = h'*P_n*h;
        end
    end
    % change to dB
    cost = -10*log10(cost);
    % Plot spatial temporal MUSIC cost function
    [X,Y] = meshgrid(0:N_c-1,0:180);
    h = figure(); h.Position = [500,100,700,300];
    subplot(121); surfl(X,Y,real(cost),'light'); shading interp;
    xlabel('Time Delay'); ylabel('Azimuth Angle'); zlabel('cost'); title('MUSIC cost function'); 
    subplot(122); contour(X,Y,real(cost));
    xlabel('Time Delay'); ylabel('Azimuth Angle/deg'); title('MUSIC cost function (contour)'); 
    %% Get delay and DOA estimations
    delay_est = [];
    DOA_est = [];
    % Step 1: cut-off floor
    cost = real(cost);
    mid = (max(max(cost))+min(min(cost)))/2;
    cost(cost<mid) = min(min(cost));
    % Step 2: search for peaks
    for x = 2:size(cost,1)-1
        for y = 2:size(cost,2)-1
    %         If a point is larger than its surroundings => peak
            peak = cost(x,y)>cost(x-1,y-1) &&...
                   cost(x,y)>cost(x-1,y  ) &&...
                   cost(x,y)>cost(x-1,y+1) &&...
                   cost(x,y)>cost(x  ,y-1) &&...
                   cost(x,y)>cost(x  ,y+1) &&...
                   cost(x,y)>cost(x+1,y-1) &&...
                   cost(x,y)>cost(x+1,y  ) &&...
                   cost(x,y)>cost(x+1,y+1);
            if peak
                % append peak to estimates
                text(y-4,x+30,{['TOA: ',num2str(y-1)]; ['DOA: ',num2str(x-1)]});
                DOA_est = [DOA_est; x-1, 0];
                delay_est = [delay_est; y-1];
            end
        end
    end
    
end

