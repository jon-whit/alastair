
%close all
%clear
clc

% System inputs from GUI
load simParam.mat % variable named parameters

% For infinite time horizon, set time_h = 1, for finite set time_h=0
time_h=parameters{4};
dtype = parameters{3};

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
tf = 60;                   % final time
N = parameters{7};          % number of time steps
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
X_dot_d = @(x_d,u_d) (A*x_d + B*u_d);

% LQR cost matrices
Q = q*eye(length(A));
Q(1,1) = 0;
R = r*eye(size(B,2));

ud = zeros(1,N);

th = zeros(1,length(t));

Xd = x0;
Xdm = x0;
Xdp = x0;
XoutD = zeros(2,length(t));

FPerror = zeros(length(t), 2);

tic
P = Q;
K = zeros(N,2);
i = N+1;
error = zeros(6,1);
while i > 1
   
    FPerror(i - 1, :) = error(5:6)';
    if strcmp(dtype,'double')
        P = Q + (A.'*P*A) - (A.'*P*B)*((R+B.'*P*B)^-1)*(B.'*P*A);
        K(i-1,:) = -1*((R+B.'*P*B)^-1)*(B.'*P*A);
        Kp(i-1,:) = (K(i-1,:) + error(5:6)');
        Km(i-1,:) = (K(i-1,:) - error(5:6)');
    elseif strcmp(dtype,'single')
        P = single(Q + (A.'*P*A) - (A.'*P*B)*((R+B.'*P*B)^-1)*(B.'*P*A));
        K(i-1,:) = single(-1*((R+B.'*P*B)^-1)*(B.'*P*A));
        Kp(i-1,:) = single(K(i-1,:) + error(5:6)');
        Km(i-1,:) = single(K(i-1,:) - error(5:6)');
    end
    
    Pe = [P(1,1)-error(1) P(1,1)+error(1);...
        P(1,2)-error(2) P(1,2)+error(2);...
        P(2,1)-error(3) P(2,1)+error(3);...
        P(2,2)-error(4) P(2,2)+error(4)];

    filename = FPT_finite_gen(b,m,g,q,r,Pe,dtype);
    
    %[bounds, error] = fptaylor_mat('~/GitHub/FPTaylor/benchmarks/tests/config-gelpia.cfg', ['~/GitHub/alastair/', filename]);
    [bounds, error] = fptaylor_mat('~/MotionPlanning/FPTaylor/benchmarks/tests/config-gelpia.cfg', ['~/MotionPlanning/FinalProject/alastair/', filename]); 
    while size(error) ~= 6
        disp('FPTaylor fail. redo...')
        [bounds, error] = fptaylor_mat('~/MotionPlanning/FPTaylor/benchmarks/tests/config-gelpia.cfg', ['~/MotionPlanning/FinalProject/alastair/', filename]); % james File path
        %[bounds, error] = fptaylor_mat('~/GitHub/FPTaylor/benchmarks/tests/config-gelpia.cfg', ['~/GitHub/alastair/', filename]);
    end
    i = i-1
    
end
toc

% Simulate dynamics
for j = 1:length(t)
    XoutD(:,j) = Xd;
    XoutDm(:,j) = Xdm;
    XoutDp(:,j) = Xdp;
    if strcmp(dtype,'double')
        ud(j) = double(K(j,:)*(Xd-x_des))+b*v_des ;
        udp(j) = double(Kp(j,:)*(Xd-x_des))+b*v_des;
        udm(j) = double(Km(j,:)*(Xd-x_des))+b*v_des; 
    elseif strcmp(dtype,'single')
        ud(j) = single(K(j,:)*(Xd-x_des))+b*v_des ;
        udp(j) = single(Kp(j,:)*(Xd-x_des))+b*v_des;
        udm(j) = single(Km(j,:)*(Xd-x_des))+b*v_des;
    end
    Xd = X_dot_d(Xd,ud(j));
    Xdm = X_dot_d(Xdm,udm(j));
    Xdp = X_dot_d(Xdp,udp(j));
end

u = {ud',udp',udm'};
Xout = {XoutD(2,:)' , XoutDp(2,:)', XoutDm(2,:)'};

output = [t' u Xout FPerror th']';

plot(t, XoutD(2,:))


s=strcat(datestr(clock,'HHMMss'),'_',dtype,'_N',num2str(N),'_q',num2str(q),'_r',num2str(r)); 


save('output.mat','output');
save(['output_',s,'.mat'],'output')

