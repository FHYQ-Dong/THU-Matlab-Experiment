% 请根据《东方红》片断的简谱和“十二平均律”计算出该片断中各个乐音的频率，在 MATLAB 中生成幅度为 1 、抽样频率为 8kHz 的正弦信号表示这些乐音。请用 sound 函数播放每个乐音，听一听音调是否正确。最后用这一系列乐音信号拼出《东方红》片断，注意控制每个乐音持续的时间要符合节拍，用 sound 播放你合成的音乐，听起来感觉如何？

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
for i = 1 : length(score)
    freq = cellfun(@(x) note2freq(x), score{i}, 'UniformOutput', true)';
    dur = durations(i) * t_unit;
    t = 0:1/fs:dur;
    melody = [melody, sum(A * sin(2 * pi * freq * t), 1)];
end


sound(melody);
pause(length(melody) / fs + 1);
audiowrite("attachments/ex_1.wav", melody, fs);
