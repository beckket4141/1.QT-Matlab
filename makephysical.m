function out = makephysical(rho)
    % function out = makephysical(rho)
    % 确保 rho 是正定的密度矩阵。
    % 通过删除负特征值的方式使其正定。
    
    % 计算矩阵 rho 的特征值分解
    [v, d] = eig(rho);
    
    % 将负特征值设为零
    d(find(d < 0)) = 0;
    
    % 归一化特征值矩阵，使其迹为1
    d = d / trace(d);
    
    % 使用特征向量矩阵 v 和处理后的特征值矩阵 d 重构密度矩阵
    rho = v * d / v;
    
    % 确保密度矩阵是 Hermitian 矩阵并且具有物理意义
    out = tril(rho, -1) + tril(rho, -1)' ...
        + real(diag(diag(rho))) + eye(size(rho)) * 1e-6;
    
    % 详细解释:
    % 1. 特征值分解: [v, d] = eig(rho);
    %    - v 是特征向量矩阵，d 是包含特征值的对角矩阵。
    % 2. 删除负特征值: d(find(d < 0)) = 0;
    %    - 找到 d 中小于零的元素索引，并将这些元素设置为零，确保特征值非负。
    % 3. 归一化特征值矩阵: d = d / trace(d);
    %    - 计算 d 的迹并归一化，使密度矩阵的迹为1。
    % 4. 重构密度矩阵: rho = v * d / v;
    %    - 使用特征向量 v 和处理后的特征值 d 重新构造密度矩阵。
    % 5. 确保 Hermitian 性和数值稳定性:
    %    out = tril(rho, -1) + tril(rho, -1)' + real(diag(diag(rho))) + eye(size(rho)) * 1e-6;
    %    - tril(rho, -1) 提取 rho 的下三角部分（不包括对角线）。
    %    - tril(rho, -1)' 提取 rho 的下三角部分的共轭转置，使 rho 矩阵成为 Hermitian。
    %    - real(diag(diag(rho))) 确保对角元素是实数。
    %    - eye(size(rho)) * 1e-6 在对角线上加入一个非常小的数，确保数值稳定性。
end
