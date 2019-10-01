function syndromes = findSyndromes(n, k, gD, min_distance)
    syndromes = [];

    for i = 0:(2 ^ (k - 1) - 1)
        binary = de2bi(i, n - 1, 'left-msb');
        error = [1 binary];
        if(sum(error) <= min_distance / 2)
            [q, r] = deconv(error, gD);
            r = mod(r, 2);
            syndrome = r(1, end-(n-k)+1:end);
            if(sum(syndrome) > 0)
                syndromes = [syndromes; syndrome];
            end
        end
    end

    syndromes = unique(syndromes, 'rows');
