function repro_error = rueckprojektion(Korrespondenzen, P1, I2, T, R, K)
% Diese Funktion berechnet die projizierten Punkte in Kamera 2 und den
% mittleren Rueckprojektionsfehler
    % Berechnen von 3D P1 in Kordinatensystem 2 - P2
    P2 = bsxfun(@plus,R*P1',T)';
    % Berechnen von PixelKoordinaten von P2
    x2_px = (K*P2')';
    x2_px = round([x2_px(:,1)./x2_px(:,3),x2_px(:,2)./x2_px(:,3)])';
    
    x2 = Korrespondenzen(3:4,:);
    n = length(Korrespondenzen);
    % Calculate reprojection Error
    diff = (x2-x2_px);
    repro_error = sum(sqrt(sum(diff.^2)))/n;
    
    %% Darstellen der Geschätzten Punkte
    figure(2);
    imshow(I2);
    hold on
    for i = 1:length(Korrespondenzen)
        x = [Korrespondenzen(3,i),x2_px(1,i)];
        y = [Korrespondenzen(4,i),x2_px(2,i)];
        plot(x,y,'-y')%'-yx','MarkerEdgeColor','r')
    end
    Merkmale = plot(Korrespondenzen(3,:),Korrespondenzen(4,:),'xr');
    Reprojection = plot(x2_px(1,:),x2_px(2,:),'*b');
    legend([Merkmale Reprojection],{'Merkmale','Reprojection'});

 end