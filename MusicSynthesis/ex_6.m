% 先用 wavread 函数载入 attachment/fmt.wav 文件，播放出来听听效果如何？是否比刚才的合成音乐真实多了？

clc; clear; close all;

[y, fs] = audioread("attachments/fmt.wav");
sound(y, fs);
pause(length(y) / fs + 1);
