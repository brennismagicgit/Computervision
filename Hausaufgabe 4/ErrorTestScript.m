
scriptname = 'CVHA4';
testNr = 100;
thresh = 100;
x = [1:1:testNr];
y = zeros(1,testNr);

for i=1:100    
    run(scriptname);
    y(i) = repro_error;
    disp(i);
end

good = sum([y<thresh]);
bad = testNr-good;

yBar = [good,bad];
xBar = [0,1];

figure(3);
bar(xBar,yBar);