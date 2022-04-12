% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 14th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot array pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% array (Nx3 Integers) = Coordinates of N receivers
% w (Nx1 Complex) = beamforming weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=myPattern(array,w)
gain = [];
theta = 0:0.5:180;
for i=theta
    i = i*pi/180;
    k = pi*[cos(i);sin(i);0];
    S=exp(-1i*array*k);
    gain=[gain, abs(w'*S)];
end
gain=10*log10(gain);
h = figure();
h.Position = [400 100 300 200];
plot(theta, gain);
grid;
title('MUSIC Superresolution beam former')
xlim([0 180]);
ylim([min(gain)-10, max(gain)+10]);
xlabel('azimuth/deg');
ylabel('gain/dB');
end

