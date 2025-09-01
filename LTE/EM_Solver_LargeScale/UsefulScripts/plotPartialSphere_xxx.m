% function h = plot3DSphere(foo)

clear all;
close all;

[status, matlab_root] = system('echo %MATLAB_ROOT%');
addpath(genpath(strcat(matlab_root, '\Functions\GeneralTools')));

fileName = 'C:\Users\ykonkel.LTE-W18\Teaching\TET1\SS2009\Probeklausur_01\viertelKugel';
figHandle = figure('Position', [200, 100, 800, 800]);
% step
h = 0.05;
% part of sphere
k = 0.25;
% radius
R = 2;

% plot sphere
theta = pi * (0:h:1)';
% phi = (k * pi * (0:(k * h / 2):1)) - pi/3;
phi = (k * 2 * pi * (0:h:1));

X = R * sin(theta) * cos(phi);
Y = R * sin(theta) * sin(phi);
Z = R * cos(theta) * ones(size(phi));

surf(X,Y,Z);
hold on
colormap(gray);

% plot sidewalls
alpha = phi(1);
r = R * (0:(2*h):1)';
phiWall = pi * (0:h:1);
z = r * cos(phiWall);
x = cos(alpha) * r * sin(phiWall);
y = tan(alpha) * x;
surf(x,y,z);

alpha = phi(end);
phiWall = pi * (0:h:1);
z = r * cos(phiWall);
x = cos(alpha) * r * sin(phiWall);
y = tan(alpha) * x;
surf(x,y,z);
colormap(gray);

xlabel('x', 'FontSize', 14);
ylabel('y', 'FontSize', 14);
zlabel('z', 'FontSize', 14);
xlim([-R,R]);
ylim([-R,R]);
zlim([-R,R]);
axis square
view([-67,38]);


savePlot(figHandle, fileName, {'eps'})






