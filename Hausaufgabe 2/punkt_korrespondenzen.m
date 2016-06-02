function [Korrespondenzen] = punkt_korrespondenzen(I1,I2,Mpt1,Mpt2,varargin)
% In dieser Funktion sollen die extrahierten Merkmalspunkte aus einer
% Stereo-Aufnahme mittels NCC verglichen werden um Korrespondenzpunktpaare
% zu ermitteln.

%% Input parser
    P = inputParser;

    defaultWindowLength = 9;
    defaultMinCorr = 0.99;
    defaultMaxSSD = 1e3;
    defaultPlot = false;
    defaultUseSSD = false;
   
    % Liste der notwendigen Parameter
    % Ein Bild als Input ist zwingend notwendig
    P.addRequired('Image1', @(x)isnumeric(x));
    P.addRequired('Image2', @(x)isnumeric(x));
    P.addRequired('Features1', @(x)isnumeric(x));
    P.addRequired('Features2', @(x)isnumeric(x));
    % List der optionalen Parameter
    P.addOptional('window_length', defaultWindowLength, @(x) x > 1 && mod(x,2));
    P.addOptional('min_corr', defaultMinCorr, @(x)isnumeric(x));
    P.addOptional('use_SSD', defaultUseSSD, @(x) islogical(x));
    P.addOptional('max_SSD', defaultMaxSSD, @(x)isnumeric(x)); 
    P.addOptional('do_plot', defaultPlot, @(x)islogical(x));

    
    % Parsen der Eingabewerte
    P.parse(I1,I2,Mpt1,Mpt2,varargin{:});

%% Korrespondenzsuche

    IGray1 = I1;
    IGray2 = I2;
    Merkmale1 = Mpt1;
    Merkmale2 = Mpt2;
    
    window_length = P.Results.window_length;
    min_corr = P.Results.min_corr;
    use_SSD = P.Results.use_SSD;
    max_SSD = P.Results.max_SSD;
    do_plot = P.Results.do_plot;
   
    w = floor(window_length/2);
    
    padIGray1 = padarray(IGray1,[w w],'symmetric'); 
    padIGray2 = padarray(IGray2,[w w],'symmetric');

    N = window_length*window_length; 

    korrespondIndex = zeros(1,length(Merkmale1));
    
    tic;
    
    for i=1:length(Merkmale1)
        W = padIGray1(Merkmale1(2,i):Merkmale1(2,i)+2*w,Merkmale1(1,i):Merkmale1(1,i)+2*w);
        zeroMeanW = double(W)-mean2(W);
        sigmaW = std2(W);
        Wn = zeroMeanW/sigmaW;

        NCC = zeros(length(Merkmale2),1);

        for j=1:length(Merkmale2)
            V = padIGray2(Merkmale2(2,j):Merkmale2(2,j)+2*w,Merkmale2(1,j):Merkmale2(1,j)+2*w);
            zeroMeanV = double(V)-mean2(V);
            sigmaV = std2(V);
            Vn = zeroMeanV/sigmaV;
            NCC(j) = (1/(N-1))*trace(Wn'*Vn);
        end
        [v, nr ] = max(NCC);
        if(use_SSD == true)
            SSD = norm(double(V-W),'fro')^2;
            if(v >= min_corr && SSD <= max_SSD)
                korrespondIndex(i) = nr;
            else
                korrespondIndex(i) = 0;
            end
        else
            if(v >= min_corr)
                korrespondIndex(i) = nr;
            else
                korrespondIndex(i) = 0;
            end
        end
    end

    [M, I] = find(korrespondIndex ~= 0);
    Korrespondenzen = [Merkmale1(:,I);Merkmale2(:,korrespondIndex(I))];

    toc;
    
    if(do_plot == true)
        figure(1);
        imshow([IGray1,IGray2]);
        [r,c] = size(IGray1);
        hold on
        for i = 1:length(Korrespondenzen)
            y = [Korrespondenzen(2,i),Korrespondenzen(4,i)];
            x = [Korrespondenzen(1,i),Korrespondenzen(3,i)+c];
            plot(x,y,'-yx','MarkerEdgeColor','r');
        end
        title('Matched Features');
    end

end


