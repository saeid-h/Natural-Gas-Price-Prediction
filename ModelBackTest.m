function [YBT, BTMSE] = ModelBackTest(MDL, TimeSeries, ModelType)

% Find the data size
n = size(TimeSeries,1);
m = size(TimeSeries,2);
n = max(m,n);

switch ModelType
    case 'ARIMA'
    % Estimate the minimum data required to establish the model and forecast
        lags = MDL.P + MDL.Q + MDL.D;
        if lags < 24
            lags = 24;
        end

        YBT(1:lags) = NaN;

        h = waitbar(1/n, ...
            'Model back testing in progress. Please wait ...');
        for ii = lags:n-1
            Fit = estimate(MDL, TimeSeries(1:ii), 'Display', 'off');
            [YBT(ii+1), BTMSE(ii+1)] = forecast(Fit, 1, 'Y0', TimeSeries(1:ii));
            waitbar(ii/n, h);
        end

        close (h);
        
    case 'SDE'
        h = waitbar(1/n, ...
            'Model back testing in progress. Please wait ...');
        YBT(1:n, 1:1000) = NaN;
        YSim(1,1:1000) = TimeSeries(1);
        for ii = 1:n-1
             MDL.StartState = TimeSeries(ii);
            [YSim_ YTSim_] = simulate(MDL, 1, 'nTrials',...
                1000,'DeltaTime', 1);
            YSim(ii+1,:) = YSim_(2,:);
%             YTSim(ii) = YTSim_(2);
            waitbar(ii/n, h);
        end

        close (h);
        
        YBT = YSim;  
        BTMSE = [];

end
