function [EF] = achtpunktalgorithmus(Korrespondenzen,K)
% Diese Funktion berechnet die Essentielle Matrix oder Fundamentalmatrix
% mittels 8-Punkt-Algorithmus, je nachdem, ob die Kalibrierungsmatrix 'K'
% vorliegt oder nicht

    n = length(Korrespondenzen); % Anzahl der Korrespondenzen
    x1_ = [Korrespondenzen(1:2,:);ones(1,n)]; % Hommogene Pixelkoordinaten Korresppndenzen Bild 1
    x2_ = [Korrespondenzen(3:4,:);ones(1,n)]; % Hommogene Pixelkoordinaten Korresppndenzen Bild 2
    
    % Kronecker Produkt von jeder Korrespondenz
    A = [x1_(1,:).*x2_(1,:);x1_(1,:).*x2_(2,:);x1_(1,:).*x2_(3,:);...
         x1_(2,:).*x2_(1,:);x1_(2,:).*x2_(2,:);x1_(2,:).*x2_(3,:);...
         x1_(3,:).*x2_(1,:);x1_(3,:).*x2_(2,:);x1_(3,:).*x2_(3,:)]';
   % Singluärwertzerlegung von A  
   [U,S,V] = svd(A);
   % G ist umsortierte 9 te Spalte von V ( Spalte zum kleinsten
   % rechtsseitigen Singulärwert von A ) 
   G = reshape(V(:,9),[3,3]);
   % Singulärwerte von G anpassen um nächste Fundamentale matrix zu Finden
   % Kleinster Singulärwert zu null setzen
   [Ug,Sg,Vg] = svd(G);
   EF = Ug*[Sg(1,1),0,0;0,Sg(2,2),0;0,0,0]*Vg'; 
   % Berechnen der Essenziellen matrix aus F wenn K gegeben ist
   if nargin == 2
       EF = K'*EF*K;
   end
end