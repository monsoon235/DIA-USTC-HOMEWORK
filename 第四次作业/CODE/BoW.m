%% BOW
% 清理空间
clear;
close all; 
clc; 

%% Read xxxx.SIFT 
% 读入SIFT特征
num_pic = 1000;
KM = 1000;
num_sample = 6000 * 15;

srcFolderPath = './SIFT';
allFiles = dir(srcFolderPath);
imgCount = 0;
for i = 3 : length(allFiles)
    fileName = allFiles(i).name;
    if length(fileName) > 3 && strcmp(fileName(end-9 : end-6), '.jpg') == 1
        imgCount = imgCount + 1;
        imgPath = [srcFolderPath, '/', fileName(1:end-6)];
        %fprintf('File %d: %s\n', imgCount, imgPath);
        sift = readsift(imgPath); 
        SiftFeat{imgCount} = sift;
    end
end

%% SIFT_ALL
sift_all = [];

for i=1:num_pic
    sift_all = [sift_all;SiftFeat{i}];
end

% load 'sift_all'

% 抽取部分SIFT 特征
[sm,sn] = size(sift_all);
ind_chose = randperm(sm,num_sample);
sift_chose = sift_all(ind_chose,:);

% KMEANS 获得码本
num_codebook = KM; 
[Idx_all,C] = kmeans(sift_chose,num_codebook,'MaxIter',100,'display','iter');

clear sift_all;clear SiftFeat;

%% BOW
% SIFT特征读入
srcFolderPath = './SIFT';
allFiles = dir(srcFolderPath);
imgCount = 0;
for i = 3 : length(allFiles) %从3开始
    fileName = allFiles(i).name;
    if length(fileName) > 3 && strcmp(fileName(end-9 : end-6), '.jpg') == 1 % find JPG image file
        imgCount = imgCount + 1;
        imgPath = [srcFolderPath, '/', fileName(1:end-6)];
        %fprintf('File %d: %s\n', imgCount, imgPath);
        sift = readsift(imgPath); % read sift--> 读取存储的sift算子
        [sm,sn]=size(sift);
        SiftFeat{imgCount} = sift(randperm(sm, floor(sm)),:);%传入归一化后的sift,  而且已经被转制并随机抽取部分行
    end
end

% 计算到中心聚类点的距离，根据距离确定直方图
for i = 1:num_pic
    % disp(i)
    similarDistances = pdist2(SiftFeat{i},C); 
    [minElements,idx] = min(similarDistances,[],2);
    bins = 0.5:1:KM+0.5;
    hist = histogram(idx,bins);
    Features = hist.Values;
    % L1 归一化
    Features = Features./sum(Features);
%     % L2 归一化
%     Features = Features./sqrt(sum(Features.^2));
    Final_Hist(i,:) = Features';    
end

% 计算各图片与其它图片间的距离
result_Ech = zeros(num_pic,num_pic);
for i=1:num_pic
    for j=1:num_pic
        result_Ech(i,j) = sum((Final_Hist(i,:)-Final_Hist(j,:)).^2);
    end
end

% 提取距离最小的前四幅图的id
temp_result = sort(result_Ech,2);
result = zeros(num_pic,4);
for i=1:num_pic
    for j=1:4
        temp_find = find(result_Ech(i,:)==temp_result(i,j));
        result(i,j) = temp_find(1);
    end
end

% 计算相关程度
for i=1:(num_pic/4)
    class{i} = [(i-1)*4+1:(i-1)*4+4];
end

for i=1:num_pic
    num_result = 1;
    for j=2:4
        temp = find(class{ceil(i/4)}==result(i,j));
        if ~isempty(temp)
            num_result = num_result+1;
        end
        result_one(i) = num_result;
    end
end

% 输出检索准确率
result_average = mean(result_one)./4;
BOW1000L1 = result_average;
str_name = ['BOW',num2str(KM),'L1'];
save(str_name,str_name);
open bow_vs_K.fig