% servo theta angles
syms tht1 tht2 tht3 tht4;

tht1 = pi/2;
tht2 = pi/2;
tht3 = pi/2;
tht4 = pi/2;

% link lenghts
syms l1 l2 l3 l4

l1 = 0;
l2 = 0;
l3 = 0;
l4 = 1;

% DH matiix

dh_parameters = [tht1  pi/2    0   l1;
                 tht2  -pi/2   0   l2;
                 tht3  pi/2    l3  0 ;
                 tht4  0       l4  0 ;];
                
% homogeneous transformation matrix

a1 = [cos(tht1) 0 sin(tht1)  0 ;
      sin(tht1) 0 -cos(tht1) 0 ;
      0         1 0          l1;
      0         0 0          1 ;];
  
a2 = [cos(tht2) 0  -sin(tht2) 0 ;
      sin(tht2) 0  cos(tht2)  0 ;
      0         -1 0          l2;
      0         0  0          1 ;];

a3 = [cos(tht3) 0 sin(tht3)  l3*cos(tht3);
      sin(tht3) 0 -cos(tht3) l3*sin(tht3);
      0         1 0          0           ;
      0         0 0          1           ;];

a4 = [cos(tht4) -sin(tht4) 0 l4*cos(tht4);
      sin(tht4) cos(tht4)  0 l4*sin(tht4);
      0         0          1 0           ;
      0         0          0 1           ;];
  
tf_matrix = a1*a2*a3*a4;

x = tf_matrix(1,4)
y = tf_matrix(2,4)
z = tf_matrix(3,4)

