% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 14th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 3-D array pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% array (Nx3 Integers) = Coordinates of N receivers
% w (Nx1 Complex) = beamforming weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = my3DPattern(array, w)
gain = zeros(181,361);
azi = (0:360)'*(pi/180);
for ele = 0:180
    az = azi;
    el = ele*ones(size(azi))*(pi/180);
    KI = pi*[cos(az).*cos(el)   sin(az).*cos(el)    sin(el)]';
    S = exp(-1i*(array*KI));
    gain(ele+1,:) = abs(w'*S);
end
% gain = gain + abs(min(min(gain)));
x = [];
y = [];
z = [];
for ele = 1:181
    for azi = 1:361
        rou = gain(ele, azi);
        x = [x, rou*sin((ele-1)*pi/180)*cos((azi-1)*pi/180)];
        y = [y, rou*sin((ele-1)*pi/180)*sin((azi-1)*pi/180)];
        z = [z, rou*cos((ele-1)*pi/180)];
    end
end
h = figure;
h.Position = [700 100 300 300];
scatter3(x,y,z,5,sqrt(x.^2+y.^2+z.^2));
title("3-D array pattern");
xlabel("x");ylabel("y");zlabel("z");
caxis([0,max(max(gain))]);
end

