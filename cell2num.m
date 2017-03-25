function Xnum = cell2num (Xcell)

% This function convert a numerical cell array into a matrix
% NaN would be replaced to empty cells

if iscell (Xcell)

    [m n] = size(Xcell);
    Xnum = zeros(m,n);

    for ii = 1:m
        for jj = 1:n
            if isempty(Xcell{ii,jj})
                Xnum(ii, jj) = NaN;
            else
                Xnum(ii, jj) = Xcell{ii,jj};
            end
        end
    end

else
    
    Xnum = Xcell;
end

end
    