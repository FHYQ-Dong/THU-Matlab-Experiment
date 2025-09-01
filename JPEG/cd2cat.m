function cat = cd2cat(cd)
    % 计算 DC 预测误差的 Category 值
    %   cat = cd2cat(cd)
    %
    % 输入：
    %   cd - DC 预测误差
    %
    % 输出：
    %   cat - Category 值
    %
    % 示例：
    %   cat = cd2cat(-2047);
    %   disp(cat); % 输出：11
    %
    % 备注：
    %   从 ex_2_6.m 中复制而来，以备后续调用
    %   添加了向量化适配

    mask = (cd == 0);
    cat = zeros(size(cd));
    cat(mask) = 0;
    cat(~mask) = floor(log2(abs(cd(~mask)))) + 1;
end
