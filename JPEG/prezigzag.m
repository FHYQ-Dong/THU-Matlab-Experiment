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
    %
    % 备注：
    %   从 ex_2_7.m 中复制而来，以备后续调用
    %   是 ChatGPT 给出的向量化版本

    [I, J] = ndgrid(1:m, 1:n);      % 每个元素的行、列坐标矩阵
    S = I + J;                      % 反对角线编号（同一条反对角线 i+j 相等）
    K = I;                          % 同一反对角线里的“次序键”
    evenMask = mod(S, 2) == 0;
    K(evenMask) = -K(evenMask);     % 偶数和反向：用 -row 实现降序

    % 先按反对角线 S 排，再按同线内的 K 排 → 得到 Zigzag 总顺序
    [~, zzidx] = sortrows([S(:), K(:)]);

    % 逆置换：使得 v(izzidx) = A(:)
    izzidx = zeros(m, n);
    izzidx(zzidx) = 1:(m*n);
end