function phase = mapmap_copy(rho, dimension, mode, folderPath, file_prefix, bases)
    % mapmap - 绘制密度矩阵的振幅和相位图，并使用标准化的基态标记
    %
    % 输入:
    %   rho - 密度矩阵
    %   dimension - 量子系统维度
    %   folderPath - 图像保存路径
    %   file_prefix - 文件名前缀（可选，默认为时间戳）
    %   bases - 基态向量元胞数组（可选，用于标签标记）
    
    % 检查输入维度是否有效
    if dimension < 2 || mod(dimension, 1) ~= 0
        error('请输入有效的维度（必须为大于等于2的整数）。');
    end
    
    % 解析可选参数（与UI兼容）
    % mode: 'amplitude' 或 'phase'；若未提供则绘制并保存两张图（兼容旧用法）
    if nargin < 3 || isempty(mode)
        mode = 'both';
    end
    if nargin < 4
        folderPath = [];
    end
    if nargin < 5 || isempty(file_prefix)
        file_prefix = datestr(now, 'yyyymmdd_HHMMSS');
    end
    
    % 创建轴标签：若 dimension 为完全平方数，使用 a=b=sqrt(n) 的二元编号，否则单索引
    labels = cell(1, dimension);
    rootN = sqrt(dimension);
    if abs(rootN - round(rootN)) < 1e-12
        a_dim = round(rootN); b_dim = round(rootN);
        for k = 1:dimension
            p = floor((k-1)/b_dim);
            q = mod((k-1), b_dim);
            labels{k} = sprintf('|%d%d>', p, q);
        end
    else
        for i = 1:dimension
            labels{i} = sprintf('|%02d>', i-1);
        end
    end
    
    % 1. 绘制实部信息（当 mode 为 'amplitude' 或 'both' 时）
    amplitude_matrix = real(rho);
    if any(strcmp(mode, {'amplitude','both'}))
        bar3(amplitude_matrix);
        set(gca, 'XTick', 1:dimension, 'YTick', 1:dimension);
        set(gca, 'XTickLabel', labels, 'YTickLabel', labels);
        set(gca, 'XTickLabelRotation', 45);
        set(gca, 'FontSize', 10); % 略微放大态坐标字体
        title(['密度矩阵实部 - ', num2str(dimension), ' 维量子系统']);
        xlabel('基态'); ylabel('基态'); zlabel('实部');
        zlim([0 0.5]);
        set(gca, 'ZTick', 0:0.1:0.5);
        if ~isempty(folderPath)
            set(gcf, 'Position', [100, 100, 800, 600]);
            amplitudeFile = fullfile(folderPath, [file_prefix, '_Real.png']);
            saveas(gcf, amplitudeFile);
        end
    end
    
    % 2. 提取虚部并添加阈值判断
    imag_matrix = zeros(size(rho));
    threshold = 1e-4; % 阈值
    for i = 1:size(rho, 1)
        for j = 1:size(rho, 2)
            if abs(rho(i, j)) > threshold
                imag_matrix(i, j) = imag(rho(i, j));
            else
                imag_matrix(i, j) = 0;  % 振幅太小的元素虚部设为0
            end
        end
    end
    
    % 3. 绘制虚部信息（当 mode 为 'phase' 或 'both' 时）
    if any(strcmp(mode, {'phase','both'}))
        bar3(imag_matrix);
        set(gca, 'XTick', 1:dimension, 'YTick', 1:dimension);
        set(gca, 'XTickLabel', labels, 'YTickLabel', labels);
        set(gca, 'XTickLabelRotation', 45);
        set(gca, 'FontSize', 10); % 略微放大态坐标字体
        title(['密度矩阵虚部 - ', num2str(dimension), ' 维量子系统']);
        xlabel('基态'); ylabel('基态'); zlabel('虚部');
        zlim([0 0.5]);
        set(gca, 'ZTick', 0:0.1:0.5);
        if ~isempty(folderPath)
            set(gcf, 'Position', [100, 100, 800, 600]);
            phaseFile = fullfile(folderPath, [file_prefix, '_Imag.png']);
            saveas(gcf, phaseFile);
        end
    end
    
    % 如果需要，可以保存为其他格式
    % print(gcf, fullfile(folderPath, [file_prefix, '_Phase.pdf']), '-dpdf', '-r300');
    
    % 返回虚部矩阵（为兼容旧接口，变量名仍为 phase）
    phase = imag_matrix;
    
    % 若提供保存路径，输出保存信息
    if exist('amplitudeFile','var') || exist('phaseFile','var')
        fprintf('图像已保存：\n');
        if exist('amplitudeFile','var'); fprintf('  振幅图：%s\n', amplitudeFile); end
        if exist('phaseFile','var'); fprintf('  相位图：%s\n', phaseFile); end
    end
end
