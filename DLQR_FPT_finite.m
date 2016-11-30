
% close all
% clear
% clc

% System inputs from GUI
load simParam.mat % variable named parameters

% For infinite time horizon, set time_h = 1, for finite set time_h=0
time_h=parameters{4};

% Dynamic parameters
b = 80;
m = 1500;
g = 9.81;

% LQR parameters
q = parameters{1};                     % state cost
r = parameters{2};                     % input cost
v_des = parameters{6};                 % desired velocity
x_des = [0 v_des]';

% simulation parameters
tf = 100;                   % final time
N = 3;                     % number of time steps
t = linspace(0,tf,N);       % time vector
n = tf/N;                   % step size
x0 = [0 parameters{5}]';

% Continuos dynamic system
A = [0 1; 0 -b/m];
B = [0 1/m]';
C = [0 1];
D = [0]';
sys = ss(A,B,C,D);

% Discrete system dynamics
sysd = c2d(sys,n,'zoh');
A = sysd.a;
B = sysd.b;

% State space system
X_dot_d = @(x_d,u_d) double(A*x_d + B*u_d);

% LQR cost matrices
Q = q*eye(length(A));
Q(1,1) = 0;
R = r*eye(size(B,2));

ud = zeros(1,N);

th = zeros(1,length(t));

Xd = x0;
XoutD = zeros(2,length(t));

FPerror = zeros(length(t), 2);

tic
P = Q;
K = zeros(N,2);
i = N+1;
error = zeros(6,1);
while i > 1
   
    FPerror(i - 1, :) = error(5:6)';
    
    P =  Q + (A.'*P*A) - (A.'*P*B)*((R+B.'*P*B)^-1)*(B.'*P*A);
    K(i-1,:) = -1*((R+B.'*P*B)^-1)*(B.'*P*A);
    Pe = [P(1,1)-error(1) P(1,1)+error(1);...
        P(1,2)-error(2) P(1,2)+error(2);...
        P(2,1)-error(3) P(2,1)+error(3);...
        P(2,2)-error(4) P(2,2)+error(4)];

    filename = FPT_finite_gen(b,m,g,q,r,Pe);
    
    [bounds, error] = fptaylor_mat('~/GitHub/FPTaylor/benchmarks/tests/config-gelpia.cfg', ['~/GitHub/alastair/', filename]);
 
    i = i-1;
end
toc

% Simulate dynamics
for j = 1:length(t)
    XoutD(:,j) = Xd;
    ud(j) = double(K(j,:)*(Xd-x_des))+b*v_des ;
    Xd = X_dot_d(Xd,ud(j));
end

output = [t' (ud)' XoutD(2,:)' FPerror th']';

plot(t, XoutD(2,:))

save('output.mat','output');

