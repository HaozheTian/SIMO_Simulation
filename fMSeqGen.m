% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 17th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes polynomial weights and produces an M-Sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% coeffs (Px1 Integers) = Polynomial coefficients. For example, if the
% polynomial is D^5+D^3+D^1+1 then the coeffs vector will be [1;0;1;0;1;1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% MSeq (Wx1 Integers) = W bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MSeq]=fMSeqGen(coeffs)

    % Calculate the degree of polynomial
    poly_deg = length(coeffs) - 1;
    % Number of states
    n_states = 2^poly_deg - 1;
    % Create registers, set the first row to be [1 1 1 1]
    register = ones(1, poly_deg);
    % Initialize output
    MSeq = zeros(n_states, 1);
    %Use the register to generate m sequence
    for i = 1:n_states
        % Calculate the new first element
        register_i_first = mod(register * coeffs(2:end),2);
        % Shift register
        register = circshift(register,1);
        register(1) = register_i_first;
        % Output the ith element of m sequence
        MSeq(i) = register(end);
    end

end