function ra_e = ForwardKinematics(l1,l2,th1,th2)

t2 = th1+th2;

%2nd quadrant initialization
%ra_e = [-l2.*sin(t2)-l1.*sin(th1);l2.*cos(t2)+l1.*cos(tht1);0.0];

%4th quadrant initialization
ra_e = [l2.*cos(t2)+l1.*cos(th1); -l2.*sin(t2)-l1.*sin(th1);0.0];
