function [ x1, x2] = exe1( l )
%1 Summary of this function goes here
%   Detailed explanation goes here

x1 = ones(3,1);
x1(2) = 0;
x1(1) = -l(3)/l(1);

x2 = ones(3,1);
x2(1) = 0;
x2(2) = -l(3)/l(2); 

end

