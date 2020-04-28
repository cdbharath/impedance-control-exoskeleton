function T1Eq = gravityCompT1(Fdx,Fdy,d1,d2,g,l1,l2,m1,m2,th1,th2,thdot1,thdot2)

t2 = th1+th2;
t3 = sin(t2);
t4 = sin(th1);
t5 = sin(th2);
T1Eq = Fdy.*l1.*t4+Fdy.*l2.*t3+Fdx.*l2.*cos(t2)+Fdx.*l1.*cos(th1)-d1.*g.*m1.*t4-d2.*g.*m2.*t3-g.*l1.*m2.*t4-d2.*l1.*m2.*t5.*thdot2.^2-d2.*l1.*m2.*t5.*thdot1.*thdot2.*2.0;