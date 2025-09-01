% 如果认为差分编码是一个系统，请绘出这个系统的频率响应，说明它是一个____（低通、高通、带通、带阻）滤波器。DC 系数先进行差分编码再进行熵编码，说明 DC 系数的____频率分量更多。
% 答：高通；高

clc; clear; close all;

% y[n] = x[n] - x[n-1]
% H(z) = 1 - z^(-1)
b = [1, -1];
a = 1;
[H, f] = freqz(b, a, 1000);
figure;
subplot(2, 1, 1);
plot(f, abs(H));
ylabel('幅度');
xlabel('频率');
grid on;
title('频率响应幅度');
subplot(2, 1, 2);
plot(f, angle(H));
ylabel('相位');
title('频率响应相位');
xlabel('频率');
grid on;
saveas(gcf, 'attachments/ex_2_5.png');
