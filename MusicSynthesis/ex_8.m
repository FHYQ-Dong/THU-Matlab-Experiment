% 这段音乐的基频是多少？是哪个音调？请用傅里叶级数或者变换的方法分析它的谐波分量分别是什么。提示：简单的方法是近似取出一个周期求傅里叶级数但这样明显不准确，因为你应该已经发现基音周期不是整数（这里不允许使用 resample 函数）。复杂些的方法是对整个信号求傅里叶变换（回忆周期性信号的傅里叶变换），但你可能发现无论你如何提高频域的分辨率，也得不到精确的包络（应该近似于冲激函数而不是 sinc 函数），可选的方法是增加时域的数据量，即再把时域信号重复若干次，看看这样是否效果好多了？请解释之。

clc; clear; close all;

[y, fs] = audioread("attachments/fmt.wav");
load("attachments/note2freq.mat");
y = y(:);
y = y - mean(y); 
y = y / max(abs(y)); 
y = repmat(y, 10, 1)';

% ----------  FFT  ----------
N = length(y);
Y = fft(y);
f = (0: N - 1) * (fs / N);

% ----------  基频  ----------
[~, idx] = max(abs(Y(1 : round(N / 2))));
f0 = f(idx);
disp(['基频：', num2str(f0), ' Hz']);
figure;
plot(f(1 : round(N/2)), abs(Y(1 : round(N/2))));
title('频谱');
xlabel('频率 (Hz)');
ylabel('幅度');
saveas(gcf, "attachments/ex_8.png");

% ----------  判断音调  ----------
notes = {'A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'};
A4 = 440; 
n = round(12 * log2(f0 / A4));
note_name = notes{mod(n, 12) + 1};
octave = 4 + floor((n + 9) / 12);
disp(['音调：', note_name, num2str(octave)]);
