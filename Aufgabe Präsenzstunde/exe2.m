function [ l12 ] = exe2( p1,p2)
%EXE2 Summary of this function goes here
%   Detailed explanation goes here

p1 = [p1; 1];
p2 = [p2; 1];

l12 = cross(p1,p2);


end

