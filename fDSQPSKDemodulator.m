% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 13th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs QPSK demodulation. Note the input symbols are
% desired user's symbols seperated with RAKE receiver.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Px1 Integers) = P channel symbols seperated with RAKE
% phi (Integer) = Angle index in degrees of the QPSK constellation points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% bitsOut (Px1 Integers) = P demodulated bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bitsOut]=fDSQPSKDemodulator(symbolsIn,phi)

    %% Plot received symbols
    h = figure();
    h.Position = [100 350 300 300];
    plot(real(symbolsIn),imag(symbolsIn),'xblack');
    hold on;
    axis equal;
    % Plot constellation
    xaxis = [min(real(symbolsIn)), max(real(symbolsIn))];
    yaxis = [min(imag(symbolsIn)), max(imag(symbolsIn))];
    plot(xaxis, tan(phi)*xaxis, '-r');
    plot(xaxis, tan(phi+pi/2)*xaxis, '-r');
    xlim(xaxis);
    ylim(yaxis);
    hold off;
    title('Received Symbols');
    xticks([]);
    yticks([]);
    %% Demodulation
    % QPSK constellation
    qpsk = sqrt(2)*[cos(phi)+1i*sin(phi);        cos(phi+pi/2)+1i*sin(phi+pi/2); 
                    cos(phi+pi)+ 1i*sin(phi+pi); cos(phi-pi/2)+1i*sin(phi-pi/2)];
    % bits map
    bits = [0 0 1 1;
            0 1 1 0]; % Each column is a bit: 00 01 11 10
    % Initialize output
    bitsOut = zeros(size(symbolsIn,2)*2, 1);
    for i = 1:size(symbolsIn,1)
        % Map by finding the closet bits in constellation
        distance = abs(qpsk-symbolsIn(i));
        [~, index] = min(distance); 
        bitsOut((2*i-1):2*i,1) = bits(:, index);
    end
    
end