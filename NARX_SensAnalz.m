test4NARX;

eXoVar_base = eXoVar;
NARX;
T = tonndata(HHSPm,true,false);
X = tonndata(eXoVar,true,false);
[x,xi,ai,t] = preparets(net,X,{},T);
y = myNARXFunction(x,xi,ai);
 

y_base = cell2num(y);
MSESA = [];

for ii = 1:size(eXoVar_base,1)
    
    eXoVar =  eXoVar_base;
    figure
    hold on

    eXoVar(ii,:) = eXoVar_base(ii,:) * 0.5;
    X = tonndata(eXoVar,true,false);
    [x,xi,ai,t] = preparets(net,X,{},T);
    y = myNARXFunction(x,xi,ai);
    ySA = cell2num(y);
    plot(Dates(10:end), ySA);
    MSESA(ii, 1) = nansum((y_base - ySA).^2)./(219-48+9);
    SADY(ii, 1) = nanmean((y_base(41:end) - ySA(41:end)) ./ ...
        (-0.5 .* eXoVar_base(ii,50:end))); 
    
    eXoVar(ii,:) = eXoVar_base(ii,:) * 0.8;
    X = tonndata(eXoVar,true,false);
    [x,xi,ai,t] = preparets(net,X,{},T);
    y = myNARXFunction(x,xi,ai);
    ySA = cell2num(y);
    plot(Dates(10:end), ySA);
    MSESA(ii, 2) = nansum((y_base - ySA).^2)./(219-48+9);
    SADY(ii, 1) = nanmean((y_base(41:end) - ySA(41:end)) ./ ...
        (-0.2 .* eXoVar_base(ii,50:end)));
    
    plot(Dates(10:end), y_base);
    datetick
        
   
    eXoVar(ii,:) = eXoVar_base(ii,:) * 1.5;
    X = tonndata(eXoVar,true,false);
    [x,xi,ai,t] = preparets(net,X,{},T);
    y = myNARXFunction(x,xi,ai);
    ySA = cell2num(y);
    plot(Dates(10:end), ySA);
    MSESA(ii, 3) = nansum((y_base - ySA).^2)./(219-48+9);
    SADY(ii, 1) = nanmean((y_base(41:end) - ySA(41:end)) ./ ...
        (0.5 .* eXoVar_base(ii,50:end)));
    
    eXoVar(ii,:) = eXoVar_base(ii,:) * 2;
    X = tonndata(eXoVar,true,false);
    [x,xi,ai,t] = preparets(net,X,{},T);
    y = myNARXFunction(x,xi,ai);
    ySA = cell2num(y);
    plot(Dates(10:end), ySA);
    MSESA(ii, 4) = nansum((y_base - ySA).^2)./(219-48+9);
    SADY(ii, 1) = nanmean((y_base(41:end) - ySA(41:end)) ./ ...
        (1 .* eXoVar_base(ii,50:end)));
    
    legend ('0.5 times of Base Case', '0.8 times of Base Case', ...
    'Base Case', '1.5 times of Base Case', '2 times of Base Case', ...
    'Location','northwest')
    xlabel('Date, year')
    ylabel ('Natural Gas Price, $/MMBtu')
end



