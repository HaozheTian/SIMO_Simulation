% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 21st, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate the phase of beta applied to a specific channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% path_symbols = symbols in a path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% beta_estimate = estimated beta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [beta_estimate] = EstimateBeta(path_symbols)
% Given information about modulation constellation
X = 20;
Y = 8;
phi = (X + 2*Y) * pi /180;
%% Estimate amplitude
amp = sum(abs(path_symbols))/(length(path_symbols)*15*sqrt(2));
%% Estimate phase using histogram    
ang = angle(path_symbols)+pi;
coarse = 0.002;
hist_ang = [];
lb = min(ang);
hb = min(ang) + coarse;
while hb<max(ang)
    hist_ang = [hist_ang, length(ang(ang>lb&ang<hb))];
    lb = hb;
    hb = hb + coarse;
end
hist_ang = hist_ang/sum(hist_ang);
ang_map = [min(ang):coarse:min(ang) + (length(hist_ang)-1)*coarse];
h = figure;
h.Position = [100 100 300 300];
polarplot(ang_map, hist_ang);
hold on;
polarplot([0,phi], [0,max(hist_ang)], '-','Color','black');
polarplot([0,phi+pi/2], [0,max(hist_ang)], '-','Color','black');
polarplot([0,phi+pi], [0,max(hist_ang)], '-','Color','black');
polarplot([0,phi+3*pi/2], [0,max(hist_ang)], '-','Color','black');
legend('Histogram of symbols','QPSK constellation','Location','north')
hold off;
rlim([0 max(hist_ang)]);
rticks([])
phase = input('=>');
close(h);
beta_estimate = amp*exp(1i*phase*pi/180);
end

