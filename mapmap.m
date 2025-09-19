function phase = mapmap(rho, dimension, folderPath, l_dim, p_dim)
    % mapmap - 可视化密度矩阵的实部与虚部信息（坐标轴与标签对齐 mapmap_copy）
    % 输入:
    %   rho - 密度矩阵
    %   dimension - 系统维度
    %   folderPath - (可选) 图形保存文件夹路径
    %   l_dim - (可选) 轨道角动量l的维度
    %   p_dim - (可选) 径向量子数p的维度
    % 输出:
    %   phase - 相位矩阵信息
    
    % 检查输入维度是否有效
    if dimension < 2 || mod(dimension, 1) ~= 0
        error('请输入有效的维度（必须为大于等于2的整数）。');
    end

    % 检查是否提供了folderPath参数
    save_figures = nargin >= 3 && ~isempty(folderPath);
    
    % 生成标签（优先使用传入的 l_dim 与 p_dim；否则采用 mapmap_copy 的策略）
    xticks = cell(1, dimension);
    yticks = cell(1, dimension);
    use_pair = (nargin >= 5) && ~isempty(l_dim) && ~isempty(p_dim) && l_dim > 0 && p_dim > 0 && l_dim * p_dim == dimension;
    if use_pair
        b_dim = p_dim; % 列内步长
        for k = 1:dimension
            p = floor((k-1)/b_dim); % 0..l_dim-1
            q = mod((k-1), b_dim);  % 0..p_dim-1
            lab = ['|', num2str(p), num2str(q), '>'];
            xticks{k} = lab; yticks{k} = lab;
        end
    else
        rootN = sqrt(dimension);
        if abs(rootN - round(rootN)) < 1e-12
            a_dim = round(rootN); b_dim = round(rootN);
            for k = 1:dimension
                p = floor((k-1)/b_dim); q = mod((k-1), b_dim);
                lab = ['|', num2str(p), num2str(q), '>'];
                xticks{k} = lab; yticks{k} = lab;
            end
        else
            for i = 1:dimension
                lab = ['|', sprintf('%02d', i-1), '>'];
                xticks{i} = lab; yticks{i} = lab;
            end
        end
    end
    
    % 创建时间戳（将时间戳放在最前面）
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    
    % 设置字体大小
    font_size = 16;  % 增大字体大小

    
    
    % 1. 绘制实部信息
    real_matrix = real(rho);
    figure('Name', '');
    h = bar3(real_matrix);
    
    % 强制设置X轴和Y轴的刻度位置和标签
    ax = gca;
    % 设置刻度位置
    ax.XTick = 1:dimension;
    ax.YTick = 1:dimension;
    % 设置刻度标签
    ax.XTickLabel = xticks;
    ax.YTickLabel = yticks;
    
    zlim([0 0.5]);
    ax.ZTick = 0:0.1:0.5;

    % 紧凑显示设置
    set(gcf, 'Position', [100, 100, 900, 700]);
    set(gca, 'LooseInset', get(gca, 'TightInset')*0.8);
    set(gca, 'Position', [0.08 0.08 0.88 0.88]);
    axis tight;
    pbaspect([1 1 0.8]);
    
    % 设置字体大小
    ax.FontSize = font_size;
    
    % 修改标题样式，参考map.m
    title(['密度矩阵实部 - ', num2str(dimension), ' 维量子系统'], 'FontSize', font_size+4);

    % 调整图形大小和减少边缘空白
    set(gcf, 'Position', [100, 100, 900, 700]);  % 设置图形窗口大小
    set(gca, 'LooseInset', get(gca, 'TightInset'));  % 调整边缘，与map.m保持一致
    
    % 调整坐标轴边界和布局，使其更加对称
    axis tight;  % 使坐标轴紧贴数据
    pbaspect([1 1 0.8]);  % 设置长宽高比例
    box on;  % 显示坐标轴盒子
    grid on;  % 显示网格
    
    % 减少左侧空白，使坐标轴两端对称
    pos = get(gca, 'Position');
    pos(1) = 0.1;  % 减少左侧空白
    pos(3) = 0.85;   % 调整宽度
    set(gca, 'Position', pos);
    
    % 设置柱状图颜色并移除colorbar
    for i = 1:length(h)
        zdata = get(h(i),'ZData');
        set(h(i),'CData',zdata,'FaceColor','interp');
    end
    
    % 调整标签编码和显示，使用默认字体
    set(gca, 'FontName', 'default');
    
    % 设置观察角度
    view(30, 30);

    % 如果提供了folderPath，则保存振幅图像
    if save_figures
        amplitudeFile = fullfile(folderPath, [timestamp, '_Real.png']);
        saveas(gcf, amplitudeFile);
        disp(['实部图已保存到: ', amplitudeFile]);
    end

    % 2. 提取虚部并添加阈值判断
    imag_matrix = zeros(size(rho));
    threshold = 1e-4; % 阈值
    for i = 1:size(rho, 1)
        for j = 1:size(rho, 2)
            if abs(rho(i, j)) > threshold
                imag_matrix(i, j) = imag(rho(i, j));
            else
                imag_matrix(i, j) = 0;
            end
        end
    end

    % 计算虚部信息范围（可根据需要使用）
    imag_min = min(imag_matrix(:));
    imag_max = max(imag_matrix(:));

    % 3. 绘制相位信息
    figure('Name', '');  % 创建一个新的图形窗口并命名
    
    % 绘制虚部图
    h = bar3(imag_matrix);
    
    % 强制设置X轴和Y轴的刻度位置和标签
    ax = gca;
    % 设置刻度位置
    ax.XTick = 1:dimension;
    ax.YTick = 1:dimension;
    % 设置刻度标签
    ax.XTickLabel = xticks;
    ax.YTickLabel = yticks;
    
    % Z轴设置
    zlabel('虚部');
    grid on;  % 打开网格以便更好地参考值
    
    % 固定虚部显示范围与刻度
    zlim([0 0.5]);
    ax.ZTick = 0:0.1:0.5;
    
    % 设置字体大小
    ax.FontSize = font_size;
    
    % 修改标题样式，参考map.m
    title(['密度矩阵虚部 - ', num2str(dimension), ' 维量子系统'], 'FontSize', font_size+4);

    % 调整图形大小和减少边缘空白
    set(gcf, 'Position', [100, 100, 900, 700]);  % 设置图形窗口大小
    set(gca, 'LooseInset', get(gca, 'TightInset'));  % 调整边缘，与map.m保持一致
    
    % 调整坐标轴边界和布局，使其更加对称
    axis tight;  % 使坐标轴紧贴数据
    pbaspect([1 1 0.8]);  % 设置长宽高比例
    box on;  % 显示坐标轴盒子
    grid on;  % 显示网格
    
    % 减少左侧空白，使坐标轴两端对称
    pos = get(gca, 'Position');
    pos(1) = 0.1;  % 减少左侧空白
    pos(3) = 0.85;   % 调整宽度
    set(gca, 'Position', pos);
    
    % 设置柱状图颜色并移除colorbar
    for i = 1:length(h)
        zdata = get(h(i),'ZData');
        set(h(i),'CData',zdata,'FaceColor','interp');
    end
    
    % 调整标签编码和显示，使用默认字体
    set(gca, 'FontName', 'default');
    
    % 设置观察角度
    view(45, 30);

    % 如果提供了folderPath，则保存相位图像
    if save_figures
        phaseFile = fullfile(folderPath, [timestamp, '_Imag.png']);
        saveas(gcf, phaseFile);
        disp(['虚部图已保存到: ', phaseFile]);
    end

    % 返回虚部矩阵（为兼容旧接口，变量名仍为 phase）
    phase = imag_matrix;
end
