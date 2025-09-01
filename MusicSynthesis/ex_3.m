% 请用最简单的方法将 ex_2 中的音乐分别升高和降低一个八度。（提示：音乐播放的时间可以变化）再难一些，请用 resample 函数（也可以用 interp 和 decimate 函数）将上述音乐升高半个音阶。（提示：视计算复杂度，不必特别精确）

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

% ----------  原始  ----------
melody = [];
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

% ----------  #8  -----------
melodyu8 = melody(1:2:end);
sound(melodyu8);
pause(length(melodyu8) / fs + 1);
audiowrite("attachments/ex_3_u8.wav", melodyu8, fs);

% ----------  b8  -----------
melodyd8 = repelem(melody, 2);
sound(melodyd8);
pause(length(melodyd8) / fs + 1);
audiowrite("attachments/ex_3_d8.wav", melodyd8, fs);

% ----------  #0.5  -----------
melodyu0_5 = resample(melody, round(1000 * (2^(1/12))), 1000);
sound(melodyu0_5);
pause(length(melodyu0_5) / fs + 1);
audiowrite("attachments/ex_3_u05.wav", melodyu0_5, fs);
