% 利用MATLAB 提供的Image file I/O 函数分别完成以下处理：
    %（a）以割试图像的中心为圆心，图像的长和宽中较小值的一半为半径画一个红颜色的圆。
    %（b）将割试图像涂成国际象棋状的“黑白格”的样子，其中“黑”即黑色，“白”则意味着保留原图。

clc; clear; close all;

load("attachments/hall.mat");
[h, w, t] = size(hall_color);
r = min(h, w) / 2;
[mw, mh] = meshgrid(1 : w, 1 : h);

% --------- 绘制红色圆 ---------
circle = (mw - w/2).^2 + (mh - h/2).^2 <= r^2;
hall_color_circle = zeros(h, w, t, 'uint8');
hall_color_circle(:, :, 1) = max(hall_color(:, :, 1), uint8(circle) * 255);
hall_color_circle(:, :, 2) = hall_color(:, :, 2) .* uint8(~circle);
hall_color_circle(:, :, 3) = hall_color(:, :, 3) .* uint8(~circle);

% --------- 绘制国际象棋网格 ---------
bh = h / 8; bw = w / 8;
chessboard = xor(mod(floor(mh / bh), 2), mod(floor(mw / bw), 2));
hall_color_chessboard = hall_color .* uint8(chessboard);

% --------- 绘图 ---------
figure;
subplot(1, 3, 1);
imshow(hall_color);
title("原图");
subplot(1, 3, 2);
imshow(hall_color_circle);
title("红色圆");
subplot(1, 3, 3);
imshow(hall_color_chessboard);
title("国际象棋网格");
saveas(gcf, "attachments/ex_1_2.png");
