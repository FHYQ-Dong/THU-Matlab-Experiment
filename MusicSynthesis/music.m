% music_synthesis.m
% 音乐合成完整作业：《东方红》简谱（F调）

clc; clear;

% ---------- 参数设置 ----------
fs = 8000;             % 采样率
HA = exp(-1 * [0:4])'; % 谐波振幅向量
t_unit = 0.5;          % 每拍时间（秒）

note2freq = containers.Map(...
    {'', '-1',    '-2',    '-3',    '-4',    '-5',    '-6',    '-7',    '1',     '2',     '3',     '4',     '5',     '6',     '7',     '+1',    '+2',    '+3',    '+4',    '+5',     '+6',     '+7'}, ...
    [0, 174.615, 196.000, 220.000, 233.080, 261.630, 293.660, 329.630, 349.230, 392.000, 440.000, 466.160, 523.260, 587.320, 659.260, 698.460, 784.000, 880.000, 932.320, 1046.520, 1174.640, 1318.520] ...
);

% ---------- 东方红简谱 ----------
score = { ...
    '5', '5', '6', '2', '1', '1', '-6', '2', ...
    '5', '5', '6', '+1', '6', '5', '1', '1', '-6', '2' ...
}; 
durations = [ ...
    1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2, ... 
    1, 1, 0.5, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 2 ...
];

% ---------- 音符频率转换 ----------
freqs = cellfun(@(x) note2freq(x), score, 'UniformOutput', true);

% ---------- 生成音乐波形 ----------
melody = zeros(1, round(sum(durations) * t_unit * fs));
curIdx = 1;
for i = 1:length(freqs)
    freq = freqs(i);
    dur = durations(i) * t_unit;
    if freq == 0
        continue;  % 跳过休止符
    end
    t = 0:1/fs:dur;
    melody(curIdx:curIdx + length(t) - 1) = melody(curIdx:curIdx + length(t) - 1) + genHarmonic(freq, dur, fs, HA);
    if i == length(freqs)
        curIdx = curIdx + length(t) - 1;
    else
        curIdx = curIdx + round(length(t)/6*5);
    end
end
melody = melody(1:curIdx);

% ---------- 播放合成的音乐 ----------
sound(melody, fs);


function hnote = genHarmonic(baseFreq, dur, fs, HA)
    % ----------  生成含谐波的音符 ----------
    % :param baseFreq: 基频
    % :param dur: 音符持续时间（秒）
    % :param fs: 采样率
    % :param HA: 谐波振幅向量
    % :return: 含谐波的音符波形
    t = 0:1/fs:dur;
    freqs = baseFreq * (1:length(HA))';
    waves = HA .* sin(2 * pi * freqs * t);
    hnote = sum(waves, 1);
    % 包络
    t1 = 0:1/fs:dur/5-1/fs;
    t2 = dur/5:1/fs:dur/5*2-1/fs;
    t3 = dur/5*2:1/fs:dur/10*7-1/fs;
    t4 = dur/10*7:1/fs:dur;
    env = [linspace(0, 1, length(t1)), linspace(1, 0.75, length(t2)), linspace(0.75, 0.75, length(t3)), linspace(0.75, 0, length(t4))];
    hnote = hnote .* env;
end
