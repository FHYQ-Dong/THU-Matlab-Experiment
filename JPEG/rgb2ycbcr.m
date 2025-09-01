function [Y, Cb, Cr] = rgb2ycbcr(R, G, B)
% 将RGB颜色空间转换为YCbCr颜色空间
%   [Y, Cb, Cr] = rgb2ycbcr(R, G, B)
%
%   输入:
%       R, G, B - 分量图像，范围为0-255

%   输出:
%       Y  - 亮度分量
%       Cb - 蓝色差分量
%       Cr - 红色差分量
%
%   注意: 输入图像应为uint8类型，输出图像也为uint8类型

    Y = uint8(0.299 * double(R) + 0.587 * double(G) + 0.114 * double(B));
    Cb = uint8(128 + (-0.168736 * double(R) - 0.331364 * double(G) + 0.5 * double(B)));
    Cr = uint8(128 + (0.5 * double(R) - 0.418688 * double(G) - 0.081312 * double(B)));
