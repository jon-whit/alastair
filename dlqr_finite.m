function [ K ] = dlqr_finite( A, B, Q, R, N )

P = cell(1, N);
K = cell(1, N);
P{N+1} = Q;

% Solve backwards in time from N to 0
n = N+1;
while n > 1
    P{n-1} =  Q + (A.'*P{n}*A) - (A.'*P{n}*B)*(R+B.'*P{n}*B)^-1*(B.'*P{n}*A);
    K{n-1} = -1*(R+B.'*P{n}*B)^-1*(B.'*P{n}*A);
    
    n = n-1;
end
end