% ================================================ %
%                                                  %
%          Laboratório de ELE-32 (Lab 2)           %
%                                                  %
% Alunos:                                          %
%     Gianluigi Dal Toso (COMP-21)                 %
%     Raphael de Vasconcelos (COMP-21)             %
%                                                  %
% ================================================ %

clear all;
clc;

% Valores de n e k com k/n aproximadamente 4/7

%N = [9 10 11 12 15];
%K = [5 6 6 7 9];

n = 7;
k = 4;

% Probabilidades
probabilities = [0.5; 0.2; 0.1];
probabilities = [probabilities; probabilities/10; probabilities/100; probabilities/1000; probabilities/10000; probabilities/100000];
N = length(probabilities);

% Encontra o polinômio gerador
[gD, min_distance] = findGeneratorPolynomial(n, k)

% Encontra as síndromes relacionadas à erros na primeira posição
sindromes = findSyndromes(n, k, gD, min_distance)

pbCustom = [];

for i = 1:N
    nBits = 0;
    nDiff = 0;
    while(nBits < 1e6)
        % Codifica e passa a mensagem aleatória por um canal
        u = randi([0 1], 1, k);
        v = encode(u, gD);
        new_v = channel(v, probabilities(i));

        % Decodifica a nova mensagem
        decoded_v = decode(n, k, new_v, gD, sindromes);
        
        % Divide por gD para obter decoded_u
        [q, r] = deconv(fliplr(decoded_v), fliplr(gD));
        decoded_u = mod(q, 2);
        decoded_u = fliplr(decoded_u);

        % Checa se a mensagem recebida esta correta
        errors = mod(u + decoded_u, 2);
        
        % Contabiliza
        nDiff = nDiff + nnz(errors);
        nBits = nBits + k;
    end
    pbCustom = [pbCustom nDiff/nBits];
end

% Plota o gráfico
plot(probabilities, pbCustom);
hold on;
plot(probabilities, probabilities);
legend('Custom', 'Sem Código');
%xticks(flipud(probabilities));
%yticks(flipud(probabilities));
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
set(gca, 'xdir', 'reverse');
%xlim([0.005 0.5]);
grid on;

