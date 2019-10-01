function v = encode(u, gD)
    % Codifica uma mensagem
    v = mod(conv(fliplr(gD), fliplr(u)), 2);
    v = fliplr(v);