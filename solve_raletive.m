    % function process_density_matrix(rho_final)
    % 假设输入的密度矩阵 rho_final 是一个 n x n 的矩阵
    % rho_final = rho_th; % 传入的密度矩阵

    % 获取密度矩阵的维度
    n = size(rho_final, 1);

    % 进行特征值分解
    [eigVec, eigVal] = eig(rho_final);

    % 找到对应特征值为 1 的本征向量（即纯态）
    [~, idx] = max(diag(eigVal));  % 获取特征值最大的位置

    % 对应的本征向量即为纯态的态矢量
    pure_state_vector = eigVec(:, idx);

    % 输出纯态的态矢量
    disp('纯态的态矢量：');
    disp(pure_state_vector);

    % 生成 n 维的标准正交基（单位矩阵的列向量）
    basis = eye(n);  % 生成 n 维的单位矩阵，每一列都是一个标准正交基向量

    % 计算系数 c1, c2, ..., cn
    c = zeros(n, 1);
    for i = 1:n
        % 计算每个系数 c_i，即基态 b_i 与纯态矢量的内积
        c(i) = dot(basis(:, i), pure_state_vector);
    end

    % 输出系数 c1, c2, ..., cn
    disp(['系数 c1, c2, ..., c' num2str(n) ':']);
    disp(c);

    % 提取每个系数的模长 r 和相位 phi
    r = abs(c); % 模长
    phi_a = angle(c); % 相位

    phi = phi_a - phi_a(1);  % 创建与phi同样大小的phi_relative，并计算每个系数相对于第一个系数的相位差

    % 输出模长和相位（以 pi 为单位）
    disp('模长和相位（以 pi 为单位）：');
    for i = 1:n
        disp(['c' num2str(i) ': r' num2str(i) ' = ', num2str(r(i)), ', phi' num2str(i) ' = ', num2str(phi(i)/pi), 'π']);
    end

    % 将模长和相位保存在表格中
    coeff_table = table(r, phi/pi, 'VariableNames', {'Modulus (r)', 'Phase (phi/pi)'}, ...
                        'RowNames', arrayfun(@(x) ['c' num2str(x)], 1:n, 'UniformOutput', false));

    % 输出结果表格
    disp('模长和相位的表格：');
    disp(coeff_table);
    plot_amplitude_and_phase(r, phi);
% end
