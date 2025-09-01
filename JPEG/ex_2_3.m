% 如果将 DCT 系数矩阵中右侧四列的系数全部置零，逆变换后的图像会发生什么变化？选取一块图验证你的结论。如果左侧的四列置零呢？
%
% 答：
    % 将 DCT 系数矩阵中一列置零相当于去掉图像上一部分水平方向上变化的信息。
    % 将 DCT 系数矩阵的右侧四列全部置零相当于去掉图像上水平方向上变化的高频信息。如一些竖直的轮廓分明的线条可能变得模糊等。
    % 将 DCT 系数矩阵的左侧四列置零相当于去掉图像上水平方向上变化的低频信息。图像整体亮度变暗，可能会出现一些剧烈变化的条纹等。
    % 由于 hall_gray 列数比较多，仅将 DCT 系数矩阵的四列置零，逆变换后的图像与原图差别不明显，于是改为了将右侧 80 列置零，左侧 8 列置零。

clc; clear; close all;

load("attachments/hall.mat");
hall_dct = dct2(hall_gray);
[h, w] = size(hall_dct);

% 右侧四列置零
hall_dct_right_zeroed = hall_dct;
hall_dct_right_zeroed(:, w-79:w) = 0;
% 左侧四列置零
hall_dct_left_zeroed = hall_dct;
hall_dct_left_zeroed(:, 1:8) = 0;
% 逆变换
hall_right_zeroed = idct2(hall_dct_right_zeroed);
hall_left_zeroed = idct2(hall_dct_left_zeroed);

% 显示结果
figure;
subplot(1, 3, 1);
imshow(hall_gray, []);
title('原图');
subplot(1, 3, 2);
imshow(hall_right_zeroed, []);
title('右侧四列置零后的图像');
subplot(1, 3, 3);
imshow(hall_left_zeroed, []);
title('左侧四列置零后的图像');
saveas(gcf, 'attachments/ex_2_3.png');
