clc
close all
clear

 x1=[0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1; 0; 1;];
 x2=[0; 0; 1; 1; 0; 0; 1; 1; 0; 0; 1; 1; 0; 0; 1; 1;];
 x3=[0; 0; 0; 0; 1; 1; 1; 1; 0; 0; 0; 0; 1; 1; 1; 1;];
 x4=[0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1; 1; 1; 1; 1;];

x= [0 0 0 0;
    0 0 0 1;
    0 0 1 0;
    0 0 1 1;
    0 1 0 0;
    0 1 0 1;
    0 1 1 0;
    0 1 1 1;
    1 0 0 0;
    1 0 0 1;
    1 0 1 0;
    1 0 1 1;
    1 1 0 0;
    1 0 0 1;
    1 1 1 0;
    1 1 1 1;]

xrev= [ 0 0 0 0;
        1 0 0 0;
        0 1 0 0;
        1 1 0 0;
        0 0 1 0;
        1 0 1 0;
        0 1 1 0;
        1 1 1 0;
        0 0 0 1;
        1 1 0 1;
        0 1 0 1;
        1 0 0 1;
        0 0 1 1;
        1 0 1 1;
        0 1 1 1;
        1 1 1 1;]


ID = [2 2 0 9 6 2]
bin=[0; 1; 0; 1; 1; 1; 1; 1; 0; 0; 1; 0; 0; 0 ;1; 0;];
binrev=[0 1 0 1 1 1 1 1 0 0 1 0 0 0 1 0];


entropy_x1 = 8/16*(-2/8 * log2(2/8) - 6/8 * log2(6/8)) + 8/16*(-2/8 * log2(2/8) - 6/8 * log2(6/8)) % -> nejmensi
entropy_x2 = 8/16*(-5/8 * log2(5/8) - 3/8 * log2(3/8)) + 8/16*(-3/8 * log2(3/8) - 5/8 * log2(5/8))
entropy_x3 = 8/16*(-5/8 * log2(5/8) - 3/8 * log2(3/8)) + 8/16*(-3/8 * log2(3/8) - 5/8 * log2(5/8))
entropy_x4 = 8/16*(-5/8 * log2(5/8) - 3/8 * log2(3/8)) + 8/16*(-3/8 * log2(3/8) - 5/8 * log2(5/8))


dataset=[entropy_x1,entropy_x2,entropy_x3,entropy_x4]

M =fitctree(xrev,bin)
view(M, 'Mode','Graph')
