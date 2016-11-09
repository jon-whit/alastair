clear all
close all
clc



B = 3;
M = 10;
G = 9.81;

b = sym(B);
m = sym(M);
g = sym(G);

% constant definition
C = {'b',b;'m',m;'g',g};

% variable definition
f32 = 'float32';
f64 = 'float64';

V = {f64,'x1',[-1000.0 1000.0];...
     f64,'x2',[-1000.0 1000.0];...
     f64,'u',[-1000.0 1000.0]};
 
FPTaylor_file(C,V,0,0)