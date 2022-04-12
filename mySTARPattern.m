% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 21st, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot spatio-temporal array pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% array (Nx3 Integers) = Coordinates of N receivers
% w ((N*N_ext)*1 Complex) = beamforming weights
% gold_seq (N_c*1 Integers) = gold sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = mySTARPattern(array,w,gold_seq)
    N_c = size(gold_seq,1);
    N_ext = 2*N_c;
    % The shifting matrix (N_ext x N_ext)
    J = [zeros(1, N_ext-1), 0; eye(N_ext-1), zeros(N_ext-1, 1)];
    % PN code
    c = [(1-2*gold_seq); zeros(N_c, 1)];
    % Get spatio-temporal array pattern
    gain = zeros(181,N_c);
    for azi = 1:181
        for delay = 1:N_c
            az = azi*pi/180;
            k = pi*[cos(az);sin(az);0];
            S = exp(-1i * array * k);
            h = kron(S,(J^(delay-1) * c));
            gain(azi,delay) = w'*h;
        end
    end
    % Plot spatial temporal gain pattern
    [X,Y] = meshgrid(0:N_c-1,0:180);
    h = figure(); h.Position = [100,100,500,300];
    surfl(X,Y,abs(gain),'light'); shading interp;
    xlabel('Time Delay'); ylabel('Azimuth Angle'); zlabel('gain'); title('Spatial-Temporal Gain Pattern'); 
end

