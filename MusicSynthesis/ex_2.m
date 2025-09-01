% 你一定注意到 ex_1 的乐曲中相邻乐音之间有“啪”的杂声，这是由于相位不连续产生了高频分量。这种噪声严重影响合成音乐的质量，丧失真实感。为了消除它，我们可以用包络修正每个乐音，以保证在乐音的邻接处信号幅度为零。此外建议用指数衰减的包络来表示

clc; clear; close all;


fs = 8000;    % 采样率
A = 1;        % 幅度
t_unit = 0.5; % 每拍时长（秒）
load("attachments/note2freq.mat"); % 加载音符频率表，为 containers.Map 类型


score = { ...
    {'C4'}, {'C4'}, {'D4'}, {'G3'}, {'F3'}, {'F3'}, {'D3'}, {'G3'}, ...
}; % 音符名
durations = [ ...
    1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2, ... 
]; % 时值


melody = []; % 总旋律
for i = 1:length(score)
    freq = cellfun(@(x) note2freq(x), score{i}, 'UniformOutput', true)';
    dur = durations(i) * t_unit;
    t = 0:1/fs:dur;
    note = sum(A * sin(2 * pi * freq * t), 1);

    % ----------  加入包络  ----------
    t1 = 0 : 1/fs : dur/5-1/fs;
    t2 = dur/5 : 1/fs : dur/5*2-1/fs;
    t3 = dur/5*2 : 1/fs : dur/10*7-1/fs;
    t4 = dur/10*7 : 1/fs : dur;
    env = [linspace(0, 1, length(t1)), linspace(1, 0.75, length(t2)), linspace(0.75, 0.75, length(t3)), linspace(0.75, 0, length(t4))];
    melody = [melody, note .* env];
end


sound(melody);
pause(length(melody) / fs + 1);
audiowrite("attachments/ex_2.wav", melody, fs);
