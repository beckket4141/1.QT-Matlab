% 假设您已经得到了 r 和 phi
% r 是模长，phi 是相位

% 将负相位加上 2π 使其在 [0, 2π] 范围内
phi_adjusted = mod(phi, 2*pi); % 使用 mod 函数确保相位在 0 到 2pi 之间

% 绘制振幅图（模长）
figure;
bar(r); % 使用条形图显示振幅
title('模长（振幅图）');
xlabel('系数 c_i');
ylabel('模长 r');
set(gca, 'XTickLabel', {'c1', 'c2', 'c3', 'c4'}); % 设置 x 轴标签

% 绘制相位图（相位图，范围调整为 0 到 2π）
figure;
bar(phi_adjusted); % 使用条形图显示调整后的相位
title('相位图');
xlabel('系数 c_i');
ylabel('相位 φ（单位: π）');

% 固定 y 轴的范围为 [0, 2π]
ylim([0, 2*pi]);

% 设置 y 轴的刻度为 0 到 2π，并用 π 表示
yticks([0, pi/2, pi, 3*pi/2, 2*pi]);
yticklabels({'0', '1/2π', 'π', '3/2π', '2π'});

set(gca, 'XTickLabel', {'c1', 'c2', 'c3', 'c4'}); % 设置 x 轴标签
