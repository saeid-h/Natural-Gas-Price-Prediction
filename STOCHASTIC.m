%% Initializing

clear all;
close all;


% Model selection part

ModelSel = 'GBM';
% ModelSel = 'HWV';
% ModelSel = 'SDE';
% ModelSel = 'SDEDDO';
% ModelSel = 'SDELD';
% ModelSel = 'CEV';

IsDynamic = 1;


% Variable preparation
load Variables;
HHSPm = cell2num(HHSP);
if size(HHSPm,1) == 1, HHSPm = HHSPm';, end
ret_HHSP = price2ret(HHSPm);

% SimVar = ret_HHSP;

if IsDynamic 
    ret_HHSP_mean(1:100) = mean(ret_HHSP(1:100));
    ret_HHSP_sigma(1:100) = std(ret_HHSP(1:100));
    for ii = 101:size(ret_HHSP(:))
        ret_HHSP_mean(ii) = mean(ret_HHSP(1:ii));
        ret_HHSP_sigma(ii) = std(ret_HHSP(1:ii));
    end
    expReturn = ts2func(ret_HHSP_mean);
    expSigma = ts2func(ret_HHSP_sigma);
else
    expReturn = mean(ret_HHSP);
    expSigma = std(ret_HHSP);
end
sigmaConst = std(ret_HHSP);
expReturnConst = mean(ret_HHSP);
    
% Correlation = corrcoef(ret_HHSP);
StartState = HHSPm(end);
t = 0;
X = StartState;
F = @(t,X) expReturnConst * X;
G = @(t,X) X * sigmaConst;

dt = 1;
NTrials = 1000;
years = 2;
ann = 12;
NSteps = years .* ann;


%% SDE Modeling

% Model parameter settings
switch ModelSel
    case 'GBM'
        MDL = gbm(expReturn, expSigma, 'StartState', StartState);
    case 'HWV'
        regressors = [ones(length(HHSPm)-1,1) HHSPm(1:end-1)];
        [Coeffs, intervals, residuals] = regress(diff(HHSPm), regressors);
        Speed = - Coeffs(2) / dt;
        Level = - Coeffs(1) / Coeffs(2);
        Sigma = std(residuals) / sqrt(dt);
        MDL = hwv(Speed, Level, expSigma, 'StartState', StartState);
    case 'SDE'
        MDL = sde(F, G, 'StartState', StartState);
    case 'SDELD'
        MDL = sdeld(expReturnConst/2, expReturn/2, ...
            1, expSigma,'StartState', StartState);      
    case 'CEV'
        MDL = cev(expReturn, 0.5, expSigma, 'StartState', StartState);
    case 'SDEDDO'
        F = drift(0, expReturn)
        G = diffusion(1, expSigma)
        MDL = sdeddo(F, G, 'StartState', StartState);        
end

%% Simulation process

% XSim = simulate(MDL, NSteps, 'nTrials', NTrials, 'DeltaTime', dt);
rng(142857,'twister')
[XSim TSim] = simulate(MDL, NSteps, 'nTrials',NTrials,'DeltaTime', dt);
% [XSim TSim] = simByEuler(MDL, NSteps, 'DeltaTime', dt);
% [XSim TSim] = simBySolution(MDL, NSteps, 'DeltaTime', dt);
XSim = squeeze(XSim);


%% Model Back Testing

[YBT, BTMSE] = ModelBackTest(MDL, HHSPm, 'SDE');
YBT = mean(YBT');


%% Preparation for plotting

DatesNew = Dates(end);
for i = 1:size(TSim,1)-1
    DatesNew = [DatesNew DatesNew(end)+30.5];
end

% Price_Paths = NGHH * ones(1,size(XSim,2));
% Price_Paths = [Price_Paths; XSim];

[muhat,sigmahat,muci,sigmaci] = normfit(log(XSim'),0.05);
Price_Forecasted = exp( [muci(1,:)' muhat' muci(2,:)'] );

% FitMu = [];
% FitSigma = [];
% FitMuLow = [];
% FitMuHigh = [];
% for ii = 1:size(TSim,1)
%     [parmhat,parmci] = lognfit(XSim(ii,:),0.01);
%     FitMu(ii) = parmhat(1);
%     FitSigma(ii) = parmhat(2);
%     FitMuLow(ii) = parmci(1, 1);
%     FitMuHigh(ii) = parmci(2, 1);
% end
% FitMu = exp(FitMu);
% FitSigma = exp(FitSigma);
% FitMuLow = exp(FitMuLow);
% FitMuHigh = exp(FitMuHigh);
% 
% Price3 = [FitMuLow' FitMu' FitMuHigh'];

%% Plotting

% Back test plot
Residuals = (YBT' - HHSPm)./HHSPm .* 100;
figure
subplot(2,1,1);
plot(Dates,HHSPm, 'linewidth',1.1)
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
ylabel ('Residual Value, ratio')
title ('The Residuale Values of Model and Actual Data')
datetick

% Forecast plot
figure
plot (Dates(150:end), HHSPm(150:end),'LineWidth',1.2);
hold on
plot(DatesNew, Price_Forecasted(:,1),':r','LineWidth',1.2);
plot(DatesNew, Price_Forecasted(:,2),'r','LineWidth',1.2);
plot(DatesNew, Price_Forecasted(:,3),':r','LineWidth',1.2);
plot(DatesNew, XSim(:,1),'k');
title (['Stochastic Process Model (' ModelSel ')'])
xlabel ('Date, years')
ylabel ('Natural Gas Price, $/MMBtu')
legend ('Historical Price', '95% Lower Price', ...
    'Forcasted Price', '95% Lower Price', 'One Possible Path')
datetick

hold off


% Histograms
figure;
jj = 0;
for ii = [1 6 12 24];
    jj = jj + 1;
    plottingVariable = real(XSim(ii+1,:));
    subplot(2, 2, jj);
    h = histogram(plottingVariable,20, 'Normalization','probability');
    if ii == 1 
        stepsahead = ' step ahead'; 
    else
        stepsahead = ' steps ahead';
    end
    xlabel (['Gas price in next ' num2str(ii) stepsahead ', $/MMBtu']);
    ylabel ('Probability');
    title (['Gas price probability distribution in ' num2str(ii)...
        stepsahead])
    muPVlog = mean(log(plottingVariable));
    sigPVlog = std(log(plottingVariable));
    x = min(plottingVariable):0.01:max(plottingVariable);
    normlog = lognpdf(x,muPVlog,sigPVlog);
    normlog = normlog / max(normlog) * max(h.Values);
    hold on
    plot(x,normlog,'k','LineWidth',2)
end

