function model = CT(q, r)
    % return a model structure for CT with position measurements that
    % implements the dynamic and measurement function along with their
    % Jacobian, as well as the process and measurement noise.
    % q;    q(1) is acceleration noise covariance.
    %       q(2) is turn rate noise covariance-
    % r;    positional measurement covariance
    model.f = @ f_CT; %f_CT;
    model.Q = @ (x, T) [q(1) * [   T^3/3, 0,      T^2/2,	0;
                    0,      T^3/3, 0,    	T^2/2 ;
                    T^2/2, 0,      T,   	0,     ;
                    0,      T^2/2, 0,    	T,    ],   zeros(4,1);
                    zeros(1, 4),                        q(2) * T];
                
   model.h = @(x) x(1:2);
   model.R = @(x) r*eye(2);
end

function x = f_CT(x,T)
    if(abs(x(5)) > 0.0001)
        x = [x(1) + sin(T * x(5)) * x(3) / x(5) - (1 - cos(T * x(5))) * x(4) / x(5);
                x(2) + (1 - cos(T * x(5))) * x(3) / x(5) + sin(T * x(5)) * x(4) / x(5);
                cos(T * x(5)) * x(3) - sin(T * x(5)) * x(4);
                sin(T * x(5)) * x(3) + cos(T * x(5)) * x(4);...
                x(5)];
    else
        x = [x(1) + T*x(3); x(2) + T*x(4); x(3); x(4); 0];
    end
end
