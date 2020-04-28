%Two link robot arm control

clc; close all;
clear all;

rederive = false;

%%% System Parameters %%%

%Initial conditions
p.init = [pi/4   0.0   pi/4   0.0]';

p.g = 9.81; %Gravity
p.m1 = 1; %Mass of link 1
p.m2 = 1; %Mass of link 2
p.l1 = 1; %Total length of link 1
p.l2 = 1; %Total lenght of link 2
p.d1 = p.l1/2; %Center of mass distance along link 1 from the fixed point
p.d2 = p.l2/2; %Center of mass distance along link 2 from the fixed point
p.I1 = 1/12*p.m1*p.l1^2; %Moment of inertia of link 1 about COM
p.I2 = 1/12*p.m2*p.l2^2; %Moment of inertia of link 2 about COM

endZ = ForwardKinematics(p.l1,p.l2,p.init(1),p.init(3));
x0 = endZ(1); %End effector initial position in the world frame 
y0 = endZ(2);
p.Fx = 0;
p.Fy = 0;

%%% Control Parameters %%%

%Controller gains
p.Kp = 10;
p.Kd = 8;

%Single target
p.xtarget = x0; %Initial chosen points
p.ytarget = y0;

%%% Derive %%%

%if rederive
%If gain matrix wasn't found yet, assuming derivation hasn't happened
%        deriveRelativeAngles;
%        disp('Equations of motion and control parameters derived using relative angles')
%end

%%% Integrate %%%
plotter(p) %Integration is done using symplectic euler

