function [ P,m,error ] = dare_iter( A,B,Q,R )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N = 10;
P = Q;
epsilon = 0.0001;
m = 0;

while (m<N )
    P1 = Q + A'*P*A-A'*P*B*inv(R+B'*P*B)*B'*P*A;
    m = m+1;
    error = norm(diag(P)-diag(P1));
    if error <= epsilon
        break
    end
    P = P1;
end

end

