% 请编程实现二维 DCT ，并和 MATLAB 自带的库函数 dct2 比较是否一致。

clc; clear; close all;

a = [1, 2; 3, 4; 5, 6];
d1 = mydct2(a);
d2 = dct2(a);
if all(round(d1, 8) == round(d2, 8), 'all')
    disp("自定义的 mydct2 函数与 MATLAB 的 dct2 函数在误差允许范围内一致。");
else
    disp("自定义的 mydct2 函数与 MATLAB 的 dct2 函数不一致。");
end


function res = mydct2(A)
    % 计算二维离散余弦变换
    %   res = mydct2(A)
    %
    % 输入：
    %   A - 输入矩阵
    %
    % 输出：
    %   res - 二维 DCT 结果

    [h, w] = size(A);
    % 若A不是方阵，左乘和右乘的DCT矩阵阶数不同
    LD = genDCTMatrix(h); % 左乘的DCT矩阵
    RD = genDCTMatrix(w); % 右乘的DCT矩阵
    res = LD * A * RD.'; % 计算二维 DCT
end


function D = genDCTMatrix(N)
    % 生成N阶的DCT矩阵
    %   D = genDCTMatrix(N)
    %
    % 输入：
    %   N - DCT矩阵的阶数
    %
    % 输出：
    %   D - N阶DCT矩阵

    [mw, mh] = meshgrid(1:N, 1:N);
    D = cos(pi * (mh - 1) .* (2 * mw - 1) / (2 * N));
    D(1, :) = sqrt(0.5);
    D = D * sqrt(2 / N);
end
