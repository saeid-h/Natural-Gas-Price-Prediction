%% initializing

load Variables;
HHSPm = cell2num(HHSP);
if size(HHSPm,1) == 1, HHSPm = HHSPm'; end
% ret_HHSP = price2ret(HHSPm);
AutoCorrelationFlag = evalin('base', 'AutoCorrelationFlag');
DifferenceCheckFlag = evalin('base', 'DifferenceCheckFlag');
StationaryTestFlag = evalin('base', 'StationaryTestFlag');
DistributionCheckFlag = evalin('base', 'DistributionCheckFlag');
LBQTestFlag = evalin('base', 'LBQTestFlag');
ARCHTestFlag = evalin('base', 'ARCHTestFlag');
BackTestFlag = evalin('base', 'BackTestFlag');
IsGARCH = evalin('base', 'IsGARCH');
P = evalin('base', 'P');
Q = evalin('base', 'Q');
ARLags = evalin('base', 'ARLags');
MALags = evalin('base', 'MALags');
D = evalin('base', 'D');
PlotFlag = evalin('base', 'PlotFlag');

%% Autocorrelation plots 

% Sopt price
if AutoCorrelationFlag
    figure
    subplot(2,1,1);
    autocorr(HHSPm,60);
    ylabel ('HH Price Autocorrelations')
    title ('Henry Hub Spot Price Autocorrelation Function')

    subplot(2,1,2);
    parcorr(HHSPm,60);
    ylabel ('HH Price Partial Autocorrelations')
    title ('Henry Hub Spot Price Partial Autocorrelation Function')
    
    set(gcf, 'Position', get(0,'Screensize'));

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
    
    set(gcf, 'Position', get(0,'Screensize'));

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
    
    set(gcf, 'Position', get(0,'Screensize'));

end


%% Non-Seanonal difference investigation
% The lower standard deviation is the optimum solution

if DifferenceCheckFlag
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
end

%% Stationary standatd tests

if StationaryTestFlag
    % KPSS test
    [h1,pValue1,stat1,cValue1,reg1] = kpsstest(HHSPm);
    [h2,pValue2,stat2,cValue2,reg2] = kpsstest(diff(HHSPm));

    % Augmented Dickey-Fuller test
    [h3,pValue3,stat3,cValue3,reg3] = adftest(HHSPm);
    [h4,pValue4,stat4,cValue4,reg4] = adftest(diff(HHSPm));
    
    ResultMat (1, 1) = ~h1;
    ResultMat (1, 2) =  h2;
    ResultMat (2, 1) = ~h3;
    ResultMat (2, 2) =  h4; 
    
    Message = ['The KPSS test shows that'];
    if ~h1 
        if ~h3
            Message = [Message ' the time series and the first differen are stationary.'];
        else
            Message = [Message ' the time series is stationary and the first differen is not.'];
        end
    elseif ~h3
       Message = [Message ' the time series is not stationary but the first differen is.'];
    else
       Message = [Message ' the time series and the first differen are not stationary.']; 
    end
    
    Message = [Message 'The ADF test shows that'];
    
    if h2 
        if h4
            Message = [Message ' the time series and the first differen are stationary.'];
        else
            Message = [Message ' the time series is stationary and the first differen is not.'];
        end
    elseif h4
       Message = [Message ' the time series is not stationary but the first differen is.'];
    else
       Message = [Message ' the time series and the first differen are not stationary.']; 
    end
    
    uiwait(msgbox(Message,'Stationary Test Results','modal'));

end

%% Distribution check

if DistributionCheckFlag
    figure;
    normplot(log(HHSPm))
    xlabel ('Log of Natural Gas Price, $/MMBtu')
    jbtest(log(HHSPm))
end


%% Modeling

% ARIMA-GARCH
ModelVar = HHSPm;
ValidationSteps = 48;

% Ljung-Box Q-test
if LBQTestFlag
    Mdl = arima('ARLags', ARLags, 'D', D,'MALags', MALags);
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
end

% ARCH test
if ARCHTestFlag
    [h,p,fStat,crit] = archtest(res, 'lags', 1:2)
    Message = ['The ARCH effect test (Engle test) shows that '];
    if h(1)
        if h(2)
            Message = [Message 'ARCH/GARCH effect is detected for both first and second lags.'];
        else
            Message = [Message 'ARCH/GARCH effect is detected for first lag.'];
        end
    elseif h(2)
        Message = [Message 'ARCH/GARCH effect is detected for second lag.'];
    else
       Message = [Message 'ARCH/GARCH effect is not detected.'];
    end
    uiwait(msgbox(Message,'ARCH Test Results','modal'));
end

% Garch Model
if IsGARCH
    ToEstMdl = garch(P,Q);
    EstMdl = estimate(ToEstMdl,diff(HHSPm));
    MDL_ARIMA = arima('ARLags', ARLags, 'D', 1,'MALags', MALags, ...
        'Variance', EstMdl);
else
    MDL_ARIMA = arima('ARLags', ARLags, 'D', 1,'MALags', MALags);
end

[Fit,EstParamCov,logL] = estimate(MDL_ARIMA, ModelVar);
SE = sqrt(diag(EstParamCov));  % SE is standard error for each parameter in the model


% Back testing
if BackTestFlag
    [YBT, BTMSE] = ModelBackTest(MDL_ARIMA, ModelVar, 'ARIMA');
    R2 = RSquared (HHSPm(25:end)', YBT(25:end));
end

[YBTf, BTMSEf] = forecast(Fit, ValidationSteps, ...
    'Y0', ModelVar(1:end-ValidationSteps));

[Yf, YMSEf] = forecast(Fit, 12, 'Y0', ModelVar);

zValue = norminv([0.05/2 1-0.05/2],0,1);
% zValue = logninv([0.05/2 1-0.05/2],mean(Yf),std(Yf));
Yflower = (Yf) + zValue(1) * sqrt((YMSEf));
Yfupper = (Yf) + zValue(2) * sqrt((YMSEf));
Y = [Yflower Yf Yfupper];

%%
if PlotFlag
    figure
    plot(Dates,ModelVar, 'linewidth',1.1)
    hold on
    plot(Dates(end-ValidationSteps+1:end), YBTf, ':r', 'linewidth',1.1)
    xlabel ('Date, years')
    ylabel ('Natural Gas Price, $/MMBtu')
    legend ('Historical Price', 'Validation')
    datetick
    hold off

    if BackTestFlag
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
    end


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
end

        
        
        
