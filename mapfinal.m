function phase = map2(rho, dimension, folderPath, l_dim, p_dim)
    % mapmap - 可视化密度矩阵的振幅和相位信息
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
    
    % 检查是否提供了l_dim和p_dim参数用于生成OAM基态标签
    use_oam_basis = nargin >= 5 && l_dim > 0 && p_dim > 0;
    
    % 生成标签
    xticks = cell(1, dimension);
    yticks = cell(1, dimension);
    
    if use_oam_basis
        % 使用OAM基态标签，使用简单文本格式
        for i = 1:dimension
            idx = i-1; % 从0开始计数
            l_val = floor(idx/p_dim);
            p_val = mod(idx, p_dim);
            xticks{i} = ['|', num2str(l_val), num2str(p_val), '>'];
            yticks{i} = ['|', num2str(l_val), num2str(p_val), '>'];
        end
    else
        % 根据维度确定每个指标需要的位数
        if dimension <= 4
            % 对于4维及以下系统
            for i = 1:dimension
                idx = i-1; % 从0开始计数
                xticks{i} = ['|', num2str(floor(idx/2)), num2str(mod(idx,2)), '>'];
                yticks{i} = ['|', num2str(floor(idx/2)), num2str(mod(idx,2)), '>'];
            end
        elseif dimension <= 9
            % 对于9维及以下系统
            for i = 1:dimension
                idx = i-1; % 从0开始计数
                xticks{i} = ['|', num2str(floor(idx/3)), num2str(mod(idx,3)), '>'];
                yticks{i} = ['|', num2str(floor(idx/3)), num2str(mod(idx,3)), '>'];
            end
        elseif dimension <= 16
            % 对于16维系统
            for i = 1:dimension
                idx = i-1; % 从0开始计数
                xticks{i} = ['|', num2str(floor(idx/4)), num2str(mod(idx,4)), '>'];
                yticks{i} = ['|', num2str(floor(idx/4)), num2str(mod(idx,4)), '>'];
            end
        else
            % 对于更高维度系统
            digits = ceil(sqrt(dimension));
            for i = 1:dimension
                idx = i-1; % 从0开始计数
                xticks{i} = ['|', num2str(floor(idx/digits)), num2str(mod(idx,digits)), '>'];
                yticks{i} = ['|', num2str(floor(idx/digits)), num2str(mod(idx,digits)), '>'];
            end
        end
    end
    
    % 创建时间戳（将时间戳放在最前面）
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    
    % 设置字体大小
    font_size = 16;  % 增大字体大小
    
    % 1. 绘制振幅信息
    amplitude_matrix = abs(rho);
    figure('Name', '');  % 创建一个新的图形窗口并命名
    
    % 绘制3D柱状图
    h = bar3(amplitude_matrix);
    
    % 强制设置X轴和Y轴的刻度位置和标签
    ax = gca;
    % 设置刻度位置
    ax.XTick = 1:dimension;
    ax.YTick = 1:dimension;
    % 设置刻度标签
    ax.XTickLabel = xticks;
    ax.YTickLabel = yticks;
    
    % 调整图形显示，最大限度填充图形窗口，几乎无留白
    set(gcf, 'Units', 'normalized');
    set(gca, 'Position', [0.01 0.01 0.98 0.95]);  % 几乎占满整个图形窗口
    set(gcf, 'InvertHardcopy', 'off');  % 保存时保持当前显示比例
    
    % 精简标签显示
    ax.XTickLabelRotation = 45;  % 旋转X轴标签
    ax.YTickLabelRotation = -45; % 旋转Y轴标签
    
    % 调整标题位置
    title([' ', num2str(dimension)], 'FontSize', font_size+4, 'Position', [dimension/2, dimension/2, max(max(amplitude_matrix))*1.2]);
    
    % 移除原来的不必要设置
    % 调整标签编码和显示，使用默认字体
    set(gca, 'FontName', 'default');
    
    % 设置观察角度 - 使用原来的方位角
    view(30, 30);  % 按用户要求保持原来的视角
    
    % 修复坐标轴与数据之间的间隙问题
    % 设置X轴和Y轴的范围紧贴数据，略微扩大确保所有数据可见
    xlim([0.5, dimension+0.5]);  % 减少X轴与数据边缘的间隙
    ylim([0.5, dimension+0.5]);  % 减少Y轴与数据边缘的间隙
    
    % 确保完整显示3D图像
    set(gca, 'CameraViewAngleMode', 'manual');
    set(gca, 'CameraViewAngle', 10);  % 进一步缩小观察角度以显示更多内容
    
    % 移除标题，按用户要求
    title('');
    
%     % 重要：放在最后设置Z轴的显示范围和刻度，避免被axis tight覆盖
%     zlim([0 0.25]);  % 固定显示范围
%     ax.ZTick = 0:0.05:0.25;  % 强制刻度间隔
%     ax.ZTickLabel = {'0','0.05','0.10','0.15','0.20','0.25'};  % 消除浮点误差
%     zlabel('');  % 添加Z轴标签
    % 重要：放在最后设置Z轴的显示范围和刻度，避免被axis tight覆盖
    zlim([0 0.50]);  % 固定显示范围
    ax.ZTick = 0:0.1:0.5;  % 精简刻度
    ax.ZTickLabel = {'0','0.1','0.2','0.3','0.4','0.5'};  % 精简显示
    zlabel('');  % 添加Z轴标签

    % 如果提供了folderPath，则保存振幅图像
    if save_figures
        amplitudeFile = fullfile(folderPath, [timestamp, '_Amplitude.png']);
        saveas(gcf, amplitudeFile);
        disp(['振幅图已保存到: ', amplitudeFile]);
    end

    % 2. 提取相位信息并添加阈值判断
    phase_matrix = zeros(size(rho));
    threshold = 1e-4; % 阈值
    for i = 1:size(rho, 1)
        for j = 1:size(rho, 2)
            if i ~= j
                real_part = real(rho(i, j));
                imag_part = imag(rho(i, j));
                if abs(real_part) < threshold
                    real_part = 0;
                end
                if abs(imag_part) < threshold
                    imag_part = 0;
                end
                %phase_matrix(i, j) = angle(real_part + 1i * imag_part); % 使用修改后的值计算相位
                 phase_matrix(i, j) = imag_part;
            end
        end
    end
%     phase = phase_matrix / pi;
     phase = phase_matrix ;

    % 计算相位信息的最小值和最大值，与map.m保持一致
%     phase_min = min(phase_matrix(:)) / pi;
%     phase_max = max(phase_matrix(:)) / pi;
    phase_min = min(phase_matrix(:));   
    phase_max = max(phase_matrix(:)) ;

    % 3. 绘制相位信息
    figure('Name', '');  % 创建一个新的图形窗口并命名
    
    % 绘制相位图
%     h = bar3(phase_matrix / pi); % 将相位信息转换为 pi 单位
      h = bar3(phase_matrix);
    
    % 强制设置X轴和Y轴的刻度位置和标签
    ax = gca;
    % 设置刻度位置
    ax.XTick = 1:dimension;
    ax.YTick = 1:dimension;
    % 设置刻度标签
    ax.XTickLabel = xticks;
    ax.YTickLabel = yticks;
    
    % 调整图形显示，最大限度填充图形窗口，几乎无留白
    set(gcf, 'Units', 'normalized');
    set(gca, 'Position', [0.01 0.01 0.98 0.95]);  % 几乎占满整个图形窗口
    set(gcf, 'InvertHardcopy', 'off');  % 保存时保持当前显示比例
    
    % 精简标签显示
    ax.XTickLabelRotation = 45;  % 旋转X轴标签
    ax.YTickLabelRotation = -45; % 旋转Y轴标签
    
    % 调整标题位置
    title(['Phase Information (in \pi radians) for Dimension ', num2str(dimension)], 'FontSize', font_size+4, 'Position', [dimension/2, dimension/2, 1.2]);
    
    % 移除原来的不必要设置
    % 调整标签编码和显示，使用默认字体
    set(gca, 'FontName', 'default');
    
    % 设置观察角度 - 使用原来的方位角
    view(30, 30);  % 按用户要求保持原来的视角
    
    % 修复坐标轴与数据之间的间隙问题
    % 设置X轴和Y轴的范围紧贴数据，略微扩大确保所有数据可见
    xlim([0.5, dimension+0.5]);  % 减少X轴与数据边缘的间隙
    ylim([0.5, dimension+0.5]);  % 减少Y轴与数据边缘的间隙
    
    % 确保完整显示3D图像
    set(gca, 'CameraViewAngleMode', 'manual');
    set(gca, 'CameraViewAngle', 10);  % 进一步缩小观察角度以显示更多内容
    
    % 移除标题，按用户要求
    title('');
    
    % 重要：放在最后设置Z轴的显示范围和刻度，避免被axis tight覆盖
%     zlim([-1, 1]);  % 相位通常在-π到π之间，即-1到1(以π为单位)
%     zlabel('');  % 添加Z轴标签
    % 重要：放在最后设置Z轴的显示范围和刻度，避免被axis tight覆盖
%     zlim([0 0.05]);  % 固定显示范围
%     ax.ZTick = 0:0.005:0.05;  % 强制刻度间隔
%     ax.ZTickLabel = {'0','0.005','0.010','0.015','0.020','0.025','0.0030','0.035','0.040','0.045','0.050'};  % 消除浮点误差
%     zlabel('');  % 添加Z轴标签
    % 统一相同的精简刻度范围
    zlim([0 0.50]);
    ax.ZTick = 0:0.1:0.5;
    ax.ZTickLabel = {'0','0.1','0.2','0.3','0.4','0.5'};
    zlabel('');
    % 如果提供了folderPath，则保存相位图像
    if save_figures
        phaseFile = fullfile(folderPath, [timestamp, '_Phase.png']);
        saveas(gcf, phaseFile);
        disp(['相位图已保存到: ', phaseFile]);
    end

    % 返回相位矩阵
    phase = phase_matrix;
end
