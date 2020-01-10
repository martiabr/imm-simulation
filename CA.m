function model = CA(q)
    model.f = @(x, T) [x(1:6); 0] + [T * x(3:4); T * x(5:6); zeros(3,1)] ...
              + [T^2 * x(5:6); zeros(5,1)];
    model.Q = @(x, T) [q * [T^5/20 * eye(2), T^4/8 * eye(2), T^3/6 * eye(2);
                            T^4/8 * eye(2), T^3/3 * eye(2), T^2/2 * eye(2);
                            T^3/6 * eye(2), T^2/2 * eye(2), T * eye(2);], ...
                            zeros(6,1); zeros(1, 6), 1e-20];
    model.sqrtQ = @(x, T) chol(model.Q(x, T))';
end
