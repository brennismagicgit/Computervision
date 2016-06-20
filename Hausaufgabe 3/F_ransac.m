function [Korrespondenzen_robust] = F_ransac(Korrespondenzen,varargin)
% Diese Funktion implementiert den RANSAC-Algorithmus zur Bestimmung von
% robusten Korrespondenzpunktpaaren

%% Input Parser
    P = inputParser;
    % Optionale Parameter
    P.addOptional('epsilon', 0.65, @isnumeric);
    P.addOptional('p', 0.99, @isnumeric);
    P.addOptional('tolerance',0.05, @isnumeric);
    % Lese den Input
    P.parse(varargin{:});
    % Extrahiere die Variablen aus dem Input-Parser
    epsilon  = P.Results.epsilon;
    p        = P.Results.p;
    tolerance= P.Results.tolerance;
%% RANSAC
    % Anzahl der Korrespondenzpaare die für den 8 punkt algorithmus
    % verwendet werden
    k = 8;
    % Berechenen und Aufrunden der nötigen Iterationszahl für erreichen der
    % Trefferwarscheinlichkeit p
    s = ceil(log(1-p)/(log(1-(1-epsilon)^k)));
    
    n = length(Korrespondenzen); % Anzahl der Korrespondenzen
    x1_ = [Korrespondenzen(1:2,:);ones(1,n)]; % Hommogene Pixelkoordinaten Korresppndenzen Bild 1
    x2_ = [Korrespondenzen(3:4,:);ones(1,n)]; % Hommogene Pixelkoordinaten Korresppndenzen Bild 2
    
    eHat = [0,-1,0;1,0,0;0,0,0];
    maxMatch = 0;   % maximale Anzahl der gefundenen Matches
    
    for i=1:s
        select = randperm(n,k); % Auswählen von k zufälligen Korrespondenzen
        F = achtpunktalgorithmus(Korrespondenzen(:,select));    % Berechnen von F mittels 8 Punk Algorithmus
        
        num = diag(x2_'*F*x1_).^2;
        den = norm(eHat*F*x1_)+norm(x2_'*F*eHat);
        SampsonD = num/den;     % Bestimmen der Sampson Distanz aller Korrespondenzen zur Transformation F 
        
        index = SampsonD < tolerance;           % bestimmen der zulässigen Matches
        Consensus = Korrespondenzen(:,index);   % Abspeichern des Aktuellen Consensus
        nMatch = size(Consensus,2);             % Anzahl der gedundenen Matches
        if nMatch > maxMatch                    % Aktualisierung wenn mehr Matches gefunden wurden
            maxMatch = nMatch;
            maxConsensus = Consensus;   
        end
    end
    Korrespondenzen_robust = maxConsensus;      % Ausgabe des Größten Consensus
end