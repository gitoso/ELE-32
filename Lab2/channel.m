function message = channel(message, p)
    [m, n] = size(message);
    for i = 1:n
        x = rand;
        if x <= p
            message(i) = ~message(i);
        end
    end
    return;
end