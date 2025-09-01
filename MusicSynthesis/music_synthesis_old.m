% 用（7）计算出来的傅里叶级数再次完成第（4） 题，听一听是否像演奏 attachments/fmt.wav 的吉他演奏出来的？

clc; clear; close all;

% --------- 计算频谱 ---------
notes_harmonic = containers.Map('KeyType', 'double', 'ValueType', 'any');
[y, fs] = audioread("attachments/fmt.wav");
y = y - mean(y);
y = y / max(abs(y));
N = length(y);

% 节拍
point_per_note = segment_beats(y, fs);
for idx = 1: floor(N / point_per_note)
    note_idx = (1: point_per_note)' + (ones(point_per_note, 1) .* (idx - 1));
    y_note = y(note_idx);
    Y_note = fft(y_note);
    f_note = (0: point_per_note - 1)' * (fs / point_per_note);
    [~, max_idx] = max(abs(Y_note(round(point_per_note / 5): round(4 * point_per_note / 5))));
    f0_note = fs / (point_per_note / max_idx);
    disp(['第', num2str(idx), '个音符基频：', num2str(f0_note), ' Hz']);
end

function point_per_note = segment_beats(y, fs)
    % 计算每拍的采样点数
    [c, lags] = xcorr(y.^2, 'coeff');
    c = c(lags >= 0);
    [~, peak_idx] = max(c(ceil(fs / 2): end));
    point_per_note = (peak_idx + ceil(fs / 2) - 1);
end
