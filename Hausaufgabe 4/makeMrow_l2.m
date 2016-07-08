function [ Rpart , Tpart ] = makeMrow_l2( x1,x2,R,T )
% Diese funktion erzeugt die Elemente für Matrix M für das j te
% Korrespondenzpunktpaar
    x1hat = [0,-x1(3),x1(2);x1(3),0,-x1(1);-x1(2),x1(1),0];
    Rpart = x1hat*R'*x2;
    Tpart = (-1)*x1hat*R'*T;
end

