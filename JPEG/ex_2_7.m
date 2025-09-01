% 你知道哪些实现 Zig-Zag 扫描的方法？请利用 MATLAB 的强大功能设计一种最佳方法。
%
% 答：
    % 1. 直接使用循环：分别遍历每一条反对角线，将扫描的结果填入预先分配的 Zig-Zag 向量中。
    % 2. 对 1. 进行优化：对于大小均为 m x n 的矩阵，先用 1. 中方法计算出可以使矩阵元素按 Zig-Zag 顺序排列的线性索引，然后直接使用该索引对矩阵进行重排。
    % 3. 向量化方法（ChatGPT 给出）：同样是计算出 Zig-Zag 顺序的线性索引，但利用 MATLAB 的矩阵运算和排序功能，避免显式循环，从而提高效率：
        % 3.1 使用 ndgrid 生成每个元素的行、列坐标矩阵。
        % 3.2 计算每个元素所在的反对角线编号 S = I + J。
        % 3.3 令 K = I 作为同一反对角线内的次序键，并对偶数条反对角线将 K 取负以实现降序。
        % 3.4 使用 sortrows 按照 S(:) 和 K(:) 对所有元素进行排序，取 order 即为 Zig-Zag 顺序的线性索引。
    % 对于逆 Zig-Zag 扫描，注意到 ZigZag(iZigZag(vec)) = vec，令 vec = 1:(m*n)，则 ZigZag(iZigZag(vec)) = izzidx(zzidx) = 1:(m*n)，从而可以通过令 izzidx(zzidx) = 1:(m*n) 求出逆索引 izzidx。

clc; clear; close all;

A = reshape(1:64, 8, 8); % 创建一个 8x8 的矩阵
[zzidx, izzidx] = prezigzag(8, 8); % 获取 Zig-Zag 扫描的索引
disp("原始矩阵 A：");
disp(A);
disp("Zig-Zag 扫描后的序列：");
disp(A(zzidx)); % 按照 Zig-Zag 顺序输出矩阵元素
disp("从 Zig-Zag 序列还原的矩阵：");
disp(reshape(A(zzidx(izzidx)), 8, 8)); % 还原矩阵


function [zzidx, izzidx] = prezigzag(m, n)
    % 生成 m x n 矩阵的 Zig-Zag 扫描索引和逆索引
    %   [zzidx, izzidx] = prezigzag(m, n)
    %
    % 输入：
    %   m - 矩阵的行数
    %   n - 矩阵的列数
    %
    % 输出：
    %   zzidx  - Zig-Zag 扫描的线性索引
    %   izzidx - 逆 Zig-Zag 扫描的线性索引
    %
    % 示例：
    %   [zzidx, izzidx] = prezigzag(8, 8);
    %   A = reshape(1:64, 8, 8);
    %   zigzag_sequence = A(zzidx);
    %   restored_A = zigzag_sequence(izzidx);

    zzidx = zeros(1, m * n).';
    idx = 1;

    % 逐步遍历每一条对角线
    for sum_idx = 1 : m+n-1
        % 第奇数条对角线：从下往上扫描
        if mod(sum_idx, 2) == 1
            row = min(sum_idx, m); % 起始元素的行索引
            col = sum_idx - row + 1;
            while row > 0 && col <= n
                zzidx(idx) = (col - 1) * m + row;
                row = row - 1;
                col = col + 1;
                idx = idx + 1;
            end
        % 第偶数条对角线：从上往下扫描
        else
            col = min(sum_idx, n); % 起始元素的列索引
            row = sum_idx - col + 1;
            while col > 0 && row <= m
                zzidx(idx) = (col - 1) * m + row;
                row = row + 1;
                col = col - 1;
                idx = idx + 1;
            end
        end
    end
    izzidx = zeros(m, n);
    izzidx(zzidx) = 1 : (m * n);
end


%% ==========  ChatGPT 给出的向量化优化版本  ==========
% function [zzidx, izzidx] = prezigzag(m, n)
%     % 生成 m x n 矩阵的 Zig-Zag 扫描索引和逆索引
%     %   [zzidx, izzidx] = prezigzag(m, n)
%     %
%     % 输入：
%     %   m - 矩阵的行数
%     %   n - 矩阵的列数
%     %
%     % 输出：
%     %   zzidx  - Zig-Zag 扫描的线性索引
%     %   izzidx - 逆 Zig-Zag 扫描的线性索引
%     %
%     % 示例：
%     %   [zzidx, izzidx] = prezigzag(8, 8);
%     %   A = reshape(1:64, 8, 8);
%     %   zigzag_sequence = A(zzidx);
%     %   restored_A = zigzag_sequence(izzidx);
%     [I, J] = ndgrid(1:m, 1:n);      % 每个元素的行、列坐标矩阵
%     S = I + J;                      % 反对角线编号（同一条反对角线 i+j 相等）
%     K = I;                          % 同一反对角线里的“次序键”
%     evenMask = mod(S, 2) == 0;
%     K(evenMask) = -K(evenMask);     % 偶数和反向：用 -row 实现降序

%     % 先按反对角线 S 排，再按同线内的 K 排 → 得到 Zigzag 总顺序
%     [~, zzidx] = sortrows([S(:), K(:)]);

%     % 逆置换：使得 v(izzidx) = A(:)
%     izzidx = zeros(m, n);
%     izzidx(zzidx) = 1:(m*n);
% end
