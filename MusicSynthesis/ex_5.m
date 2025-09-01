% 自选其它音乐合成，例如贝多芬第五交响乐的开头两小节。

clc; clear; close all;


fs = 8000;    % 采样率
A = 1;        % 幅度
t_unit = 0.5; % 每拍时长（秒）
load("attachments/note2freq.mat"); % 加载音符频率表，为 containers.Map 类型


score = { ...
    {''}, {'G3', 'G4'}, {'G3', 'G4'}, {'G3', 'G4'}, {'D3#', 'D4#'}, {''}, {'F3', 'F4'}, {'F3', 'F4'}, {'F3', 'F4'}, {'D3', 'D4'}
}; % 音符名
durations = [ ...
    0.5, 0.5, 0.5, 0.5, 14, 0.5, 0.5, 0.5, 0.5, 14
]; % 时值

melody = []; % 总旋律
for i = 1:length(score)
    freq = cellfun(@(x) note2freq(x), score{i}, 'UniformOutput', true)';
    dur = durations(i) * t_unit;
    t = 0:1/fs:dur;

    % ----------  加入谐波  ----------
    note = A * sin(2 * pi * freq * t) ...
         + 0.2 * A * sin(2 * pi * freq * t * 2) ...
         + 0.3 * A * sin(2 * pi * freq * t * 3);
    note = sum(note, 1);

    % ----------  加入包络  ----------
    t1 = 0 : 1/fs : dur/5-1/fs;
    t2 = dur/5 : 1/fs : dur/5*2-1/fs;
    t3 = dur/5*2 : 1/fs : dur/10*7-1/fs;
    t4 = dur/10*7 : 1/fs : dur;
    env = [linspace(0, 1, length(t1)), linspace(1, 0.75, length(t2)), linspace(0.75, 0.75, length(t3)), linspace(0.75, 0, length(t4))];
    melody = [melody, note .* env];
end


sound(melody);
audiowrite("attachments/ex_5.wav", melody, fs);