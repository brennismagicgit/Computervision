function [Rpart,Tpart] = makeMrow( x1,x2,R,T)
% Diese funktion erzeugt die Elemente f�r Matrix M f�r das j te
% Korrespondenzpunktpaar
    x2hat = [0,-x2(3),x2(2);x2(3),0,-x2(1);-x2(2),x2(1),0];
    Rpart = x2hat*R*x1;
    Tpart = x2hat*T;
end

