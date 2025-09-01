% 图像的预处理是将每个像素灰度值减去128，这个步骤是否可以在变换域进行？请在测试图像中截取一块验证你的结论。

clc; clear; close all;

load("attachments/hall.mat");
hall_gray = double(hall_gray);
[h, w] = size(hall_gray);

% 空域
hall_space = dct2(hall_gray - 128);
% 变换域
hall_dct = dct2(hall_gray);
hall_dct = hall_dct - dct2((ones(h, w) * 128));
% 验证
if all(round(hall_dct, 8) == round(hall_space, 8), 'all')
    disp("在变换域进行预处理在误差允许范围内可行。");
else
    disp("在变换域进行预处理不可行。");
end
