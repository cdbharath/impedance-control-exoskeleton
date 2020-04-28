function T2Eq = gravityCompT2(Fdx,Fdy,d2,g,l1,l2,m2,th1,th2,thdot1)

t2 = th1+th2;
t3 = sin(t2);
T2Eq = Fdy.*l2.*t3+Fdx.*l2.*cos(t2)-d2.*g.*m2.*t3+d2.*l1.*m2.*thdot1.^2.*sin(th2);