%[text] # TP 3
clear;
fn='StripCouponYield.xlsx';       
opts = detectImportOptions(fn);
opts.DataRange='A2';
opts.VariableNamesRange='A1:DB1';
% opts.VariableNamingRule='preserve';
yields = readtable(fn,opts,"Sheet","yields"); %[output:57be089b]
maturity = readtable(fn,opts,"Sheet","maturity"); %[output:87b6115c]

% rate_type = "continuous";
rate_type = "annual";


function price = CalculatePrice(rate_type,yield,maturity)
    if rate_type == "continuous"
        price = exp(-(yield./100).*maturity);
    else
        price = 1./(1 + yield./100).^maturity;
    end
end


yields.Properties.VariableNames = maturity.Properties.VariableNames;


yields_jeudi = yields(weekday(yields.Date)==5,:);
maturity_jeudi = maturity(weekday(maturity.Date)==5,:);


result_table = yields_jeudi(:,"Date");

yield_cible = yields_jeudi{:,"x15_Sep_2020"};
maturity_cible = maturity_jeudi{:,"x15_Sep_2020"};
convexity_cible = maturity_cible.^2;
price_cible = CalculatePrice(rate_type,yield_cible,maturity_cible);



yield_short = yields_jeudi{:,"x01_Jun_2017"};
maturity_short = maturity_jeudi{:,"x01_Jun_2017"};
convexity_short = maturity_short.^2;
price_short = CalculatePrice(rate_type,yield_short,maturity_short);



long_type = 1;

if long_type == 1
    choice = "x01_Jun_2025";
else
    choice = "x01_Jun_2025_1";
end
yield_long = yields_jeudi{:,choice};
maturity_long = maturity_jeudi{:,choice};
convexity_long = maturity_long.^2;
price_long = CalculatePrice(rate_type,yield_long,maturity_long);




%======================= IMMUNISATION DYNAMIQUE 1 =======================
quantite1 = (-maturity_cible.*price_cible-maturity_short.*price_short)./(maturity_long.*price_long);

current_pv = price_cible+price_short+quantite1.*price_long;
next_pv = price_cible(2:end)+price_short(2:end)+quantite1(1:end-1).*price_long(2:end);
diff = next_pv - current_pv(1:end-1);


result_table.q = quantite1;
result_table.PV1_current = current_pv;
result_table.PV1_next = [next_pv;nan(1)];
result_table.Difference_PV1 = [diff;nan(1)];


%======================= IMMUNISATION DYNAMIQUE 2 =======================
quantite1 = -(price_cible./price_short).*((maturity_cible.*convexity_long-convexity_cible.*maturity_long)./(maturity_short.*convexity_long-convexity_short.*maturity_long));
quantite2 = -(price_cible./price_long).*((maturity_cible.*convexity_short-convexity_cible.*maturity_short)./(maturity_long.*convexity_short-convexity_long.*maturity_short));

current_pv = price_cible+quantite1.*price_short+quantite2.*price_long;
next_pv = price_cible(2:end)+quantite1(1:end-1).*price_short(2:end)+quantite2(1:end-1).*price_long(2:end);
diff = next_pv - current_pv(1:end-1);



%======================= TABLE DE RESULTATS =======================
result_table.k1 = quantite1;
result_table.k2 = quantite2;
result_table.PV2_current = current_pv;
result_table.PV2_next = [next_pv;nan(1)];
result_table.Difference_PV2 = [diff;nan(1)];

result_table{:,2:end} = round(result_table{:,2:end},6) %[output:8a35ea06]


%======================= RMSE =======================
RMSE_V1 = sqrt(sum(result_table.Difference_PV1(1:end-1).^2)/length(result_table.Difference_PV1(1:end-1))) %[output:16f5191f]
RMSE_V2 = sqrt(sum(result_table.Difference_PV2(1:end-1).^2)/length(result_table.Difference_PV2(1:end-1))) %[output:452b07bf]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40.7}
%---
%[output:57be089b]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Column headers from the file were modified to make them valid MATLAB identifiers before creating variable names for the table. The original column headers are saved in the VariableDescriptions property.\nSet 'VariableNamingRule' to 'preserve' to use the original column headers as table variable names."}}
%---
%[output:87b6115c]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Column headers from the file were modified to make them valid MATLAB identifiers before creating variable names for the table. The original column headers are saved in the VariableDescriptions property.\nSet 'VariableNamingRule' to 'preserve' to use the original column headers as table variable names."}}
%---
%[output:8a35ea06]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Date","q","PV1_current","PV1_next","Difference_PV1","k1","k2","PV2_current","PV2_next","Difference_PV2"],"columns":10,"dataTypes":["datetime","double","double","double","double","double","double","double","double","double"],"header":"52×10 table","name":"result_table","rows":52,"type":"table","value":[["08-Jan-2015","-0.8903","1.1669","1.1638","-0.0031","-1.3175","-0.2531","-0.5721","-0.5712","9.2900e-04"],["15-Jan-2015","-0.8739","1.1776","1.1878","0.0102","-1.3349","-0.2495","-0.5852","-0.5862","-9.2400e-04"],["22-Jan-2015","-0.8730","1.1886","1.1866","-0.0020","-1.3453","-0.2498","-0.5967","-0.5953","0.0014"],["29-Jan-2015","-0.8615","1.1964","1.1968","3.7500e-04","-1.3602","-0.2473","-0.6080","-0.6082","-2.5500e-04"],["05-Feb-2015","-0.8580","1.1998","1.2006","8.5500e-04","-1.3675","-0.2467","-0.6149","-0.6158","-8.5700e-04"],["12-Feb-2015","-0.8568","1.2017","1.2036","0.0020","-1.3724","-0.2467","-0.6205","-0.6215","-0.0010"],["19-Feb-2015","-0.8580","1.2027","1.1968","-0.0058","-1.3756","-0.2472","-0.6252","-0.6222","0.0030"],["26-Feb-2015","-0.8486","1.2048","1.2068","0.0020","-1.3888","-0.2452","-0.6335","-0.6339","-4.4300e-04"],["05-Mar-2015","-0.8550","1.2015","1.2031","0.0016","-1.3883","-0.2470","-0.6349","-0.6337","0.0012"],["12-Mar-2015","-0.8516","1.2060","1.2022","-0.0038","-1.3989","-0.2466","-0.6438","-0.6432","6.1000e-04"],["19-Mar-2015","-0.8388","1.2132","1.2128","-3.8400e-04","-1.4141","-0.2436","-0.6556","-0.6566","-9.9100e-04"],["26-Mar-2015","-0.8411","1.2109","1.2102","-6.7800e-04","-1.4150","-0.2444","-0.6582","-0.6573","8.5200e-04"],["02-Apr-2015","-0.8322","1.2179","1.2195","0.0015","-1.4294","-0.2425","-0.6699","-0.6706","-6.4100e-04"],["09-Apr-2015","-0.8328","1.2189","1.2163","-0.0026","-1.4341","-0.2429","-0.6756","-0.6751","4.5000e-04"]]}}
%---
%[output:16f5191f]
%   data: {"dataType":"textualVariable","outputData":{"name":"RMSE_V1","value":"0.0029"}}
%---
%[output:452b07bf]
%   data: {"dataType":"textualVariable","outputData":{"name":"RMSE_V2","value":"0.0011"}}
%---
