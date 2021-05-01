function SiftFeat = readsift(imgPath)

src_1 = imgPath;
ext1 = '.dsift'; %'.vsift_640'; % extension name of SIFT file
siftDim = 128;
% im_1 = imread(src_1);
% figure,imshow(im_1);

featPath_1 = [src_1, ext1];
fid_1 = fopen(featPath_1, 'rb');
featNum_1 = fread(fid_1, 1, 'int32'); 
SiftFeat_1 = zeros(siftDim, featNum_1);
% paraFeat_1 = zeros(4, featNum_1);
for i = 1 : featNum_1 % Öð¸ö¶ÁÈ¡SIFTÌØÕ÷
    SiftFeat_1(:, i) = fread(fid_1, siftDim, 'uchar'); 
    paraFeat_1(:, i) = fread(fid_1, 4, 'float32');     
end
fclose(fid_1);

%% normalization
SiftFeat_1 = SiftFeat_1 ./ repmat(sqrt(sum(SiftFeat_1.^2)), size(SiftFeat_1, 1), 1);
SiftFeat = SiftFeat_1';

end
