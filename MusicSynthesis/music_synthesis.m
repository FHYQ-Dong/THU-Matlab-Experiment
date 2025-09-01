% 从 attachments/fmt.wav 音频文件中获取吉他的频谱信息，并用这个频谱信息合成东方红。

clear; clc;

% --------- 初始化谱子 ---------
score = {'C4', 'C4', 'D4', 'G3', 'F3', 'F3', 'D3', 'G3'};
durations = [1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2];
load("attachments/note2freq.mat");

% --------- 读取音频文件 ---------
[x, fs] = audioread('attachments/fmt.wav');
x = x(:);

% --------- 分割节拍 ---------
[beat_edges, bpm] = segment_beats(x, fs);
fprintf('Estimated BPM : %.2f\n', bpm);
fprintf('%d Beats found\n', length(beat_edges) - 1);

% --------- 对每拍分析频谱 ---------
Nharm = 10; % 每拍分析的谐波数目
NBeats = length(beat_edges) - 1;
spectrum = repmat(struct('f0', [], 'Ak', [], 'Phik', []), 1, NBeats); % 预分配频谱结构体数组
for k = 1 : NBeats
    i0  = max(1, round(beat_edges(k) * fs) + 1);
    i1  = min(length(x), round(beat_edges(k + 1) * fs));
    seg = x(i0 : i1);
    [spectrum(k).f0, spectrum(k).Ak, spectrum(k).Phik] = analyze_beat_spectrum(seg, fs, Nharm);
end

% --------- 使用分析的频谱合成 ---------
[y_dongfanghong, fs_out] = synth_from_harmonics(score, durations, bpm, note2freq, spectrum, fs);
soundsc(y_dongfanghong, fs_out);
audiowrite('attachments/dongfanghong_synth.wav', y_dongfanghong, fs_out);


function [beat_edges, bpm] = segment_beats(y, fs)
    % SEGMENT_BEATS  自动分析音频信号的节拍
    %   [beat_edges, bpm] = segment_beats(y, fs)
    %
    % 输入：
    %   y  - 音频信号
    %   fs - 采样率
    %
    % 输出：
    %   beat_edges - 节拍边界时间点
    %   bpm        - 每分钟节拍数

    [c, lags] = xcorr(y.^2, 'coeff');
    c = c(lags >= 0);
    [~, peak_idx] = max(c(ceil(fs / 2) : end));
    point_per_note = (peak_idx + ceil(fs / 2) - 1);
    beat_edges = (0 : point_per_note : length(y) - 1) / fs;
    bpm = 60 / (point_per_note / fs);
end


function [f0, Ak, Phik] = analyze_beat_spectrum(x, fs, Nharm)
    % ANALYZE_BEAT_SPECTRUM  对一拍内的音频信号进行频谱分析
    %   out = analyze_beat_spectrum(x, fs, Nharm)
    %
    % 输入：
    %   x     - 一拍内的音频信号
    %   fs    - 采样率
    %   Nharm - 要分析的谐波数目
    %
    % 输出：
    %   f0   - 基频
    %   Ak   - 第 1..Nharm 个谐波的幅度
    %   Phik - 第 1..Nharm 个谐波的相位
    
    % 参数

    f0Min = 50;   % 最低基频
    f0Max = 1000; % 最高基频

    x = x(:);
    x = x - mean(x);
    x = x .* hann(length(x));
    
    % 基频 f0
    r = xcorr(x, 'coeff');
    mid = (length(r) + 1) / 2;
    r = r(mid : end);
    tauMin = max(2, floor(fs / f0Max));
    tauMax = ceil(fs / f0Min);
    [~, tau] = max(r(tauMin : tauMax));
    f0 = fs / (tau + tauMin - 1);
    
    % 时间整形：取出整数个周期，做周期平均+归一化，最后得到单个周期内的信号
    Lp = round(fs / f0);                % 每个周期的采样点数
    Np = max(1, floor(length(x) / Lp)); % 片段内的周期数
    [p, q] = rat(Np * Lp / length(x));
    x = resample(x, p, q);
    x = x(1 : Np*Lp);
    x = reshape(x, Lp, Np);
    x = mean(x, 2);
    x = x / max(abs(x));
    
    % 单周期内的傅里叶
    N = length(x);
    X = fft(x) / N;
    Kmax = min(Nharm, floor(N / 2) - 1); % 最大谐波数（需要保证小于 N/2）
    Ak   = zeros(Nharm, 1);
    Phik = zeros(Nharm, 1);
    for k = 1 : Kmax
        Ck = X(k + 1);
        Ak(k)   = 2 * abs(Ck);
        Phik(k) = angle(Ck);
    end
end
    

function [y, fs_out] = synth_from_harmonics(score, durations, bpm, note2freq, spectrum, fs)
    % SYNTH_FROM_HARMONICS  用已提取的谐波谱库(spectrum)按曲谱合成
    %   [y, fs_out] = synth_from_harmonics(score, durations, bpm, note2freq, spectrum, fs)
    %
    % 输入：
    %   score     - 长度为 N 的 cell，元素是音符名（如 'C4'）
    %   durations - N×1 或 1×N，时值；单位为拍
    %   note2freq - containers.Map(char -> double)，音符名到频率的映射
    %   spectrum  - 频谱（结构体数组），来自 analyze_beat_spectrum
    %   fs        - 采样率
    %
    % 输出：
    %   y      - 合成的音频信号
    %   fs_out - 输出的采样率（与输入 fs 相同）
    
    % 参数
    Tau        = 0.35; % 指数衰减时间常数
    
    % 将音符时值转换为秒
    Nnotes = length(score);
    durations = durations(:);
    dur_sec = durations * 60 / bpm;
    
    % 准备谱库
    all_f0 = arrayfun(@(s) s.f0, spectrum(:));
    valid  = isfinite(all_f0) & all_f0 > 0;
    f0_lib   = all_f0(valid);
    Ak_lib   = {spectrum(valid).Ak};
    Phik_lib = {spectrum(valid).Phik};
    
    % 预分配输出
    N_each  = max(1, round(dur_sec * fs));
    N_total = sum(N_each);
    y = zeros(N_total, 1);
    
    % 合成
    ptr = 1;
    for i = 1 : Nnotes
        note_i = score{i};
        N_i    = N_each(i);
        t_i    = (0 : N_i - 1).' / fs;
    
        % 休止符
        if isempty(note_i)
            y_i = zeros(N_i, 1);
        else
            % 找最接近的基频
            f_target = note2freq(note_i);
            [~, idx_min] = min(abs(f0_lib - f_target)); 
            Ak   = Ak_lib{idx_min}(:);
            Phik = Phik_lib{idx_min}(:);
            Kmax = numel(Ak);
            % 合成
            y_i = zeros(N_i, 1);
            for n = 1 : Kmax
                if Ak(n) == 0, continue; end
                y_i = y_i + Ak(n) * cos(2 * pi * n * f_target * t_i + Phik(n));
            end
            y_i = y_i .* exp(-t_i / Tau);
            y_i = y_i / max(abs(y_i));
        end
        % 写入输出
        y(ptr : ptr + N_i - 1) = y_i;
        ptr = ptr + N_i;
    end

    % 输出
    y = y / max(abs(y));
    fs_out = fs;
end
