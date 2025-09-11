function Upsilon = invers(dimension)
    % 输入:
    % dimension - 系统的维度 n（2, 3, 4,...）
    % 输出:
    % Upsilon - n 维系统的转换矩阵

    % 定义 2 维系统的基本转换矩阵
    Upsilon_base = [
        1/2, 0, 0, 1/2;
        1/2, 0, 0, -1/2;
        1/2, 1/2, 0, 0;
        1/2, 0, -1i/2, 0
    ];

    % 如果 dimension = 2，直接返回 Upsilon_base
    if dimension == 2
        Upsilon = Upsilon_base;
        return;
    end

    % 如果 dimension > 2，则使用 Kronecker 积构建高维转换矩阵
    Upsilon = Upsilon_base; % 初始化为 2 维的 Upsilon
    for i = 2:dimension/2
        Upsilon = kron(Upsilon, Upsilon_base);
    end
end
