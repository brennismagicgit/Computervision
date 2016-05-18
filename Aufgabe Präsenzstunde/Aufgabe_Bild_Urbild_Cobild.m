% Vervollständigen Sie das folgende Skript:
clear all;

Image = imread('bild.png');

l1 = [1; -10; 740];
l2 = [2; 5; -1470];

p1 = [125; 214];
p2 = [200; 354];
p3 = [124; 150];
p4 = [292; 118];
p5 = [244; 191];
p6 = [68; 255];
p7 = [131; 399];
p8 = [35; 109];
p9 = [113; 358];
p10 = [54; 223];

imshow(Image);
hold on;
plot(p1,p2, 'linewidth', 5);
plot(p3,p4, 'linewidth', 5);
kreuz = exe3(p1,p2,p3,p4);
plot(kreuz(1),kreuz(2),'x');


