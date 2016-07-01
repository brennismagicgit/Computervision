function [T,R, lambdas, P1] = rekonstruktion(T1,T2,R1,R2, Korrespondenzen, K)
% Funktion zur Bestimmung der korrekten euklidischen Transformation, der
% Tiefeninformation und der 3D Punkte der Merkmalspunkte in Bild 1

    % Ergänze die Korrespondenzen zu homogenen Koordinaten
    x1 = [Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2 = [Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
    % Generiere kalibriere Punkte in der Bildebene
    x1 = K\x1;
    x2 = K\x2;
    % Erstelle vier M matrizen mit allen Permutationen von T und R
    M1 = makeM(R1,T1,x1,x2);
    M2 = makeM(R1,T2,x1,x2);
    M3 = makeM(R2,T1,x1,x2);
    M4 = makeM(R2,T2,x1,x2);
    % SVD zerlegung um LGS M*lambda = 0 zu lösen
    [~,~,V1] = svd(M1);
    [~,~,V2] = svd(M2);
    [~,~,V3] = svd(M3);
    [~,~,V4] = svd(M4);
    % Extrahiere rechtsseitigen Singulärvektor zum kleinsten Singulärwert
    lambda1 = V1(:,end);
    lambda2 = V2(:,end);
    lambda3 = V3(:,end);
    lambda4 = V4(:,end);
    lambda = [lambda1,lambda2,lambda3,lambda4];
    % Bestimme lambda vector mit den meisten positiven lambdas
    nNeg = [sum(lambda1<=0),sum(lambda2<=0),sum(lambda3<=0),sum(lambda4<=0)];
    [nMin ,ind] = min(nNeg);
    % zwei oder mehr lambda sets haben die gleich anzahl an negative
    % Elementen:
    % wähle das Set, dass näher an null ist
    nMinSets = length(find(nMin == nNeg));
    if(nMinSets > 1)
        iMinSets = find(nMin == nNeg);
        equalSets = lambda(:,iMinSets);
        negEqualSets = reshape(equalSets(equalSets < 0),[length(equalSets(equalSets < 0))/2 2]);
        [~,i] = max(sum(negEqualSets));
        ind = iMinSets(i);
    end
    % Wähle korrekte Euklidische Transformation
    if (ind == 1)
        T = T1*lambda1(end);
        R = R1;
        lambdas = lambda1(1:end-1);
    end 
    if (ind == 2)
        T = T2*lambda2(end);
        R = R1;
        lambdas = lambda2(1:end-1);
    end
    if (ind == 3) 
        T = T1*lambda3(end);
        R = R2;
        lambdas = lambda3(1:end-1);
    end
    if (ind == 4)
        T = T2*lambda4(end);
        R = R2;
        lambdas = lambda4(1:end-1);
    end
    % Bestimme 3D Koordinaten von x1
    P1 = [lambdas,lambdas,lambdas].*x1';
        
end