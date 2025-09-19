function rho_out = quick_test_mapmap(rho_in, dimension, outdir)
% quick_test_mapmap - 便捷测试 mapmap_copy 绘图效果
% 用法：
%   quick_test_mapmap(rho, n)                   % 仅在窗口绘图
%   quick_test_mapmap(rho, n, outdir)           % 绘图并保存到 outdir
%   quick_test_mapmap([], n)                    % 自动生成随机密度矩阵并绘图
%   R = quick_test_mapmap(...)                  % 返回用于绘图的 rho

    % 参数与默认值
    if nargin < 2 || isempty(dimension)
        dimension = 4;
    end
    if nargin < 1 || isempty(rho_in)
        rho = generate_random_density_matrix(dimension);
    else
        rho = rho_in;
    end

    % 简单校验与修正
    if size(rho,1) ~= size(rho,2)
        error('rho 必须是方阵');
    end
    if size(rho,1) ~= dimension
        warning('rho 尺寸与 dimension 不一致，自动调整 dimension=%d', size(rho,1));
        dimension = size(rho,1);
    end

    % 绘制振幅
    figure('Name', 'Amplitude (mapmap\_copy)');
    if nargin >= 3 && ~isempty(outdir)
        mapmap_copy(rho, dimension, 'amplitude', outdir, 'test');
    else
        mapmap_copy(rho, dimension, 'amplitude');
    end

    % 绘制相位
    figure('Name', 'Phase (mapmap\_copy)');
    if nargin >= 3 && ~isempty(outdir)
        mapmap_copy(rho, dimension, 'phase', outdir, 'test');
    else
        mapmap_copy(rho, dimension, 'phase');
    end

    if nargout > 0
        rho_out = rho;
    end
end

function rho = generate_random_density_matrix(n)
% 生成一个 n 维随机密度矩阵（厄米、正定、迹为1）
    psi = randn(n,1) + 1i*randn(n,1);
    psi = psi / norm(psi);
    rho_pure = psi*psi';
    % 混入少量白噪使其更一般
    epsilon = 0.05;
    rho = (1-epsilon)*rho_pure + epsilon*eye(n)/n;
    rho = (rho + rho')/2;           % 保证厄米
    rho = rho / trace(rho);         % 归一化
end


