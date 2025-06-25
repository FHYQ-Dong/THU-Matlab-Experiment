% music_synthesis.m
% 音乐合成完整作业：《东方红》简谱（F调）

clc; clear;

% ---------- 参数设置 ----------
fs = 8000;           % 采样率
A = 1;               % 音量
t_unit = 0.5;        % 每拍时间（秒）

note2freq = containers.Map(...
    {'-1',    '-2',    '-3',    '-4',    '-5',    '-6',    '-7',    '1',     '2',     '3',     '4',     '5',     '6',     '7',     '+1',    '+2',    '+3',    '+4',    '+5',     '+6',     '+7'}, ...
    [174.615, 196.000, 220.000, 233.080, 261.630, 293.660, 329.630, 349.230, 392.000, 440.000, 466.160, 523.260, 587.320, 659.260, 698.460, 784.000, 880.000, 932.320, 1046.520, 1174.640, 1318.520] ...
);

subs(xxx,xxx,xxx,xxx)
% ---------- 东方红简谱 ----------
% 简谱音名（带连音用 {} 处理）
score = {'5','6','2','','1','1','6','2'}; 
durations = [1 1 1 1 1 1 1 1];  % 每拍时长

% ---------- 合成原始旋律 ----------
melody = [];
for i = 1:length(score)
    dur = durations(i) * t_unit;
    if score{i} == ""
        y = zeros(1, floor(fs*dur));
    else
        noteName = noteMap(score{i});
        freq = noteFreqs(noteName);
        y = genNote(freq, dur, fs, A);
    end
    melody = [melody, y];
end

% 画出波形图
figure;
plot((1:length(melody))/fs, melody);
title('合成旋律波形图');
xlabel('时间 (秒)');
ylabel('振幅');

% 播放原始合成
fprintf("播放原始旋律...\n");
sound(melody, fs);
pause(length(melody)/fs + 1);

% ---------- 加入谐波 ----------
melody_harm = [];
for i = 1:length(score)
    dur = durations(i) * t_unit;
    if score{i} == ""
        y = zeros(1, floor(fs*dur));
    else
        noteName = noteMap(score{i});
        freq = noteFreqs(noteName);
        y = genHarmonic(freq, dur, fs, A);
    end
    melody_harm = [melody_harm, y];
end

fprintf("播放含谐波旋律...\n");
sound(melody_harm, fs);
pause(length(melody_harm)/fs + 1);

% ---------- 函数定义 ----------
function y = genNote(freq, duration, fs, A)
    t = 0:1/fs:duration;
    y = A * sin(2*pi*freq*t);
    env = linspace(1, 0, length(y)); % 包络线平滑末尾
    y = y .* env;
end

function y = genHarmonic(freq, duration, fs, A)
    t = 0:1/fs:duration;
    y = A*sin(2*pi*freq*t) + 0.3*sin(2*pi*2*freq*t) + 0.2*sin(2*pi*3*freq*t);
    env = linspace(1, 0, length(y)); % 同样加包络
    y = y .* env;
end
