%% Initializing

IsDynamic = evalin('base', 'IsDynamic');
ModelSel = evalin('base', 'ModelSel');
BackTestFlag = evalin('base', 'BackTestFlag');
ForecastFlag = evalin('base', 'ForecastFlag');
HistogramFlag = evalin('base', 'HistogramFlag');
NSteps = evalin('base', 'NSteps');
Alpha = evalin('base', 'Alpha');

% Variables preparation
load Variables;
HHSPm = cell2num(HHSP);
if size(HHSPm,1) == 1, HHSPm = HHSPm'; end
ret_HHSP = price2ret(HHSPm);

% Define the statistic parameters (Dynamic/Static)
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

% Define static parameter to use 
sigmaConst = std(ret_HHSP);
expReturnConst = mean(ret_HHSP);

% The start points
StartState = HHSPm(end);
t = 0;
X = StartState;
F = @(t,X) expReturnConst * X;
G = @(t,X) X * sigmaConst;

% Define some forecasting parameters
dt = 1;
NTrials = 1000;


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
        MDL = sdeld(expReturnConst/2, expReturnConst/2, ...
            Alpha, expSigma,'StartState', StartState);      
    case 'CEV'
        MDL = cev(expReturn, Alpha, expSigma, 'StartState', StartState);
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

uiwait(msgbox('Model Simulation Completed','Success','modal'));


%% Model Back Testing

if BackTestFlag
    [YBT, BTMSE] = ModelBackTest(MDL, HHSPm, 'SDE');
    YBT = mean(YBT');
    uiwait(msgbox('Model Back Testing Completed','Success','modal'));
    R2 = RSquared (HHSPm', YBT);
end


%% Preparation for plotting

DatesNew = Dates(end);
for i = 1:size(TSim,1)-1
    DatesNew = [DatesNew DatesNew(end)+30.5];
end

[muhat,sigmahat,muci,sigmaci] = normfit(log(XSim'),0.05);
%Price_Forecasted = exp( [muci(1,:)' muhat' muci(2,:)'] );

XSim_sorted = sort(XSim,2);
lowindex = int32(NTrials * .05);
upindex = int32(NTrials * .95);
Price_Forecasted = real([XSim_sorted(:,lowindex)  exp(muhat') ...
    XSim_sorted(:,upindex)]);


%% Plotting

% Back test plot
if BackTestFlag
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
    set(gcf, 'Position', get(0,'Screensize'));
end


% Forecast plot
if (ForecastFlag)
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
    
    set(gcf, 'Position', get(0,'Screensize'));

    hold off
end


% Histograms
if (HistogramFlag)
    figure;
    if NSteps < 6
        n = 1;
        k = 1;
    elseif NSteps < 12
        n = 2;
        k = [1 2 4 NSteps];
    else
        n = 2;
        k = [1 6 12 NSteps];
    end
        
        
    jj = 0;
    for ii = k;
        jj = jj + 1;
        plottingVariable = real(XSim(ii+1,:));
        subplot(n, n, jj);
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
    
    set(gcf, 'Position', get(0,'Screensize'));
    
end

