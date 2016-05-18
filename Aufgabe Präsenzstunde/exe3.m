function [ x ] = exe3( p1,p2,p3,p4 )

p1 = [p1;1];
p2 = [p2;1];
p3 = [p3;1];
p4 = [p4;1];

x12 = cross(p1,p2);
x34 = cross(p3,p4);

x = cross(x12,x34);

x = x/x(3);

x = [x(1);x(2)];


end

