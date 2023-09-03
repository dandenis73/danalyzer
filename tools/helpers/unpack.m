function C = unpack(C)
% Unpack a nested cell array

for i = 1:size(C, 1)

    for j = 1:size(C, 2)

        if iscell(C{i, j})

            C{i, j} = C{i, j}{:};
        end
    end
end
