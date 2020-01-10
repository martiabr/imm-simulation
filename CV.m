function model = CV(q)
    % returns a structure that implements a discrete time CV model with
    % continuous time accelleration covariance q and positional
    % measurement with noise with covariance r, both in two dimensions.
    model.f = @(x, T) [x(1:4); zeros(3,1)] + [T * x(3:4); zeros(5,1)];
    model.Q = @(x, T) [q * [T^3/3 * eye(2), T^2/2 * eye(2);
                            T^2/2 * eye(2), T * eye(2)], zeros(4,3);
                            zeros(3, 4), 1e-20 * eye(3)];
    model.sqrtQ = @(x, T) chol(model.Q(x, T))';
end
