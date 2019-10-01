function new_v = channel(v, prob)
    errors = randi([0 100], 1, length(v));
    for i = 1:length(errors)
        if(errors(1, i) > 100*prob)
            errors(1, i) = 0;
        else
            errors(1, i) = 1;
        end
    end
    errors;
    new_v = mod(v + errors, 2);