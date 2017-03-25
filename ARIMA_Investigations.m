%% initializing

load Variables;
HHSPm = cell2num(HHSP);
if size(HHSPm,1) == 1, HHSPm = HHSPm';, end
ret_HHSP = price2ret(HHSPm);
% ret_HHSP = diff(ret_HHSP);

%% Plotting

% Spot price
dates_str = datestr(Dates);
figure
subplot(2,1,1);
plot(Dates, HHSPm, 'linewidth', 1.05)
datetick
xlabel('Date, years')
ylabel('Natural Gas Monthly Price, $/MMBtu')
title ('Natural Gas Price History (Henry Hub)')


%Rate of Returns
subplot(2,1,2);
plot(Dates(2:end), diff(HHSPm), 'linewidth', 1.05)
datetick
xlabel('Date, years')
ylabel('First Difference of Price')
title ('First Difference of Price Movement')

%% Autocorrelation plots 

% Sopt price
figure
subplot(2,1,1);
autocorr(HHSPm,60);
ylabel ('HH Price Autocorrelations')
title ('Henry Hub Spot Price Autocorrelation Function')

subplot(2,1,2);
parcorr(HHSPm,60);
ylabel ('HH Price Partial Autocorrelations')
title ('Henry Hub Spot Price Partial Autocorrelation Function')


% Rate of Returns
figure
subplot(2,1,1);
autocorr(diff(HHSPm));
ylabel ('First Difference Autocorrelations')
title ('Gas Price First Difference Autocorrelation Function')

subplot(2,1,2);
parcorr(diff(HHSPm));
ylabel ('First Difference Partial Autocorrelations')
title ('Gas Price First Difference Partial Autocorrelation Function')

% Squared Rate of Returns
figure
subplot(2,1,1);
autocorr(diff(HHSPm).^2);
ylabel ('Squared First Difference Autocorrelations')
title ('Squared Gas Price First Difference Autocorrelation Function')

subplot(2,1,2);
parcorr(diff(HHSPm).^2);
ylabel ('Squared First Difference Partial Autocorrelations')
title ('Squared Gas Price First Difference Partial Autocorrelation Function')

%% Non-Seanonal difference investigation
% The lower standard deviation is the optimum solution

SD = [];
k = 1:6;
for ii = k
    SD(ii) = std(diff(HHSPm,ii));
end
figure
plot ([0 k], [std(HHSPm) SD], '-.b', 'linewidth', 1.2)
xlabel ('Number of Non-Seasonal Difference')
ylabel ('Standard Deviation')
title ('Standard Deviation of Differenced Series')

%% Stationary standatd tests

% KPSS test
[h1,pValue1,stat1,cValue1,reg1] = kpsstest(HHSPm);
[h2,pValue2,stat2,cValue2,reg2] = kpsstest(diff(HHSPm));

% Augmented Dickey-Fuller test
[h3,pValue3,stat3,cValue3,reg3] = adftest(HHSPm);
[h4,pValue4,stat4,cValue4,reg4] = adftest(diff(HHSPm));

% Augmented Dickey-Fuller test
[h5,pValue5,stat5,cValue5,reg5] = pptest(HHSPm);
[h6,pValue6,stat6,cValue6,reg6] = pptest(diff(HHSPm));

% Display the results
clc
fprintf ('Result Summary for Stationary Tests: \n');
fprintf ('|-----------------------------------------------------------------------------|\n');
fprintf ('| Variable     | Test |  Stat.  | Crit. Value | Lik. Log | Sig. Level |  MSE  |\n');
fprintf ('|-----------------------------------------------------------------------------|\n');
fprintf ('| Spot Price   | KPSS | %7.2f |   %7.4f   | %8.3f |    95%%     | %5.3f |\n', ...
    stat1,cValue1,reg1.LL,reg1.MSE);
fprintf ('|.............................................................................|\n');
fprintf ('| Spot Price   | ADF  | %7.2f |   %7.4f   | %8.3f |    95%%     | %5.3f |\n', ...
    stat3,cValue3,reg3.LL,reg3.MSE);
fprintf ('|.............................................................................|\n');
fprintf ('| Spot Price   | PP   | %7.2f |   %7.4f   | %8.3f |    95%%     | %5.3f |\n', ...
    stat5,cValue5,reg5.LL,reg5.MSE);
fprintf ('|.............................................................................|\n');
fprintf ('| Monthly Ret. | KPSS | %7.2f |   %7.4f   | %8.3f |    95%%     | %5.3f |\n', ...
    stat2,cValue2,reg2.LL,reg2.MSE);
fprintf ('|.............................................................................|\n');
fprintf ('| Monthly Ret. | ADF  | %7.2f |   %7.4f   | %8.3f |    95%%     | %5.3f |\n', ...
    stat4,cValue4,reg4.LL,reg4.MSE);
fprintf ('|.............................................................................|\n');
fprintf ('| Monthly Ret. | PP   | %7.2f |   %7.4f   | %8.3f |    95%%     | %5.3f |\n', ...
    stat6,cValue6,reg6.LL,reg6.MSE);
fprintf ('|-----------------------------------------------------------------------------|\n');

%% Distribution check

figure;
normplot(log(HHSPm))
xlabel ('Log of Natural Gas Price, $/MMBtu')
jbtest(log(HHSPm))


%% Modeling
% ARMA paramter estimation

aic=[];
bic=[];
for ii = 1:4
    switch ii
        case 1
            ARLags = [];
        case 2 
            ARLags = [5];
        case 3 
            ARLags = [5 9];
        case 4
            ARLags = [9];
        case 5
            ARLags = 1:9;
    end
    
    for jj = 1:4
        switch jj
            case 1
                MALags = [];
            case 2 
                MALags = [5];
            case 3 
                MALags = [5 9];
            case 4
                MALags = [9];
            case 5
                MALags = 1:9;
        end
        
        MDL_ARIMA = arima('ARLags', ARLags, 'D', 1,'MALags', MALags);
        [~,~,logL] = estimate(MDL_ARIMA, HHSPm);
        if ii == 1 && jj == 1 
            a = 2;
        elseif ii == 1
            a = max(MALags(:)) + 2;
        elseif jj == 1
            a = max(ARLags(:)) +  2;
        else
            a = max(ARLags(:)) + max(MALags(:)) + 2;
        end
        [aic(ii, jj),bic(ii, jj)] = aicbic(logL, ...
            a ,size(HHSPm,1));
%             size(ARLags,2) + size(MALags,2) + 2 ,size(HHSPm,1));
    end
end

[maic,iaic] = min(aic(:));
[maic_row, maic_col] = ind2sub(size(aic),iaic);
switch maic_row
    case 1
        ARLags = [0];
    case 2 
        ARLags = [5];
    case 3 
        ARLags = [5 9];
    case 4
        ARLags = [9];
    case 5
        ARLags = 1:9;
end
switch maic_col
    case 1
        MALags = [0];
    case 2 
        MALags = [5];
    case 3 
        MALags = [5 9];
    case 4
        MALags = [9];
    case 5
        MALags = 1:9;
end

fprintf('According to AIC results, the optimum lags are:');
display(ARLags)
fprintf('and MA Lags of');
display(MALags)


[mbic,ibic] = min(bic(:));
[mbic_row, mbic_col] = ind2sub(size(bic),ibic);
switch mbic_row
    case 1
        ARLags = [0];
    case 2 
        ARLags = [5];
    case 3 
        ARLags = [5 9];
    case 4
        ARLags = [9];
    case 5
        ARLags = 1:9;
end
switch mbic_col
    case 1
        MALags = [0];
    case 2 
        MALags = [5];
    case 3 
        MALags = [5 9];
    case 4
        MALags = [9];
    case 5
        MALags = 1:9;
end

fprintf('According to AIC results, the optimum lags are:');
display(ARLags)
fprintf('and MA Lags of');
display(MALags)

%% Modeling
% Checking the statistics parameters

MEAHHSP = [];
VARHHSP = [];
for ii = 1: 228
    VARHHSP(ii) = var(HHSPm(1:ii));
    MEANHHSP(ii) = mean(HHSPm(1:ii));
end
figure
subplot(2,1,1);
plot(Dates, VARHHSP, 'linewidth', 1.1);
datetick
xlabel ('Date, year');
ylabel ('Variance')
title ('Variance of HH Spot Price')

subplot(2,1,2);
plot(Dates, MEANHHSP);
datetick
xlabel ('Date, year', 'linewidth', 1.1);
ylabel ('Mean')
title ('Mean of HH Spot Price')

MEAdiffHHSP = [];
VARdiffHHSP = [];
for ii = 1: 227
    VARdiffHHSP(ii) = var(diff(HHSPm(1:ii)));
    MEANdiffHHSP(ii) = mean(diff(HHSPm(1:ii)));
end
figure
subplot(2,1,1);
plot(Dates(2:end), VARdiffHHSP, 'linewidth', 1.1);
datetick
xlabel ('Date, year');
ylabel ('Variance')
title ('Variance of First Difference of HH Spot Price')

subplot(2,1,2);
plot(Dates(2:end), MEANdiffHHSP);
datetick
xlabel ('Date, year', 'linewidth', 1.1);
ylabel ('Mean')
title ('Mean of First Difference of HH Spot Price')


%% Modeling

% ARIMA-GARCH
ModelVar = HHSPm;
ValidationSteps = 48;
ARLags = [5];
MALags = [9];


% Ljung-Box Q-test

Mdl = arima('ARLags', ARLags, 'D', 1,'MALags', MALags);
EstMdl = estimate(Mdl,HHSPm);
res = infer(EstMdl,HHSPm);
stdRes = res/sqrt(EstMdl.Variance); % Standardized residuals
[h,pValue,stat,cValue] = lbqtest(stdRes,'lags',[5 9])
[h,pValue,stat,cValue] = lbqtest(res.^2)
figure
subplot(2,1,1);
plot(Dates, res.^2, 'linewidth', 1.2)
datetick
xlabel ('Date, years')
ylabel ('Squared Residuals')
title ('Squared Residuals during Time')
subplot(2,1,2);
plot(Dates, res, 'linewidth', 1.2)
datetick
xlabel ('Date, years')
ylabel ('Residuals')
title ('Residuals during Time')


% ARCH test
[h,p,fStat,crit] = archtest(res, 'lags', 1:2)
pause

% Garch Model

ToEstMdl = garch(1,1);
EstMdl = estimate(ToEstMdl,diff(HHSPm));

MDL_ARIMA = arima('ARLags', ARLags, 'D', 1,'MALags', MALags, ...
    'Variance', EstMdl);
[Fit,EstParamCov,logL] = estimate(MDL_ARIMA, ModelVar);
SE = sqrt(diag(EstParamCov));  % SE is standard error for each parameter in the model

% Back testing
[YBT, BTMSE] = ModelBackTest(MDL_ARIMA, ModelVar, 'ARIMA');

[YBTf, BTMSEf] = forecast(Fit, ValidationSteps, ...
    'Y0', ModelVar(1:end-ValidationSteps));

[Yf, YMSEf] = forecast(Fit, 12, 'Y0', ModelVar);
zValue = norminv([0.05/2 1-0.05/2],0,1);
Yflower = Yf + zValue(1) * sqrt(YMSEf);
Yfupper = Yf + zValue(2) * sqrt(YMSEf);
Y = [Yflower Yf Yfupper];

%%
Residuals = YBTf - ModelVar(end-ValidationSteps+1:end);
figure
subplot(2,1,1);
autocorr(Residuals);
subplot(2,1,2);
parcorr(Residuals);

figure
plot(Dates,ModelVar, 'linewidth',1.1)
hold on
plot(Dates(end-ValidationSteps+1:end), YBTf, ':r', 'linewidth',1.1)
xlabel ('Date, years')
ylabel ('Natural Gas Price, $/MMBtu')
legend ('Historical Price', 'Back Testing')
datetick
hold off


Residuals = (YBT' - HHSPm)./HHSPm .* 100;
figure
subplot(2,1,1);
plot(Dates,ModelVar, 'linewidth',1.1)
hold on
plot(Dates, YBT, ':r', 'linewidth',1.1)
xlabel ('Date, years')
ylabel ('Natural Gas Price, $/MMBtu')
legend ('Historical Price', 'Back Testing')
title ('Validation of Mdel with Actual Data')
datetick
hold off
subplot(2,1,2);
plot(Dates,Residuals, 'linewidth',1.1)
xlabel ('Date, years')
ylabel ('Residual Value, %')
title ('The Residuale Values of Model and Actual Data')
datetick


figure
DatesFuture = Dates(end);
for i = 1:12
    DatesFuture = [DatesFuture; DatesFuture(end)+30.5];
end
DatesFuture(1) = [];
plot(Dates,ModelVar, 'linewidth',1.1)
hold on
plot(DatesFuture, Yfupper, ':r', 'linewidth',1.1)
plot(DatesFuture, Yf, 'r', 'linewidth',1.1)
plot(DatesFuture, Yflower, ':r', 'linewidth',1.1)
xlabel ('Date, years')
ylabel ('Natural Gas Price, $/MMBtu')
legend ('Historical Price', '95% Higher Price', ...
    'Forecasted Price', '95% Lower Price')
datetick
hold off

        
        
        
