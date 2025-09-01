function [R, G, B] = ycbcr2rgb(Y, Cb, Cr)
% 将YCbCr颜色空间转换为RGB颜色空间
%   [R, G, B] = ycbcr2rgb(Y, Cb, Cr)
%
%   输入:
%       Y  - 亮度分量
%       Cb - 蓝色差分量
%       Cr - 红色差分量
%
%   输出:
%       R, G, B - 分量图像，范围为0-255
%
%   注意: 输入图像应为uint8类型，输出图像也为uint8类型

    Y = double(Y);
    Cb = double(Cb) - 128;
    Cr = double(Cr) - 128;

    R = uint8(Y + 1.402 * Cr);
    G = uint8(Y - 0.344136 * Cb - 0.714136 * Cr);
    B = uint8(Y + 1.772 * Cb);
end