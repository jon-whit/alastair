
close all
clear
clc

% system inputs

%for infinite time horizon, set time_h = 0, for finite set time_h=1
time_h=0;

% dynamic parameters
b = 100;
m = 1500;
g = 9.81;

% LQR parameters
q = 50;                     %state cost
r = 20;                     %input cost
v_des = 50;                 %desired velocity
x_des = [0 v_des]';

% simulation parameters
tf = 100;                   %final time
N = 1000;                    %number of time steps
t = linspace(0,tf,N);       %time vector
n = tf/N;                   %step size
x0 = [0 30]';

% Continuos dynamic system
A = [0 1; 0 -b/m];
B = [0 1/m]';
C = [0 1];
D = [0]';
sys = ss(A,B,C,D);

% discrete system dynamics
sysd = c2d(sys,n,'zoh');
Ad = sysd.a;
Bd = sysd.b;

% state space system
X_dot_d = @(x_d,u_d) double(Ad*x_d + Bd*u_d);

% LQR cost matrices
Q = q*eye(length(A));
Q(1,1) = 0;
R = r*eye(size(B,2));



ud = zeros(1,N);

% Floating-point error
FPerror = 0.05*t;

% road profile
th = zeros(1,length(t));

Xd = x0;
XoutD = zeros(2,length(t));

K_d = dlqr_finite(Ad,Bd,Q,R,length(t)); % finite K
K_id = cell(1,N);

for i = 1:length(t)
    XoutD(:,i) = Xd;
    
    % LQR coefficient
    if time_h == 0
        K_id{i} = dlqr_inf(A, B, Q, R);
        ud(i) = double(K_id{i}*(Xd-x_des))+b*v_des;
    elseif time_h == 1
        ud(i) = double(K_d{i}*(Xd-x_des))+b*v_des;
    end
    
    
    Xd = double(X_dot_d(Xd,ud(i)));
   
end

output = [t' ud' XoutD(2,:)' FPerror' th']';

plot(t, XoutD(2,:))

save('output.mat','output')
