function [T,R, lambdas, P1] = rekonstruktion(T1,T2,R1,R2, Korrespondenzen, K)
% Funktion zur Bestimmung der korrekten euklidischen Transformation, der
% Tiefeninformation und der 3D Punkte der Merkmalspunkte in Bild 1
    lambda = cell(4,2);
    % Ergänze die Korrespondenzen zu homogenen Koordinaten
    x1 = [Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2 = [Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
    % Generiere kalibriere Punkte in der Bildebene
    x1 = K\x1;
    x2 = K\x2;
    % Erstelle vier M matrizen mit allen Permutationen von T und R für
    % Bild 1
    M1_l1 = makeM_l1(R1,T1,x1,x2);
    M2_l1 = makeM_l1(R1,T2,x1,x2);
    M3_l1 = makeM_l1(R2,T1,x1,x2);
    M4_l1 = makeM_l1(R2,T2,x1,x2);
    % Bild 2
    M1_l2 = makeM_l2(R1,T1,x1,x2);
    M2_l2 = makeM_l2(R1,T2,x1,x2);
    M3_l2 = makeM_l2(R2,T1,x1,x2);
    M4_l2 = makeM_l2(R2,T2,x1,x2);
    % SVD zerlegung um LGS M*lambda = 0 zu lösen
    [~,~,V1_l1] = svd(M1_l1);
    [~,~,V2_l1] = svd(M2_l1);
    [~,~,V3_l1] = svd(M3_l1);
    [~,~,V4_l1] = svd(M4_l1);
    [~,~,V1_l2] = svd(M1_l2);
    [~,~,V2_l2] = svd(M2_l2);
    [~,~,V3_l2] = svd(M3_l2);
    [~,~,V4_l2] = svd(M4_l2);
    % Extrahiere rechtsseitigen Singulärvektor zum kleinsten Singulärwert
    lambda{1,1} = V1_l1(:,end)./V1_l1(end:end);
    lambda{2,1} = V2_l1(:,end)./V2_l1(end:end);
    lambda{3,1} = V3_l1(:,end)./V3_l1(end:end);
    lambda{4,1} = V4_l1(:,end)./V4_l1(end:end);
    lambda{1,2} = V1_l2(:,end)./V1_l2(end:end);
    lambda{2,2} = V2_l2(:,end)./V2_l2(end:end);
    lambda{3,2} = V3_l2(:,end)./V3_l2(end:end);
    lambda{4,2} = V4_l2(:,end)./V4_l2(end:end);
    % Berechne max Anzahl an Positiven lambdas für Beide Bilder und alle
    % Transformationen
    nPos = [getnPos(lambda{1,1},lambda{1,2}),getnPos(lambda{2,1},lambda{2,2}),...
            getnPos(lambda{3,1},lambda{3,2}),getnPos(lambda{4,1},lambda{4,2})];
    [~,ind] = max(nPos);
    % Wähle korrekte Euklidische Transformation
    if (ind == 1)
        T = T1;
        R = R1;
        lambdas = [lambda{1,1},lambda{1,2}];
    end 
    if (ind == 2)
        T = T2;
        R = R1;
        lambdas = [lambda{2,1},lambda{2,2}];
    end
    if (ind == 3) 
        T = T1;
        R = R2;
        lambdas = [lambda{3,1},lambda{3,2}];
    end
    if (ind == 4)
        T = T2;
        R = R2;
        lambdas = [lambda{4,1},lambda{4,2}];
    end
    % Bestimme 3D Koordinaten von x1
    P1 = [lambdas(1:end-1,1),lambdas(1:end-1,1),lambdas(1:end-1,1)].*x1';
    %% Plotten der Punkte P1 und der Beiden Camera Frames
    camCorners = [3000, 3000, 0, 0, 3000,;
                2000,  0, 0, 2000, 2000;
                1,1,1,1           ,1];
          
    camCorners = K\camCorners;
    camCorners2 = (R*camCorners + [T,T,T,T,T]);
    
    figure(1); 
    plotPoints(P1);
    hold on;
    plotCamera(camCorners, 'Camera1');
    plotCamera(camCorners2, 'Camera2');
end