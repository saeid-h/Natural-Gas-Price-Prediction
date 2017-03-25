% Threshold Function Illustration

v = -2:0.1:2;
vzero = find(v==0);
v = [v(1:vzero) v(vzero:end)];

fvth = [];
for ii = 1:size(v,2)
    if v(ii) > 0
        fvth(ii) = 1;
    else
        fvth(ii) = 0;
    end    
end
fvth(vzero+1) = 1;

figure;
subplot(3,1,1);
plot(v,fvth, 'k', 'linewidth', 2);
title ('Threshold Function')
xlabel ('v')



% Piecewise-Linear Function Illustration
fvpl = [];
for ii = 1:size(v,2)
    if v(ii) >= 0.5
        fvpl(ii) = 0.5;
    elseif v(ii) > -0.5
        fvpl(ii) = v(ii);
    else
        fvpl(ii) = -0.5;
    end    
end
% fvth(vzero+1) = [];

subplot(3,1,2);
plot(v,fvpl, 'k', 'linewidth', 2);
title ('Piecewise-Linear Function')
xlabel ('v')



% Sigmoid Function Illustration
v = -10:0.1:10;
fvsig = [];
a = [0.5 1 3];
for jj = 1:3
    fvsig(:,jj) = 1 ./ (1 + exp(-a(jj).*v));
end

subplot(3,1,3);
plot(v,fvsig(:,1), 'k', 'linewidth', 2);
hold on
plot(v,fvsig(:,2), 'k', 'linewidth', 2);
plot(v,fvsig(:,3), 'k', 'linewidth', 2);
title ('Sigmoid Function')
xlabel ('v')
