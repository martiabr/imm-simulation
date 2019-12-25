function model = CV(q)
    % returns a structure that implements a discrete time CV model with
    % continuous time accelleration covariance q and positional
    % measurement with noise with covariance r, both in two dimensions.
    model.f = @(x, T) [x(1:4); 0] + [T * x(3:4); zeros(3,1)];
    model.Q = @(x, T) [q * [T^3/3, 0,      T^2/2,     0;
                            0,      T^3/3, 0,          T^2/2;
                            T^2/2,  0,     T,        0;
                            0,      T^2/2, 0,         T], zeros(4,1);
                            zeros(1, 4), 1e-20];
    model.sqrtQ = @(x, T) chol(model.Q(x, T))';
end
