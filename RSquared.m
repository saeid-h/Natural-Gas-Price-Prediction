function [R2] = RSquared (y, f)

R2 = 1 - norm(y-f)./norm(y);

