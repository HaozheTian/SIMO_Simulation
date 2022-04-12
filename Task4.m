clc; clear; close all;
addpath('Wrappers')
addpath('OwnFunctions')
set(0,'defaultfigurecolor',[1 1 1]);

load('PartATask4.mat');
poly_1 = [1;0;0;1;0;1];
poly_2 = [1;0;1;1;1;1];
MSeq_1 = fMSeqGen(poly_1);
MSeq_2 = fMSeqGen(poly_2);
gold_seq = fGoldSeq(MSeq_1, MSeq_2, phase_shift);

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

N_c = size(gold_seq,1); % size of gold sequence
N_ext = 2*N_c; % Observe two 
symbols_ext = fExtension(Xmatrix.', N_c);
[delay_est, DOA_est] = fSpatioTemporalEstimation(symbols_ext, array, gold_seq);
symbols_desired = fSTARBeamforming(symbols_ext,array,gold_seq,DOA_est,delay_est,Beta_1);
bits = fDSQPSKDemodulator(symbols_desired, phi_mod);

%% Turn Bits into ASCII code
bits = reshape(bits(1:480),8,60); % Truncate and leave only 60 chars
for i = 1:60
    s = char(bin2dec(sprintf('%d',(bits(:,i)'))));
    fprintf(s);
end
fprintf("\n");