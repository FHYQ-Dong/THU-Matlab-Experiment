% 试着在 ex_2 的音乐中增加一些谐波分量，听一听音乐是否更有“厚度”了？注意谐波分量的能量要小，否则掩盖住基音反而听不清音调了。（如果选择基波幅度为 1 ，二次谐波幅度 0.2 ，三次谐波幅度 0.3 ，听起来像不像象风琴？）

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

    % ----------  加入谐波  ----------
    note = sum(A * sin(2 * pi * freq * t) ...
         + 0.2 * A * sin(2 * pi * freq * t * 2) ...
         + 0.3 * A * sin(2 * pi * freq * t * 3), 1);

    % ----------  加入包络  ----------
    t1 = 0 : 1/fs : dur/5-1/fs;
    t2 = dur/5 : 1/fs : dur/5*2-1/fs;
    t3 = dur/5*2 : 1/fs : dur/10*7-1/fs;
    t4 = dur/10*7 : 1/fs : dur;
    env = [linspace(0, 1, length(t1)), linspace(1, 0.75, length(t2)), linspace(0.75, 0.75, length(t3)), linspace(0.75, 0, length(t4))];
    melody = [melody, note .* env];
end


sound(melody);
audiowrite("attachments/ex_4.wav", melody, fs);
