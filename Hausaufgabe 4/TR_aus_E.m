function [T1,R1,T2,R2] = TR_aus_E(E)
% In dieser Funktion sollen die moeglichen euklidischen Transformationen
% aus der Essentiellen Matrix extrahiert werden
    % Matrix that makes U and V SO(3) in case it it not
    makeSO3 = [1,0,0;0,1,0;0,0,-1];
    % Positive and Negative z-Rotation around pi/2
    Rz_pos = [0,1,0;1,0,0;0,0,1];
    Rz_neg = [0,-1,0;-1,0,0;0,0,1];
    % Check if U and V are SO(3) - If determinant is 1
    [U,S,V] = svd(E);
    if(det(U) == -1)
        U = U*makeSO3;
    else if(det(V) == -1)
            V = makeSO3*V;
        end
    end
    R1 = U*Rz_pos'*V';
    R2 = U*Rz_neg'*V';
    T1hat = U*Rz_pos*S*V';
    T2hat = U*Rz_neg*S*V';
    T1 = [T1hat(3,2);T1hat(1,3);T1hat(2,1)];
    T2 = [T2hat(3,2);T2hat(1,3);T2hat(2,1)];     
end