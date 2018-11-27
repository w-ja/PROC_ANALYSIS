function dir_out = H_LATEDIR(dir_in)

dirc = dir(dir_in);

dirc = dirc(find(cellfun(@isdir,{dirc(:).name})));

inds = [];
n    = 0;
k    = 1;

while n < 2 && k <= length(dirc)
    if any(strcmp(dirc(k).name, {'.', '..'}))
        inds(end + 1) = k;
        n = n + 1;
    end
    k = k + 1;
end

dirc(inds) = [];

[A,I] = max([dirc(:).datenum]);

if ~isempty(I)
    dir_out = [dirc(I).folder '\' dirc(I).name];
end

end