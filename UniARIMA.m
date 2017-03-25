%function [Fit YMSE] = UniARIMA(P,D,Q)
function [Fit YMSE] = UniARIMA(ARLags,MALags,SMALags,P,D,Q)
%% Initializing
%clear all
load Variables;
load TempVariables;
ret_NGHH = price2ret(NGHH);
%ret_NGHH = F2;

n = size(NGHH(:));
n = max(n(:));
% P = 3;
% D = 0;
% Q = 46;
Seasonality = 12;
% MALags = 1;
% SMALags = 1;
% ARLags = 1;

% NStepsValidation = 24;
% NStepsModel = 0;
% NStepsFuture = 12;
% prob_lvl = 0.05;


%% Test Section 

Residual = ret_NGHH - mean(ret_NGHH);
%[h,pValue,stat,cValue] = archtest(ret_NGHH,[1:20], 0.05);


NumPaths = 1000;

ToEstMdl = garch(P,Q);
EstMdl = estimate(ToEstMdl,ret_NGHH(1:end-NStepsModel));

% MDL = arima('D',D,'Seasonality',Seasonality,'ARLags',ARLags,...
%     'MALags',MALags, 'SMALags',SMALags,'Variance',EstMdl);
MDL = arima('Seasonality',Seasonality,'D',D,'ARLags',ARLags,'MALags',MALags);
% MDL = arima('ARLags',ARLags,'MALags',MALags, 'Variance',EstMdl);
[Fit,EstParamCov,logL] = estimate(MDL, ret_NGHH(1:end-NStepsModel));

[YValidation, YMSE] = forecast(Fit, NStepsValidation, ...
    'Y0', ret_NGHH(1:end-NStepsValidation));
[YFuture, YMSEFuture] = forecast(Fit, NStepsFuture, 'Y0', ret_NGHH);

% [YSim] = simulate(Fit,NStepsValidation, ...
%     'Y0',ret_NGHH(1:end-NStepsValidation),'NumPaths',NumPaths);

alphaValue = (prob_lvl) ./2;
zValue = norminv([alphaValue 1-alphaValue],0,1);
Ylower = YValidation + zValue(1) * sqrt(YMSE);
Yupper = YValidation + zValue(2) * sqrt(YMSE);
Y = [Ylower YValidation Yupper]; 

%Price1 = ret_NGHH(1:end-NSteps) * ones(1,NumPaths);
%for i = 1:size(YSim,1)
%    Price1 = [Price1; Price1(end,:).*(1+YSim(i,:))];
%end

DatesModel = Dates(1:end-NStepsValidation);
DatesValidation = Dates(end-NStepsValidation:end);

PriceModel = NGHH(1:end-NStepsValidation);
PriceValidationReal = NGHH(end-NStepsValidation:end);

PriceValidationCalculated = ...
    [PriceModel(end) PriceModel(end) PriceModel(end)];
for i = 1:NStepsValidation
    PriceValidationCalculated = ...
        [PriceValidationCalculated; ...
        PriceValidationCalculated(end,:).*(1+Y(i,:))];
end
%PriceValidationCalculated(1,:) = [];


DatesFuture = Dates(end);
for i = 1:NStepsFuture
    DatesFuture = [DatesFuture; DatesFuture(end)+30.5];
end
%DatesFuture(1) = [];
PriceFuture = NGHH(end);
for i = 1:NStepsFuture
    PriceFuture = ...
        [PriceFuture; PriceFuture(end).*(1+YFuture(i))];
end

%plot(Y);
%a

%[muhat,sigmahat,muci,sigmaci] = normfit(log(Price1(n+1:end,:)'),prob_lvl);
%Price3 = exp([muci(2,:)' muhat' muci(1,:)']);
%Price3 = real(Price3);

%% Validate the model - Back testing

%Residual = [];
%for i = 1:n-14
%    [E V] = infer(Fit, ret_NGHH(1:i+12,1));
    %Residual = [Residual; E];
%    MSE(i) = sum(E.^2)./size(ret_NGHH(1:i+12,1),1);
%end
%plot (MSE)

%% Plotting
%if n > 30 
%    m = 30;
%else 
%    m = n;
%end

%plot (Dates(end-m-NStepsValidation:end-NStepsValidation), NGHH(end-m-NStepsValidation:end-NStepsValidation));
plot(DatesModel, PriceModel);
hold on
plot(DatesValidation, PriceValidationReal);
plot(DatesValidation, PriceValidationCalculated(:,2));
plot(DatesFuture, PriceFuture);

%plot(DatesModel, Price3);
title (['Univariate Autoregression Model (ARIMA)'])
xlabel ('Date, years')
ylabel ('Natural Gas Price, $/MMBtu')
%legend ('Historical Price', ...
%    [num2str(100*(1-prob_lvl),'%4.0f') '% Higher Price'], ...
%    'Forcasted Price', [num2str(100*(1-prob_lvl),'%4.0f') '% Lower Price'])
legend ('Historical Price', ...
    'Validation Price' , 'Forecasted Price', 'Price in Future')
datetick
hold off

%% Ternimation section

save TempVariables.mat NStepsValidation NStepsFuture ...
    NStepsModel prob_lvl '-append'

end