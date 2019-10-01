%% =============================================== %
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

%% ----- Tarefa 1 -----
% Valores de n e k com k/n aproximadamente 4/7

%N = [9 10 11 12 15];
%K = [5 6 6 7 9];

n = 15;
k = 9;

%% ----- Tarefa 2 -----
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
            min_distances(i) = sum(mod(conv(generators_poly(i,:), binary_number), 2));
        else
            min_distances(i) = min(min_distances(i), sum(mod(conv(generators_poly(i,:), binary_number), 2)));
        end
    end
end

% Encontra o de maior distância mínima
[min_distance, index_maximum] = max(min_distances);

% Define como o polinômio gerador
gD = generators_poly(index_maximum, :);

% Printa na tela
sprintf('Para n = %d e k = %d, o menor polinômio gerador é:', n, k)
gD
sprintf('E a distância mínima é %d:', min_distance)

%% ----- Tarefa 3 -----
% Codifica uma mensagem
u = round(rand(1,9));
v = mod(conv(gD, u), 2)

%% ----- Tarefa 4 -----
% Prepara o decodificador

% Gera as síndromes para todos os padrões de erro nos quais existe erro na
% primeira posição

% Vetor de síndromes relacionadas à erros na primeira posição

sindromes = [];

for i = 0:(2 ^ (length(u) - 1) - 1)
    binary = de2bi(i, length(v) - 1, 'left-msb');
    error = [1 binary];
    if(sum(error) <= min_distance / 2)
        [q, r] = deconv(error, gD);
        r = mod(r, 2);
        sindrome = r(1, end-(n-k)+1:end);
        if(sum(sindrome) > 0)
            sindromes = [sindromes; sindrome];
        end
    end
end

sindromes = unique(sindromes, 'rows');


% Codifica e passa a mensagem aleatória por um canal
error_prob = 0.1;

u = randi([0 1], 1, k);
v = mod(conv(gD, u), 2);

errors = randi([0 100], 1, n);
for i = 1:length(errors)
    if(errors(1, i) > 100*error_prob)
        errors(1, i) = 0;
    else
        errors(1, i) = 1;
    end
end
errors
transmitted_v = mod(v + errors, 2);


% Decodifica a nova mensagem

% Identifica a síndrome
[q, r] = deconv(transmitted_v, gD);
r = mod(r, 2);
sindrome = r(1, end-(n-k)+1:end);

% Vetor auxiliar para saber a posição dos deslocamentos
aux = zeros(1, n);
aux(1, 1) = 1;

% Enquanto a síndrome não for nula, tenta decodificar
while(sum(sindrome) > 0)
    % Se for síndrome referente à erro na primeira posição, troca o bit
    if ismember(sindrome, sindromes, 'rows')
       % Troca o bit
       transmitted_v(1, 1) = mod(transmitted_v(1) + 1, 2);
       
       % Recalcula a síndrome
       [q, r] = deconv(transmitted_v, gD);
       r = mod(r, 2);
       sindrome = r(1, end-(n-k)+1:end);
       
    % Senão, gira a síndrome e a palvra código
    else
        transmitted_v = circshift(transmitted_v, 1);
        aux = circshift(aux, 1);
        sindrome = [0 sindrome(1, 1:end-1)] + sindrome(1, end) * gD(1, 1:end-1);
        sindrome = mod(sindrome, 2);
    end
end

% Volta para a posição original
while(aux(1) == 0)
    transmitted_v = circshift(transmitted_v, 1);
    aux = circshift(aux, 1);
end

[q, r] = deconv(transmitted_v, gD);
original_u = u;
received_u = mod(q, 2);

errors = mod(original_u + received_u, 2);

% u = [0 1 0 0 0 0 0 0 0]
% v = mod(conv(generators_poly(2,:), u),2)
% v(1) = 1;
% v
% g = generators_poly(2,:)
% 
% [q,r] = deconv(v,g)
% qq = mod(q,2)
% rr = mod(r,2)
% vv = mod(conv(qq,g) + rr,2)
% s = [0 0 0 0 0 0 0 0 rr]
% s = s(1:(end-8))
% d = zeros(1,15)
% d(1) = 1
% d(15) = 1
% [q, r] = deconv(s, d)
% 
% s = [1 0 1]
% g = [1 1 0 1]
% ss = [0 0 0 s]
% ss = ss(1:(end-3))
% d = zeros(1, 4)
% d(1) = 1
% d(4) = 1
% [q, r] = deconv(ss, d)



% a = cyclpoly(15,9,'all')
% s1 = 0;
% s2 = 0;
% s3 = 0;
% for i=1:(2^9 - 1)*1
%     p = de2bi(i,9, 'left-msb');
%     c1 = mod(conv(a(1,:), p),2);
%     c2 = mod(conv(a(2,:), p),2);
%     c3 = mod(conv(a(3,:), p),2);
%     if i == 1
%         s1 = sum(c1);
%         s2 = sum(c2);
%         s3 = sum(c3);
%     else
%         s1 = min(s1, sum(c1));
%         s2 = min(s2,sum(c2));
%         s3 = min(s3,sum(c3));
%     end
% end
% s1
% s2
% s3
% u = [0 1 0 0 0 0 0 0 0]
% v = mod(conv(a(2,:), u),2)
% v(1) = 1;
% v
% g = a(2,:)
% 
% [q,r] = deconv(v,g)
% qq = mod(q,2)
% rr = mod(r,2)
% vv = mod(conv(qq,g) + rr,2)
% s = [0 0 0 0 0 0 0 0 rr]
% s = s(1:(end-8))
% d = zeros(1,15)
% d(1) = 1
% d(15) = 1
% [q, r] = deconv(s, d)
% 
% s = [1 0 1]
% g = [1 1 0 1]
% ss = [0 0 0 s]
% ss = ss(1:(end-3))
% d = zeros(1, 4)
% d(1) = 1
% d(4) = 1
% [q, r] = deconv(ss, d)

% u = round(rand(1,9));
% v = mod(conv(gD, u), 2)
% [q,r] = deconv(v, gD);
% q = mod(q, 2);
% r = mod(r, 2)
% r = r(1, n-k:end)

