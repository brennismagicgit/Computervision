function [T1,R1,T2,R2] = TR_aus_E(E)
% In dieser Funktion sollen die moeglichen euklidischen Transformationen
% aus der Essentiellen Matrix extrahiert werden
    % Matrix die U und V SO3 macht falls diese es noch nicht sind
    makeSO3 = [1,0,0;0,1,0;0,0,-1];
    % Positive and Negative z-Rotation um pi/2
    Rz_pos = [0,-1,0;1,0,0;0,0,1];
    Rz_neg = [0,1,0;-1,0,0;0,0,1];
    % Überprüfen ob U und V SO3 sind - determinante gleich 1
    [U,S,V] = svd(E);
    if(det(U) < 0)
        U = U*makeSO3;
    end
    if(det(V) < 0)
        V = makeSO3*V;
    end
    % Berechnen der Möglichen Rotationen und Transformationen
    R1 = U*Rz_pos'*V';
    R2 = U*Rz_neg'*V';
    T1hat = U*Rz_pos*S*U';
    T2hat = U*Rz_neg*S*U';
    T1 = [T1hat(3,2);T1hat(1,3);T1hat(2,1)];
    T2 = [T2hat(3,2);T2hat(1,3);T2hat(2,1)];     
end