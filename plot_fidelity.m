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

% 选择是否使用最大余数法
useLRM = questdlg('是否使用最大余数法使每行显示之和=100%？', ...
                  '显示方式选择', '使用', '不使用', '使用');
if strcmp(useLRM, '使用')
    % 先按显示精度（0.1%）进行四舍五入分配，再保证每行之和为 100%
    % ========== 最大余数法（Largest Remainder Method）说明 ==========
    % 目标：将原始概率 data 的每一行，按“显示一位小数的百分数”（0.1%）量化后，
    %      保证该行显示出来的百分比之和严格等于 100.0%。
    % 做法：
    %  1) 将每个单元按 0.1% 的最小刻度换算成连续刻度：rawTenths = data * 1000。
    %  2) 取地板 baseAlloc = floor(rawTenths)，得到不超标的整数刻度初分配。
    %  3) 记录每个单元的小数余量 remainder，并计算需补齐刻度数 need = 1000 - sum(baseAlloc)。
    %  4) 若 need>0，则按余量从大到小为前 need 个单元各+1（最接近下一刻度者优先补齐）。
    %     若 need<0（极少见），按余量从小到大各-1作保护处理。
    %  5) 如此得到的整数刻度 displayedTenths 每行之和恰为 1000 个 0.1%（即 100.0%）。
    % ==============================================================
    displayedTenths = zeros(nRows, nCols); % 以 0.1% 为单位的整数矩阵
    for i = 1:nRows
        rawTenths = data(i, :) * 1000;                % 连续值（单位：0.1%）
        baseAlloc = floor(rawTenths);                 % 第一步：地板分配
        remainder = rawTenths - baseAlloc;            % 第二步：记录余量
        need = 1000 - sum(baseAlloc);                 % 第三步：该行需补齐的 0.1% 个数
        if need > 0
            % 第四步：按余量从大到小补齐（最大余数法核心）
            [~, idx] = sort(remainder, 'descend');
            baseAlloc(idx(1:need)) = baseAlloc(idx(1:need)) + 1;
        elseif need < 0
            % 罕见保护：若超配则按余量从小到大回退
            [~, idx] = sort(remainder, 'ascend');
            baseAlloc(idx(1:(-need))) = baseAlloc(idx(1:(-need))) - 1;
        end
        displayedTenths(i, :) = baseAlloc;            % 第五步：本行最终刻度整数
    end
    % 用于绘图与文本显示的值（均来自最大余数法后的整数刻度）
    displayData = displayedTenths / 1000;  % 概率（行和=1），用于 imagesc
    displayPercent = displayedTenths / 10; % 百分数（行和=100），用于单元格文本
else
    % 不使用最大余数法：直接使用原始数据
    % 注意：此时每行在显示时四舍五入到1位小数后，行和可能不是100.0%
    displayData = data;             % 用于 imagesc 的原始概率
    displayPercent = data * 100;    % 用于文本显示的百分数
end

% 根据行列数确定 Bell 态的维度
dim = nRows;  % 假设维度是行数（可以根据实际需求调整）

% 让用户输入图像标题（可留空表示无标题）
defaultTitle = '';
answer = inputdlg({'输入图像标题（可留空）：'}, '设置标题', 1, {defaultTitle});
if isempty(answer)
    userTitle = '';
else
    userTitle = strtrim(answer{1});
end

% 创建一个图形窗口，动态调整图形大小
figurePosition = [100, 100, 600 + 20 * nCols, 500 + 20 * nRows];  % 根据行列数调整图形大小
figure('Position', figurePosition);

% 使用 imagesc 绘制热图（使用“先四舍五入后归一化”的显示数据）
imagesc(displayData);

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

% 询问并校验 l_dim 与 p_dim（满足 l_dim * p_dim = nCols）
defaultDims = {num2str(nCols), '1'};
ansDims = inputdlg({'输入 l 维度 l_dim：', '输入 p 维度 p_dim：'}, '设置维度(l×p=n)', 1, defaultDims);
if isempty(ansDims)
    l_dim = nCols;
    p_dim = 1;
else
    l_dim = str2double(strtrim(ansDims{1}));
    p_dim = str2double(strtrim(ansDims{2}));
    if isnan(l_dim) || isnan(p_dim) || l_dim <= 0 || p_dim <= 0 || l_dim * p_dim ~= nCols
        warning('维度输入无效，已回退为 l_dim=%d, p_dim=%d（l×p 必须等于 nCols=%d）。', nCols, 1, nCols);
        l_dim = nCols; p_dim = 1;
    end
end

% 依据 generateOAMIndex 的编号顺序（先 p 后 l）创建二维编号标签 ψ_{p l}
labels = cell(1, nCols);
for k = 1:nCols
    p_idx = floor((k - 1) / l_dim);  % 0..p_dim-1
    l_idx = mod((k - 1), l_dim);     % 0..l_dim-1
    labels{k} = sprintf('\\psi_{%d%d}', p_idx, l_idx);
end

% 添加行列标签
set(gca, 'XTick', 1:nCols, 'XTickLabel', labels, 'TickLength', [0 0]);
set(gca, 'YTick', 1:nRows, 'YTickLabel', labels, 'TickLength', [0 0]);

% 设置坐标轴和标题（不显示坐标轴文字标签）
xlabel('');
ylabel('');
if ~isempty(userTitle)
    title(userTitle, 'FontSize', 14, 'FontWeight', 'bold');
else
    title('');
end

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
        % 直接使用分配后的 0.1% 单位整数，确保行和恰为 100.0%
        textStr = sprintf('%.1f%%', displayPercent(i, j));
        text(j, i, textStr, 'HorizontalAlignment', 'center', 'Color', 'k', 'FontSize', fontSize, 'FontWeight', 'bold');
    end
end

hold off;
