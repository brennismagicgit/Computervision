function [  M  ] = makeM_l1( R,T,x1,x2 )
% Diese Funktion Berechnet die Matrix M um die Tiefe der Raumpunkte zu
% schätzen (Bild 1)
    n = length(x1);
    % Vorinitialisierug der Matrix M als Nullmatirx
    M = zeros(3*n,n+1);
    for j = 1:n
        % Erzeuge indizes um die jeweiligen zeilen korrekt aufzufüllen
        ind = linspace(1,3*(n-1)+1,n);
        % Extrahiere j tes Korrespondenzpunktpaar
        x1j = x1(:,j);
        x2j = x2(:,j);
        % Berechnen der Elemente der Matrix M für die j te Zeile
        [Rj,Tj] = makeMrow_l1(x1j,x2j,R,T);
        M(ind(j):ind(j)+2,j) = Rj;
        M(ind(j):ind(j)+2,n+1) = Tj;
    end
end

