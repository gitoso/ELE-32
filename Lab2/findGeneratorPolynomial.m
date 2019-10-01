function [gD, min_distance] = findGeneratorPolynomial(n, k)
    % Gera todos os polinômios para dados n e k
    generators_poly = cyclpoly(n, k, 'all');

    % Número de poliômios
    [number_polys, m] = size(generators_poly);

    % Calcula a menor distância mínima de cada polinômio
    min_distances = zeros(1, number_polys);

    % Para todos os números, calcula a distância
    for decimal_number=1:(2^k - 1)

        % Converte o número para binário
        binary_number = de2bi(decimal_number, k, 'left-msb');

        % Calcula a distância para cada polinômio
        for i = 1:number_polys
            if min_distances(i) == 0
                min_distances(i) = sum(mod(conv(fliplr(generators_poly(i,:)), fliplr(binary_number)), 2));
            else
                min_distances(i) = min(min_distances(i), sum(mod(conv(fliplr(generators_poly(i,:)), fliplr(binary_number)), 2)));
            end
        end
    end

    % Encontra o de maior distância mínima
    [min_distance, index_maximum] = max(min_distances);

    % Define como o polinômio gerador
    gD = generators_poly(index_maximum, :);
    gD = fliplr(gD);

    % Printa na tela
    %sprintf('Para n = %d e k = %d, o menor polinômio gerador é:', n, k)
    %gD
    %sprintf('E a distância mínima é %d:', min_distance)