function message = decode(n, k, v, gD, syndromes)
    % Identifica a síndrome
    [q, r] = deconv(fliplr(v), fliplr(gD));
    r = mod(r, 2);
    syndrome = r(1, end-(n-k)+1:end);
    syndrome = fliplr(syndrome);

    % Vetor auxiliar para saber a posição dos deslocamentos
    aux = zeros(1, n);
    aux(1, 1) = 1;

    % Enquanto a síndrome não for nula, tenta decodificar
    while(sum(syndrome) > 0)
       %syndrome
        % Se for síndrome referente à erro na primeira posição, troca o bit
        if ismember(syndrome, syndromes, 'rows')
           % Troca o bit
           v(1, 1) = mod(v(1) + 1, 2);

           % Recalcula a síndrome
           [q, r] = deconv(fliplr(v), fliplr(gD));
           r = mod(r, 2);
           syndrome = r(1, end-(n-k)+1:end);
           syndrome = fliplr(syndrome);
        % Senão, gira a síndrome e a palvra código
        else
            v = circshift(v, 1);
            aux = circshift(aux, 1);
            a = [0 syndrome(1, 1:end-1)];
            b = syndrome(1, end) * gD(1, 1:end-1);
            syndrome = a + b;
            syndrome = mod(syndrome, 2);
        end
    end

    % Volta para a posição original
    while(aux(1) == 0)
        v = circshift(v, 1);
        aux = circshift(aux, 1);
    end
    
    % Retorna
    message = v;