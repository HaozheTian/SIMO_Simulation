clc; clear; close all;
addpath('Wrappers')
addpath('OwnFunctions')
set(0,'defaultfigurecolor',[1 1 1]);
% Name configuration
X = 20; % Surname:    Tian
Y = 8;  % Firstname:  Haozhe
% % A name configuration that achieves perfect estimation
% X = 20;
% Y = 6;
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
delays = [mod(X+Y,4); 4+mod(X+Y,5); 9+mod(X+Y,6); 8; 13];
betas = [0.8; 0.4*exp(-1i*40*pi/180); 0.8*exp(1i*80*pi/180); 0.7; 0.2];
DOAs = [30,0; 45,0; 20,0; 90,0; 150,0];
paths = [3,1,1];
array = [0,0,0];
SNR = 0;
% Transmit signal
tx_symbols = [tx1_symbols.';tx2_symbols.';tx3_symbols.']; % concat symbols
rx_symbols = fChannel(paths,tx_symbols,delays,betas,DOAs,SNR,array);

%% Receiver Side
% 1. Estimation
delay_estimate = fChannelDelayEstimation(rx_symbols,tx1_gold,3);
fprintf('Ground Truth Delays:\n %d %d %d\n',delays(1),delays(2),delays(3))
fprintf('Delay Estimates:\n %d %d %d\n',delay_estimate(1),delay_estimate(2),delay_estimate(3))

% 2. RAKE receiver
symbols_tx1 = fDiversityCombine(rx_symbols, tx1_gold, delay_estimate, betas);
% symbols_tx1 = fDiversityCombine(rx_symbols, tx1_gold, delays(1:3), betas);

% 3. Convert symbols to bits
bits = fDSQPSKDemodulator(symbols_tx1, phi);

% 4. Show received image
fImageSink(bits, 8, x1, y1);
[~,BER] = biterr(bits, im1_bits); % Calculate bit error
xlabel({['SNR in the simulation is ',num2str(SNR), ' dB']; ['bit error rate is ',num2str(BER)]});

%% Attempt to use histogram to estimate complex beta (Not very neat)
h=questdlg('Try estimate complex delay?', '', 'yes', 'no', 'yes');
if strcmp(h,'yes')
    close all;clc;
    fprintf('Principle: plot angular histogram of received symbols with respect to angle, \njudge by human the phase shift\n\n')
    % Note both amplitude and phase of betas were estimated
    [delay_estimate,beta_est]=fChannelEstimationHist(rx_symbols,tx1_gold,3);
    symbols_tx1 = fDiversityCombine(rx_symbols, tx1_gold, delay_estimate, beta_est);
    bits = fDSQPSKDemodulator(symbols_tx1, phi);
    fImageSink(bits, 8, x1, y1);
    [~,BER] = biterr(bits, im1_bits); % Calculate bit error
    xlabel({['SNR in the simulation is ',num2str(SNR), ' dB']; ['bit error rate is ',num2str(BER)]});
end
