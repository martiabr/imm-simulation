function model = CT(q)
    % return a model structure for CT with position measurements that
    % implements the dynamic and measurement function along with their
    % Jacobian, as well as the process and measurement noise.
    % q;    q(1) is acceleration noise covariance.
    %       q(2) is turn rate noise covariance.
    % r;    positional measurement covariance
    model.f = @ f_CT; %f_CT;
    model.Q = @(x, T) [q * [T^3/3 * eye(2), T^2/2 * eye(2);
                        T^2/2 * eye(2), T * eye(2)], zeros(4,3);
                        zeros(3, 4), 1e-20 * eye(3)];
    model.Q = @ (x, T) [[q(1) * [T^3/3 * eye(2), T^2/2 * eye(2);
                        T^2/2 * eye(2), T * eye(2)], zeros(4,2);
                        zeros(2, 4), 1e-20 * eye(2)], zeros(6, 1);
                        zeros(1, 6), q(2) * T];
    model.sqrtQ = @(x, T) chol(model.Q(x, T))';
end

function x = f_CT(x,T)
    if(abs(x(7)) > 0.0001)
        x = [x(1) + sin(T * x(7)) * x(3) / x(7) - (1 - cos(T * x(7))) * x(4) / x(7);
                x(2) + (1 - cos(T * x(7))) * x(3) / x(7) + sin(T * x(7)) * x(4) / x(7);
                cos(T * x(7)) * x(3) - sin(T * x(7)) * x(4);
                sin(T * x(7)) * x(3) + cos(T * x(7)) * x(4);
                0; 0; x(7)];
    else
        x = [x(1:4); zeros(3,1)] + [T * x(3:4); zeros(5,1)];
    end
end
