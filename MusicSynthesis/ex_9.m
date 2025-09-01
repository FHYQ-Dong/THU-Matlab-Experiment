% 再次载入 attachments/fmt.wav ，现在要求你写一段程序，自动分析出这段乐曲的音调和节拍！

clc; clear; close all;

[y, fs] = audioread("attachments/fmt.wav");
y = y(:);
y = y - mean(y);
y = y / max(abs(y));

% --------- 基频 ---------
N = length(y);
Y = fft(y);
f = (0: N - 1) * (fs / N);
[~, idx] = max(abs(Y(1: round(N / 2))));
f0 =  f(idx);
% 判断音调
notes = {'A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#'};
A4 = 440;
n = round(12 * log2(f0 / A4));
note_name = notes{mod(n, 12) + 1};
octave = 4 + floor((n + 9) / 12);

fprintf('音调：%s%d，%.2f Hz\n', note_name, octave, f0);

% --------- 通过自相关函数的峰值确定节拍  ---------
% 取自相关函数最大值对应的延迟（排除0延迟附近）
[c, lags] = xcorr(y .^2, 'coeff');
c = c(lags >= 0);
lags = lags(lags >= 0);
[~, peak_idx] = max(c(ceil(fs / 2): end)); % 避免0延迟
period = (peak_idx + ceil(fs / 2) - 1) / fs;
bpm = 60 / period;
fprintf('节拍周期：%.2f 秒，%.2f BPM\n', period, bpm);
