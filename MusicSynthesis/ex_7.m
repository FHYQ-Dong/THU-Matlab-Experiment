% 你知道待处理的 wave2proc 是如何从真实值 realwave 中得到的么？这个预处理过程可以去除真实乐曲中的非线性谐波和噪声，对于正确分析音调是非常重要的。提示：从时域做，可以继续使用 resample 函数。

clc; clear; close all;

load("attachments/Guitar.MAT")
fs = 8000;

filtered = realwave - mean(realwave);
[b, a] = butter(8, [50, 3000] / (fs/2), 'bandpass');
filtered = filtfilt(b, a, filtered);
filtered = resample(filtered, 6000, fs);
filtered = resample(filtered, 8000, 6000);

% ---------- 对比 ----------
figure;
subplot(3, 1, 1);
plot(realwave);
title("realwave");
subplot(3, 1, 2);
plot(filtered);
title("filtered");
subplot(3, 1, 3);
plot(wave2proc);
title("wave2proc");
saveas(gcf, "attachments/ex_7.png");
