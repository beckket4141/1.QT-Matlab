function outT = FindInitialT(rho, dimension)
    % 输入:
    % rho - 初始重构的密度矩阵
    % dimension - 系统的维度 n
    % 输出:
    % outT - 用于优化的初始参数向量

    % 初始化参数向量 outT
    num_parameters = dimension * (dimension + 1) / 2; % 上三角矩阵参数个数（含复数元素）
    outT = zeros(1, num_parameters * 2 - dimension); % 每个复数包含两个参数（实部和虚部）

    % 计算用于稳定处理的阈值
    diag_elements = real(diag(rho(1:dimension, 1:dimension)));
    max_scale = max(1, max(abs(diag_elements)));
    diag_threshold = max(eps, eps(max_scale));
    normalization_threshold = sqrt(diag_threshold);

    % 预先计算安全的对角元素，防止取平方根时出现 NaN/Inf
    safe_diagonal = zeros(dimension, 1);
    diag_clamped = false(dimension, 1);
    for i = 1:dimension
        diag_value = real(rho(i, i));

        if ~isfinite(diag_value)
            diag_value = diag_threshold;
            diag_clamped(i) = true;
        elseif diag_value < 0
            diag_value = max(diag_threshold, abs(diag_value));
            diag_clamped(i) = true;
        elseif diag_value <= diag_threshold
            diag_value = diag_threshold;
            diag_clamped(i) = true;
        end

        safe_diagonal(i) = diag_value;
    end

    % 提取密度矩阵的对角元素和非对角元素，并将其转换为参数向量
    index = 1;
    for i = 1:dimension
        % 计算对角线元素的初始值（实数）
        diag_entry = sqrt(safe_diagonal(i));
        if ~isfinite(diag_entry)
            diag_entry = sqrt(diag_threshold);
        end
        outT(index) = real(diag_entry);
        index = index + 1;

        % 计算非对角线元素的初始值（复数）
        for j = i+1:dimension
            % 根据安全的对角线元素计算归一化因子
            denom = sqrt(safe_diagonal(i) * safe_diagonal(j));
            temp = rho(i, j);

            % 当分母过小或被截断时，跳过归一化以保持数值稳定
            if ~(isfinite(denom) && denom > normalization_threshold) || diag_clamped(i) || diag_clamped(j)
                normalized_value = temp;
            else
                normalized_value = temp / denom;
            end

            real_part = real(normalized_value);
            imag_part = imag(normalized_value);

            if ~isfinite(real_part)
                real_part = 0;
            end
            if ~isfinite(imag_part)
                imag_part = 0;
            end

            outT(index) = real_part;
            index = index + 1;
            outT(index) = imag_part;
            index = index + 1;
        end
    end
end
