function col = G_OUT(x)

col = {};

for i = 1 : numel(x)
    switch x(i)
        case 2
            tcol = 'I: Broke Fix';
        case 3
            tcol = 'Go I: Held';
        case 4
            tcol = 'Catch C';
        case 5
            tcol = 'Go I: I Sacc';
        case 6
            tcol = 'Go I: Broke T';
        case 7
            tcol = 'Go C';
        case 8
            tcol = 'Catch I: Sacc';
        case 14
            tcol = 'Go I: 2Fast';
    end
    col = cat(1, col, tcol);
end

end