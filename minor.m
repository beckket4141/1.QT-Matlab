function val = minor(matrix, rows, cols)
    % 函数用途: val = minor(matrix, rows, cols)
    %
    % 计算给定矩阵的一个子式（minor），通过删除矩阵中所有列（由 "cols" 指定）
    % 和所有行（由 "rows" 指定），然后计算该子矩阵的行列式。矩阵应为方阵，
    % 且 length(rows) == length(cols)。
    
    % 删除指定的行
    matrix(rows, :) = [];
    
    % 删除指定的列
    matrix(:, cols) = [];
    
    % 计算子矩阵的行列式
    val = det(matrix);
    
    % 详细解释:
    % 1. 删除指定的行: matrix(rows, :) = [];
    %    - 通过将 matrix 中指定的行（由 rows 索引指定）设为空，从而删除这些行。
    % 2. 删除指定的列: matrix(:, cols) = [];
    %    - 通过将 matrix 中指定的列（由 cols 索引指定）设为空，从而删除这些列。
    % 3. 计算子矩阵的行列式: val = det(matrix);
    %    - 对删除指定行和列后的子矩阵计算其行列式，并将结果赋值给 val。
end
