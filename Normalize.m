function [Xnormal Xmu Xsigma] = Normalize(X)

    [m n] = size(X);
    
    if n > m 
        X = X';
    end
    
    Xmu = nanmean(X);
    Xsigma = nanstd(X);
    
    XXmu = repmat(Xmu,n,1);
    XXsigma = repmat(Xsigma,n,1);
    
    Xnormal = (X - XXmu) ./ XXsigma;
    
    if n > m 
        Xmu = Xmu';
        Xsigma = Xsigma';
        Xnormal = Xnormal';
    end
    
    
end