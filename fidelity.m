function F = fidelity(rho1, rho2)
    % 保真度计算函数
    % 输入:
    %   rho1 - 第一个密度矩阵
    %   rho2 - 第二个密度矩阵
    % 输出:
    %   F - 保真度

    % 验证输入矩阵是否为方阵并且维度一致
    if ~ismatrix(rho1) || ~ismatrix(rho2)
        error('输入必须是矩阵');
    end
    if size(rho1, 1) ~= size(rho1, 2) || size(rho2, 1) ~= size(rho2, 2)
        error('输入矩阵必须是方阵');
    end
    if size(rho1) ~= size(rho2)
        error('两个输入矩阵的维度必须一致');
    end

    % 计算矩阵的保真度
%     sqrt_rho1 = sqrtm(rho1);(sqrt_rho1 * rho2 * sqrt_rho1)
    F = (trace(matrix_square_root((matrix_square_root(rho1) * rho2 * matrix_square_root(rho1)))))^2;

    % 保真度精确到小数点后8位
    F = round(F, 8);
end


