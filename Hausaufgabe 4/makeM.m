function [  M  ] = makeM( R,T,x1,x2 )
% Diese Funktion Berechnet die Matrix M um die Tiefe der Raumpunkte zu
% schätzen
    n = length(x1);
    M = zeros(3*n,n+1);

    for j = 1:n
        ind = linspace(1,3*(n-1)+1,n);
        x1j = x1(:,j);
        x2j = x2(:,j);
        % Calculate the Elements for each Row of M
        [Rj,Tj] = makeMrow(x1j,x2j,R,T);
        M(ind(j):ind(j)+2,j) = Rj;
        M(ind(j):ind(j)+2,n+1) = Tj;
    end
end

