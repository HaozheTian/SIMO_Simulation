% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 14th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implement music algorithm for DOA estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% R_xx (NxN Complex) = Auto correlation of received symbols
% array (Nx3 Integers) = Coordinates of N receivers
% M (Integer) = Number of sources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% DOA_est (Mx2) = estimated DOAs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DOA_est] = MUSIC(R_xx, array, M)

    % Eigenvalue decomposition of R_xx
    [V, D] = eig(R_xx); % V are the eigenvectors, D is the eigenvalue matrix
    % Get sorted eigen values and corresponding eigen vectors
    [~, index] = sort(diag(D),'descend');
    V = V(:,index);
    % Eigenvectors that forms noise subspace
    En = V(:,M+1:end);
    % Change azimuth and calculate projection on noise subspace
    cost = zeros(1,181);% MUSIC cost function
    for i = 0:180 % Loop over possible azimuth
        k = pi*[cos(i*pi/180); sin(i*pi/180); 0];
        S = exp(-1i*array*k);
        cost(i+1) = real(S'*(En*En')*S);
    end
    cost = -10*log10(cost);
    % plot MUSIC cost function
    h = figure;
    h.Position = [200 100 300 200];
    plot(0:180,cost); grid; xlabel('Azimuth/deg'); xlim([0 180]); ylabel('\xi(\theta)');
    title('MUSIC cost function');
    % Get DOA estimation
    DOA_est = zeros(M, 2);
    m = 1;
    for i = 2:180
       if cost(i)>cost(i-1) && cost(i)>cost(i+1)
           DOA_est(m,:) = [i-1, 0];
           m = m+1;
       end
    end
    
end

