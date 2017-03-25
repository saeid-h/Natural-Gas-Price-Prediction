function AUTOCORR

load Variables;
ret_NGHH = price2ret(NGHH);

%% Ploting data 
% Check auto corelation factor, and
% partial auto correlation factor
% for rate of return

Pts = 12;
Win = ones(Pts, 1) ./ Pts;
F2 = convn(ret_NGHH, Win, 'Same');
F3 = F2(6:end-6);

TestVar = ret_NGHH;

Fig1 = figure; %(figure1.axes1)
%Fig1. WindowStyle = 'modal';
subplot(2,2,1);
plot(Dates(2:end), ret_NGHH)
hold on
plot(Dates(2:end), F2)
xlabel ('Date, years')
ylabel ('Rate of Return, %')
legend ('Rate of Return', 'Filtered Rate of Return')
datetick
subplot(2,2,2);
autocorr(TestVar,24)
subplot(2,2,3);
pmcov(TestVar,1);
subplot(2,2,4);
parcorr(TestVar,24)


end
