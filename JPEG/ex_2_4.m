% 若对 DCT 系数分别做转置、旋转 90 度和旋转 180 度操作 (rot90) ，逆变换后恢复的图像有何变化？选取一块图验证你的结论。
%
% 答：
    % 转置：由于 DCT2 的变换基底矩阵组成的矩阵是对称的，所以将 DCT 系数矩阵转置后便是将原本加权水平（或垂直）纹理的系数给到相同的垂直（或水平）纹理上，逆变换后图像相比原图仅会同样地转置。
    % 旋转 90 度：将 DCT 系数矩阵逆时针旋转 90 度后，原本：a）加权低频纹理（左上角）的系数会变为加权垂直变化的高频纹理（左下角）；b）加权水平变化的高频纹理（右上角）的系数会变为加权低频纹理（左上角）；c）加权高频纹理（右下角）的系数会变为加权水平变化的高频纹理（右上角）；d）加权垂直变化的高频纹理（左下角）的系数会变为加权高频纹理（右下角）。由于自然照片的 DCT 系数矩阵的左上角系数较大，于是 DCT 系数矩阵逆时针旋转 90 度后，逆变换后的图像会：a）逆时针旋转 90 度；b）整体亮度变暗；c）出现明显的垂直变化的高频纹理（横向条纹）。
    % 旋转 180 度：类似上条分析，结果是：a）整体亮度变暗；b）出现明显国际象棋棋盘格式高频纹理。

clc; clear; close all;

load("attachments/hall.mat");
hall_dct = dct2(hall_gray);
[h, w] = size(hall_dct);

% 转置
hall_dct_transposed = hall_dct.';
% 90 度旋转
hall_dct_rot90 = rot90(hall_dct);
% 180 度旋转
hall_dct_rot180 = rot90(hall_dct, 2);
% 逆变换
hall_transposed = idct2(hall_dct_transposed);
hall_rot90 = idct2(hall_dct_rot90);
hall_rot180 = idct2(hall_dct_rot180);

% 显示结果
figure;
subplot(1, 4, 1);
imshow(hall_gray, []);
title('原图');
subplot(1, 4, 2);
imshow(hall_transposed, []);
title('转置后的图像');
subplot(1, 4, 3);
imshow(hall_rot90, []);
title('90度旋转后的图像');
subplot(1, 4, 4);
imshow(hall_rot180, []);
title('180度旋转后的图像');
saveas(gcf, 'attachments/ex_2_4.png');
