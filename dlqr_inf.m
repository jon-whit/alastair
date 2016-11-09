
% 
% James Tigue, Jonathan Whitaker, Tom Tyler
% Motion Planning
% Final Project
%
% Discrete infinite LQR used to calculate K for use in the symbolic_test.m
% file
% 
% Inputs: A, B, Q, R 
% Outputs: K
%
%

function [K] = dlqr_inf(A, B, Q, R)

%Find P for this time step
[P, L, G] = dare(A, B, Q, R);

%Use P to find K
K = (R+B.'*P*B)^(-1)*(B.'*P*A);

% verify that G and K are the same
sprintf('%d\n%d', G, K)

end


