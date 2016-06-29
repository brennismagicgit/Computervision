function [T,R, lambdas, P1] = rekonstruktion(T1,T2,R1,R2, Korrespondenzen, K)
% Funktion zur Bestimmung der korrekten euklidischen Transformation, der
% Tiefeninformation und der 3D Punkte der Merkmalspunkte in Bild 1

    % Ergänze die Korrespondenzen zu homogenen Koordinaten
    x1 = [Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2 = [Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
    % Generiere kalibriere Punkte in der Bildebene
    x1 = K\x1;
    x2 = K\x2;
    
    M1 = makeM(R1,T1,x1,x2);
    M2 = makeM(R1,T2,x1,x2);
    M3 = makeM(R2,T1,x1,x2);
    M4 = makeM(R2,T2,x1,x2);
    
    [~,~,V1] = svd(M1);
    [~,~,V2] = svd(M2);
    [~,~,V3] = svd(M3);
    [~,~,V4] = svd(M4);
    
    lambda1 = V1(:,end);
    lambda2 = V2(:,end);
    lambda3 = V3(:,end);
    lambda4 = V4(:,end);
    
    nNeg = [sum(lambda1<=0),sum(lambda2<=0),sum(lambda3<=0),sum(lambda4<=0)];
    [~,ind] = min(nNeg);
    if (ind == 1)
        T = T1;
        R = R1;
        lambdas = lambda1;
        %...
    end
    if (ind == 2)
        T = T2;
        R = R1;
        lambdas = lambda2;
    end
    if (ind == 3) 
        T = T1;
        R = R2;
        lambdas = lambda3;
    end
    if (ind == 4)
        T = T2;
        R = R2;
        lambdas = lambda4;
    end
    P1 = lambdas(1)*x1(:,1);
        
end