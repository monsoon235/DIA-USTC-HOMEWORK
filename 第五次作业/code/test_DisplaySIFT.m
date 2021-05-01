%% Display SIFT features of two images
%
clear; 
close all;
clc;

%% Load two images and their SIFT features
src_1 = './test images/Mona-Lisa-73.jpg';
src_2 = './test images/Mona-Lisa-489.jpg';
ext1 = '.sift';  % extension name of SIFT file
ext2 = '.sift';  % extension name of SIFT file
siftDim = 128;

%% load image 
im_1 = imread(src_1);
im_2 = imread(src_2);

%% load SIFT feature
% SIFT
% feature文件格式：binary格式，开头四个字节（int）为特征数目，后面逐个为SIFT特征结构体，每个SIFT特征包含128D的描述子（128个字节）
% 和 [x, y, scale, orientation]的16字节的位置、尺度和主方向信息（float）

featPath_1 = [src_1, ext1];
featPath_2 = [src_2, ext2];

fid_1 = fopen(featPath_1, 'rb');
featNum_1 = fread(fid_1, 1, 'int32'); % 文件中SIFT特征的数目
SiftFeat_1 = zeros(siftDim, featNum_1); 
paraFeat_1 = zeros(4, featNum_1);
for i = 1 : featNum_1 % 逐个读取SIFT特征
    SiftFeat_1(:, i) = fread(fid_1, siftDim, 'uchar'); %先读入128维描述子
    paraFeat_1(:, i) = fread(fid_1, 4, 'float32');     %再读入[x, y, scale, orientation]信息
end
fclose(fid_1);

fid_2 = fopen(featPath_2, 'rb');
featNum_2 = fread(fid_2, 1, 'int32'); % 文件中SIFT特征的数目
SiftFeat_2 = zeros(siftDim, featNum_2);
paraFeat_2 = zeros(4, featNum_2);
for i = 1 : featNum_2 % 逐个读取SIFT特征
    SiftFeat_2(:, i) = fread(fid_2, siftDim, 'uchar'); %先读入128维描述子
    paraFeat_2(:, i) = fread(fid_2, 4, 'float32');     %再读入[x, y, scale, orientation]信息
end
fclose(fid_1);

%% normalization
SiftFeat_1 = SiftFeat_1 ./ repmat(sqrt(sum(SiftFeat_1.^2)), size(SiftFeat_1, 1), 1);
SiftFeat_2 = SiftFeat_2 ./ repmat(sqrt(sum(SiftFeat_2.^2)), size(SiftFeat_2, 1), 1);

%% Display SIFT feature on RGB image
[row, col, cn] = size(im_1);
[r2, c2, n2] = size(im_2);
imgBig = 255 * ones(max(row, r2), col + c2, 3);
imgBig(1 : row, 1 : col, :) = im_1;
imgBig(1 : r2, col + 1 : end, :) = im_2; %% 将两幅图像拼成了一副大图像，左右排列

np = 40;
thr = linspace(0, 2*pi, np) ;
Xp = cos(thr); % 确定一个单位圆
Yp = sin(thr);

paraFeat_2(1, :) = paraFeat_2(1, :) + col; % 第二幅图像中的SIFT feature的列坐标要修改

figure(1); imshow(uint8(imgBig)); axis on;
hold on;
for i = 1 : featNum_1
    xys =  paraFeat_1(:, i);
    if xys(3) < 25 && xys(3) > 3   % 由于特征太多，只显示尺度在(10, 20)区间内的SIFT    
        figure(1);
        hold on;
        radius = xys(3) * 6;
        plot(xys(1) + Xp * radius, xys(2) + Yp * radius, 'g');
    end
end

for i = 1 : featNum_2
    xys2 = paraFeat_2(:, i);
    if xys2(3) < 25 && xys2(3) > 3  % 由于特征太多，只显示尺度在(10, 20)区间内的SIFT       
        figure(1);
        hold on;
        radius = xys2(3) * 6;
        plot(xys2(1) + Xp * radius, xys2(2) + Yp * radius, 'g');
    end
end
hold off;