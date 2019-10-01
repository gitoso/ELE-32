function v = encode(u, gD)
    % Codifica uma mensagem
    v = mod(conv(gD, u), 2);