function [sigma, phi, B, C, D] = Q_quantities(P, m, G, y)

    T = size(m,2) - 1;

    sigma = zeros(size(P{1}));
    for k = 1:T
        sigma = sigma + P{k+1} + m{k+1}*m{k+1}';
    end
    sigma = sigma* 1/T;

    phi = zeros(size(P{1}));
    for k = 1:T
        phi = phi + P{k} + m{k}*m{k}';
    end
    phi = 1/T * phi;

    B = zeros(size(y{1},1), size(m{1}',2));
    for k = 1:T
        B = B + y{k+1} * m{k+1}';
    end
    B = 1/T * B;

    C = zeros(size(P{1},1),size( G{1}', 2));
    for k = 1:T
        C = P{k+1} * G{k}' + m{k+1} * m{k}';
    end
    C = 1/T * C;

    D = zeros(size(y,1));
    for k = 1:T
        D = y{k+1} * y{k+1}';
    end
    D = D * 1/T;

end

