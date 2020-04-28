function Ta = impedenceControl(Kd,Kp,l1,l2,th1,th2,thdot1,thdot2,xdott,xt,ydott,yt)
%IMPEDANCE CONTROL

%Kinematics
t2 = th1+th2;
t3 = sin(t2);
t4 = l2.*t3;
t5 = sin(th1);
t6 = l1.*t5;
t7 = t4+t6;
t8 = cos(t2);
t9 = l2.*t8;
t10 = cos(th1);
t11 = l1.*t10;
t12 = t9+t11;

%Control
t13 = t12.*thdot1;
t14 = l2.*t8.*thdot2;
t15 = t13+t14+xdott;
t16 = Kd.*t15;
t17 = t4+t6+xt;
t18 = Kp.*t17;
t19 = t16+t18;
t20 = t7.*thdot1;
t21 = l2.*t3.*thdot2;
t22 = t20+t21+ydott;
t23 = Kd.*t22;
t24 = t9+t11-yt;
t25 = t23-Kp.*t24;
Ta = [-t12.*t19-t7.*t25;-l2.*t8.*t19-l2.*t3.*t25];