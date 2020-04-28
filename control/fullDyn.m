function [zdot, T1, T2] = fullDyn(t,z,p)
%Full dynamics for double arm

th1 = z(1);
th2 = z(3);
thdot1 = z(2);
thdot2 = z(4);

%Current disturbance force on end effector
FxCurrent = p.Fx;
FyCurrent = p.Fy;

%Current Target
xCurrentTar = p.xtarget;
yCurrentTar = p.ytarget;

xdotCurrentTar = 0;
ydotCurrentTar = 0;

%Torque to track our desired point
T = impedenceControl(p.Kd,p.Kp,p.l1,p.l2,th1,th2,thdot1,thdot2,xdotCurrentTar,xCurrentTar,ydotCurrentTar,yCurrentTar);

%Add gravity compensation
T1 = T(1) + gravityCompT1(0,0,p.d1,p.d2,p.g,p.l1,p.l2,p.m1,p.m2,th1,th2,thdot1,thdot2);
T2 = T(2) + gravityCompT2(0,0,p.d2,p.g,p.l1,p.l2,p.m2,th1,th2,thdot1);

%Use the autoderived functions for the accelerations. 
thdotdot1 = thtdotdot1(FxCurrent,FyCurrent,p.I1,p.I2,T1,T2,p.d1,p.d2,p.g,p.l1,p.l2,p.m1,p.m2,th1,th2,thdot1,thdot2);
thdotdot2 = thtdotdot2(FxCurrent,FyCurrent,p.I1,p.I2,T1,T2,p.d1,p.d2,p.g,p.l1,p.l2,p.m1,p.m2,th1,th2,thdot1,thdot2);

%Assemble the state vector derivatives.
zdot = [thdot1
    thdotdot1
    thdot2
    thdotdot2
    ];

end



