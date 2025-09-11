function rho_r = reconstruct_density_matrix_nD(PnD, dimension)
    % 输入:
    % PnD - 测量得到的功率值数组，大小为 dimension^2
    % dimension - 系统的维度 n（2, 3, 4,...）
    % 输出:
    % rho_r - 重构的 n 维密度矩阵

    % 输入功率值
    p = PnD;  
    P_raw = p';
    
    % 对测量功率值进行归一化
    P = P_raw / sum(P_raw(1:dimension)); 

    % 生成投影算符
    [~, mu] = generate_projectors_and_operators(dimension);

    % 构建线性方程组 M
    M = zeros(dimension^2, dimension^2);
    for j = 1:dimension^2
        mu_j = mu{j};
        M(j, :) = reshape(mu_j, 1, []); % 将投影算符展开为行向量形式
    end

    % 求解密度矩阵的元素
    rho_vector = M \ P;

    % 将向量形式的密度矩阵转换为 n x n 矩阵
    rho_matrix = reshape(rho_vector, dimension, dimension);

    % 对整个矩阵取共轭
    rho_matrix = conj(rho_matrix);

    % 根据方法 xx 的值进行物理条件的调整
    xx = 0;  % 修改 xx 值，0 表示调用 makephysical 函数
    if xx == 1
        rho_matrix = (rho_matrix + rho_matrix') / 2;
        rho_matrix = rho_matrix / trace(rho_matrix);
    elseif xx == 0
        rho_matrix = makephysical(rho_matrix);
    else
        error('wrong xx.');
    end

    % 返回重构的密度矩阵
    rho_r = rho_matrix;

    % 输出重构的密度矩阵
    disp('重构的密度矩阵：');
    disp(rho_r);
end
