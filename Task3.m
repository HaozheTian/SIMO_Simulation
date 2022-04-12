clc; clear; close all;
addpath('Wrappers')
addpath('OwnFunctions')
set(0,'defaultfigurecolor',[1 1 1]);
% Name configuration
X = 20; % Surname:    Tian
Y = 8;  % Firstname:  Haozhe
my_delay = 1+mod(X + Y,12); % Delay related to my name
phi = (X + 2*Y) * pi /180; %Generate constellation using my name

%% Show images
[im_1, im_2, im_3, P] = loadImages('Images', 'img1.jpg', 'img2.jpg', 'img3.jpg');
[x1, y1, ~] = size(im_1);

%% Image to Symbols
% (For images with P bits, obtain R = length(gold_seq*P/2) Symbols)
% 1. Convert image to bit stream
[im1_bits, ~, ~] = fImageSource('Images/img1.jpg',P);
[im2_bits, ~, ~] = fImageSource('Images/img2.jpg',P);
[im3_bits, ~, ~] = fImageSource('Images/img3.jpg',P);

% 2. Gold sequences
poly_1 = [1;0;0;1;1]; % D^4 + D + 1
poly_2 = [1;1;0;0;1]; % D^4 + D^3 + 1
MSeq_1 = fMSeqGen(poly_1);
MSeq_2 = fMSeqGen(poly_2);
% Find balanced gold sequence that satisfies my delay
while true 
    tx1_gold = fGoldSeq(MSeq_1, MSeq_2, my_delay);
    if sum(1-2*tx1_gold) == -1
        break
    else
        my_delay = my_delay+1;
    end
end
tx2_gold = fGoldSeq(MSeq_1, MSeq_2, my_delay+1);% gold sequence for source two
tx3_gold = fGoldSeq(MSeq_1, MSeq_2, my_delay+2);% gold sequence for source three

% 3. QPSK modulation
tx1_symbols = fDSQPSKModulator(im1_bits, tx1_gold, phi);
tx2_symbols = fDSQPSKModulator(im2_bits, tx2_gold, phi);
tx3_symbols = fDSQPSKModulator(im3_bits, tx3_gold, phi);

%% Channel Simulation
% Channel coefficients
delays = [5; 7; 12];
betas = [0.4; 0.7; 0.2];
DOAs = [30,0; 90,0; 150,0];
paths = [1,1,1];
SNR = 0;
% Generate uniform circular array of 5 isotropic elements
ang_diff = 2*pi/5; % angle between two receivers
radius = 1/2*(1/sin(ang_diff/2)); % Based on half wavelength inter-spacing
array = zeros(5,3);
for i = 1:5
    ang = pi/6 + (i-1)*ang_diff;
    array(i, 1) = radius*cos(ang);
    array(i, 2) = radius*sin(ang);
end
h = figure;
h.Position = [800 100 200 200];
scatter(array(:,1),array(:,2));
grid;
title('Rx Distribution');
% Transmit signal
tx_symbols = [tx1_symbols.';tx2_symbols.';tx3_symbols.']; % concat symbols
rx_symbols = fChannel(paths,tx_symbols,delays,betas,DOAs,SNR,array);

%% Receiver Side
h=questdlg('Receiver Scheme?', '', 'traditional', 'spatio-temporal', 'traditional');

if strcmp(h,'traditional')

    % Using array receivers, we can estimate the DOAs of sources
    [DOA_estimate] = fChannelDOAEstimation(rx_symbols, array);
    % Instead of using gold sequence to seperate desired signal, superresolution
    % beamforming was used to extract desired signal
    desired_symbols = fSuperresBeamforming(rx_symbols, DOA_estimate,array,1);
    % Estimate delays
    delay_est = fChannelDelayEstimation(desired_symbols,tx1_gold,1);
    % (no diversity for single path)
    symbols_tx1 = fDiversityCombine(desired_symbols, tx1_gold, delay_est);

elseif strcmp(h,'spatio-temporal')

    N_c = size(tx1_gold,1); % size of gold sequence
    N_ext = 2*N_c; % Observe two 
    symbols_ext = fExtension(rx_symbols, N_c);
    [delay_est, DOA_est] = fSpatioTemporalEstimation(symbols_ext, array, tx1_gold);
    symbols_tx1 = fSTARBeamforming(symbols_ext,array,tx1_gold,DOA_est,delay_est,betas(1,:));

end

% Convert symbols to bits
bits = fDSQPSKDemodulator(symbols_tx1, phi);

% Show received image
fImageSink(bits, 8, x1, y1);
[~,BER] = biterr(bits, im1_bits); % Calculate bit error
xlabel({['SNR in the simulation is ',num2str(SNR), ' dB']; ['bit error rate is ',num2str(BER)]});