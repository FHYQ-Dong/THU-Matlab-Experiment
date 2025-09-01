% DC 预测误差的取值和 Category 值有何关系？如何利用预测误差计算出其 Category ？

clc; clear; close all;

cd = -2047;
cat = cd2cat(cd);
disp(cat);


function cat = cd2cat(cd)
    % 计算 DC 预测误差的 Category 值
    %   cat = cd2cat(cd)
    %
    % 输入：
    %   cd - DC 预测误差
    %
    % 输出：
    %   cat - Category 值

    if cd == 0 % 如果预测误差为 0
        cat = 0;
    else
        cat = floor(log2(abs(cd))) + 1;
    end
end
