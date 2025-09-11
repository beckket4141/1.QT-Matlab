function phase = mapmap_2(rho, dimension)
    % 检查输入维度是否有效
    if dimension < 2 || mod(dimension, 1) ~= 0
        error('请输入有效的维度（必须为大于等于2的整数）。');
    end

    % 绘制振幅信息
    amplitude_matrix = abs(rho);
    figure;
    bar3(amplitude_matrix);

    % 设置 X、Y 轴标签
    xticks = cell(1, dimension); % 初始化 X 轴标签
    yticks = cell(1, dimension); % 初始化 Y 轴标签
    for i = 1:dimension
        xticks{i} = ['Basis-', num2str(i)];
        yticks{i} = ['Basis-', num2str(i)];
    end
    set(gca, 'XTickLabel', xticks, 'YTickLabel', yticks);
    title(['Amplitude Information for Dimension ', num2str(dimension)]);

    % 提取相位信息并添加阈值判断
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
                phase_matrix(i, j) = angle(real_part + 1i * imag_part); % 使用修改后的值计算相位
            end
        end
    end
%     phase = phase_matrix / pi;

    % 将相位信息限制在 0 到 2pi 之间
    phase = mod(phase_matrix, 2*pi);  % 这里将相位限制在 [0, 2] 范围内

   

    % 计算相位信息的最小值和最大值
    phase_min = min(phase_adjusted(:));
    phase_max = max(phase_adjusted(:));

    % 绘制相位信息
    figure;
    bar3(phase_adjusted); % 将相位信息转换为 [0, 2] 范围
    set(gca, 'XTickLabel', xticks, 'YTickLabel', yticks);
    title(['Phase Information (in \pi radians) for Dimension ', num2str(dimension)]);
    ylabel('Phase (\pi radians)');

    % 设置纵坐标范围和刻度标签
    zlim([0 2]);  % 相位范围固定为 [0, 2]
    set(gca, 'ZTick', [0, 0.5, 1, 1.5, 2], ...
             'ZTickLabel', {'0', '1/2\pi', '\pi', '3/2\pi', '2\pi'});
end
