% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 26th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use MDL to estimate number of sources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% R_xx (NxN Complex) = Auto correlation
% F (Integer) = Number of received symbols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% M (Integer) = Number of sources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M] = MDL(R_xx, F)
% Number of receivers
N = size(R_xx, 1);
% MDL cost function
MDL = zeros(1, N);
% eigen values of R_xx
d = sort(abs(eig(R_xx)),'descend');
for k = 0:N-1
    d_l = d(k+1:N);
    frac = (prod(d_l.^(1/(N-k)))/((1/(N-k)) * sum(d_l)));
    % frac^(N-k)*F is a very small number which is indistinguishable from
    % 0, to solve this issue, use vpa()
    MDL(1,k+1) = -1*log(vpa(frac)^((N-k)*F)) + (1/2)*k*(2*N-k)*log(F);
end
% Use minimum of MDL to estimate M
[~,index] = min(MDL);
M = index-1;
end