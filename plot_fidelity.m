clc;
clear;

% 通过文件选择对话框选择要绘制的 Excel 文件
[file, path] = uigetfile({'*.xlsx;*.xls', 'Excel 文件 (*.xlsx, *.xls)'}, '选择要绘制的 Excel 文件');
if isequal(file, 0)
    disp('已取消文件选择，程序结束。');
    return;
end
file_name = fullfile(path, file);

% 读取 Excel 文件中的数据
data = readmatrix(file_name);

% 获取数据的行列数
[nRows, nCols] = size(data);

% 根据行列数确定 Bell 态的维度
dim = nRows;  % 假设维度是行数（可以根据实际需求调整）

% 创建一个图形窗口，动态调整图形大小
figurePosition = [100, 100, 600 + 20 * nCols, 500 + 20 * nRows];  % 根据行列数调整图形大小
figure('Position', figurePosition);

% 使用 imagesc 绘制热图
imagesc(data);

% 自定义颜色映射：从深绿色到黄色再到亮红色的渐变
nColors = 100;
deepGreen = [0, 0.5, 0]; % 深绿色
yellow = [1, 1, 0];      % 黄色
brightRed = [1, 0, 0];   % 亮红色

% 创建从深绿色到黄色再到亮红色的渐变
customCmap = [linspace(deepGreen(1), yellow(1), nColors/2)', linspace(deepGreen(2), yellow(2), nColors/2)', linspace(deepGreen(3), yellow(3), nColors/2)'; ...
              linspace(yellow(1), brightRed(1), nColors/2)', linspace(yellow(2), brightRed(2), nColors/2)', linspace(yellow(3), brightRed(3), nColors/2)'];
colormap(customCmap);
colorbar;

% 自定义颜色条范围
caxis([0, 1]);

% 根据维度动态创建标签
labels = cell(1, nCols);
for i = 1:nCols
    labels{i} = sprintf('\\psi_{%d}', i-1);  % 生成像 ψ_0, ψ_1, ... 的标签
end

% 添加行列标签
set(gca, 'XTick', 1:nCols, 'XTickLabel', labels, 'TickLength', [0 0]);
set(gca, 'YTick', 1:nRows, 'YTickLabel', labels, 'TickLength', [0 0]);

% 设置坐标轴和标题
xlabel('Experiment', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Ideal', 'FontSize', 12, 'FontWeight', 'bold');
title(sprintf('Fidelity Matrix (%dD Bell States)-量子-2mW-10s', dim), 'FontSize', 14, 'FontWeight', 'bold');

% 绘制单元格边框
hold on;
for i = 1:nRows + 1
    plot([0.5, nCols + 0.5], [i - 0.5, i - 0.5], 'k-', 'LineWidth', 2); % 水平线
end
for j = 1:nCols + 1
    plot([j - 0.5, j - 0.5], [0.5, nRows + 0.5], 'k-', 'LineWidth', 2); % 垂直线
end

% 计算动态字体大小，使其适应单元格大小
fontSize = max(8, min(12, 100 / nRows));  % 根据行数调整字体大小，最大值为12，最小值为8

% 添加自定义文本标签，以百分比形式显示
for i = 1:nRows
    for j = 1:nCols
        textStr = sprintf('%.1f%%', data(i, j) * 100); % 转换为百分比并添加百分号
        text(j, i, textStr, 'HorizontalAlignment', 'center', 'Color', 'k', 'FontSize', fontSize, 'FontWeight', 'bold');
    end
end

hold off;
