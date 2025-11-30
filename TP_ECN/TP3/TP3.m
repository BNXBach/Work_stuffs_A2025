%[text] # TP 3
clear;
fn='StripCouponYield.xlsx';        % using a fully-qualified filename here would be good practice
opts = detectImportOptions(fn);
opts.DataRange='A2';
opts.VariableNamesRange='A1:DB1';
% opts.VariableNamingRule='preserve';
yields = readtable(fn,opts,"Sheet","yields"); %[output:9479d978]
maturity = readtable(fn,opts,"Sheet","maturity"); %[output:86da0082]

yields.Properties.VariableNames = maturity.Properties.VariableNames;


yields_jeudi = yields(weekday(yields.Date)==5,:);
maturity_jeudi = maturity(weekday(maturity.Date)==5,:);


result_table = yields_jeudi(:,"Date");

yield_cible = yields_jeudi{:,"x15_Sep_2020"};
maturity_cible = maturity_jeudi{:,"x15_Sep_2020"} %[output:7154cc72]
convexity_cible = maturity_cible.^2;
price_cible_annual = 1./(1+yield_cible./100).^maturity_cible;



yield_short = yields_jeudi{:,"x01_Jun_2017"};
maturity_short = maturity_jeudi{:,"x01_Jun_2017"} %[output:302efc77]
convexity_short = maturity_short.^2;
price_short_annual = 1./(1+yield_short./100).^maturity_short  %[output:605e0300]
price_short_continuous = exp(-(yield_short./100).*maturity_short);




yield_long1 = yields_jeudi{:,"x01_Jun_2025"};
maturity_long1 = maturity_jeudi{:,"x01_Jun_2025"} %[output:4af00ff9]
convexity_long1 = maturity_long1.^2;
price_long1_annual = 1./(1+yield_long1./100).^maturity_long1  %[output:7c69ff20]
price_long1_continuous = exp(-(yield_long1./100).*maturity_long1);





yield_long2 = yields_jeudi{:,"x01_Jun_2025_1"};
maturity_long2 = maturity_jeudi{:,"x01_Jun_2025_1"};
price_long2_annual = 1./(1+yield_long2./100).^maturity_long2 ;
price_long2_continuous = exp(-(yield_long2./100).*maturity_long2);




quantite1 = (-maturity_cible.*price_cible_annual-maturity_short.*price_short_annual)./(maturity_long1.*price_long1_annual) %[output:911df110]

current_pv = price_cible_annual+price_short_annual+quantite1.*price_long1_annual %[output:2498f09d]
next_pv = price_cible_annual(2:end)+price_short_annual(2:end)+quantite1(1:end-1).*price_long1_annual(2:end) %[output:3aa834ce]
diff = next_pv - current_pv(1:end-1) %[output:9fe7797c]


result_table.q = quantite1;
result_table.PV1_current = current_pv;
result_table.PV1_next = [next_pv;nan(1)];
result_table.Difference_PV1 = [diff;nan(1)];

quantite1 = -(price_cible_annual./price_short_annual).*((maturity_cible.*convexity_long1-convexity_cible.*maturity_long1)./(maturity_short.*convexity_long1-convexity_short.*maturity_long1)) %[output:1eb20f1f]
quantite2 = -(price_cible_annual./price_long1_annual).*((maturity_cible.*convexity_short-convexity_cible.*maturity_short)./(maturity_long1.*convexity_short-convexity_long1.*maturity_short)) %[output:5965abc5]

current_pv = price_cible_annual+quantite1.*price_short_annual+quantite2.*price_long1_annual %[output:80e1a80e]
next_pv = price_cible_annual(2:end)+quantite1(1:end-1).*price_short_annual(2:end)+quantite2(1:end-1).*price_long1_annual(2:end) %[output:9155ef86]
diff = next_pv - current_pv(1:end-1) %[output:5088e0fd]

result_table.k1 = quantite1;
result_table.k2 = quantite2;
result_table.PV2_current = current_pv;
result_table.PV2_next = [next_pv;nan(1)];
result_table.Difference_PV2 = [diff;nan(1)] %[output:36f9cca1]

result_table{:,2:end} = round(result_table{:,2:end},6) %[output:79939911]

sqrt(sum(result_table.Difference_PV1(1:end-1).^2)/length(result_table.Difference_PV1(1:end-1))) %[output:61a64798]
sqrt(sum(result_table.Difference_PV2(1:end-1).^2)/length(result_table.Difference_PV2(1:end-1))) %[output:4ee75088]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40.7}
%---
%[output:9479d978]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Column headers from the file were modified to make them valid MATLAB identifiers before creating variable names for the table. The original column headers are saved in the VariableDescriptions property.\nSet 'VariableNamingRule' to 'preserve' to use the original column headers as table variable names."}}
%---
%[output:86da0082]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Column headers from the file were modified to make them valid MATLAB identifiers before creating variable names for the table. The original column headers are saved in the VariableDescriptions property.\nSet 'VariableNamingRule' to 'preserve' to use the original column headers as table variable names."}}
%---
%[output:7154cc72]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"maturity_cible","rows":52,"type":"double","value":[["5.7694"],["5.7500"],["5.7306"],["5.7111"],["5.6917"],["5.6722"],["5.6528"],["5.6333"],["5.6139"],["5.5944"],["5.5750"],["5.5556"],["5.5361"],["5.5167"],["5.4972"]]}}
%---
%[output:302efc77]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"maturity_short","rows":52,"type":"double","value":[["2.4306"],["2.4111"],["2.3917"],["2.3722"],["2.3528"],["2.3333"],["2.3139"],["2.2944"],["2.2750"],["2.2556"],["2.2361"],["2.2167"],["2.1972"],["2.1778"],["2.1583"]]}}
%---
%[output:605e0300]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"price_short_annual","rows":52,"type":"double","value":[["0.9751"],["0.9793"],["0.9855"],["0.9879"],["0.9887"],["0.9889"],["0.9888"],["0.9871"],["0.9844"],["0.9854"],["0.9874"],["0.9853"],["0.9874"],["0.9871"],["0.9858"]]}}
%---
%[output:4af00ff9]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"maturity_long1","rows":52,"type":"double","value":[["10.5472"],["10.5278"],["10.5083"],["10.4889"],["10.4694"],["10.4500"],["10.4306"],["10.4111"],["10.3917"],["10.3722"],["10.3528"],["10.3333"],["10.3139"],["10.2944"],["10.2750"]]}}
%---
%[output:7c69ff20]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"price_long1_annual","rows":52,"type":"double","value":[["0.8173"],["0.8387"],["0.8442"],["0.8587"],["0.8605"],["0.8585"],["0.8531"],["0.8611"],["0.8466"],["0.8496"],["0.8650"],["0.8554"],["0.8666"],["0.8616"],["0.8616"]]}}
%---
%[output:911df110]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"quantite1","rows":52,"type":"double","value":[["-0.8903"],["-0.8739"],["-0.8730"],["-0.8615"],["-0.8580"],["-0.8568"],["-0.8580"],["-0.8486"],["-0.8550"],["-0.8516"],["-0.8388"],["-0.8411"],["-0.8322"],["-0.8328"],["-0.8290"]]}}
%---
%[output:2498f09d]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"current_pv","rows":52,"type":"double","value":[["1.1669"],["1.1776"],["1.1886"],["1.1964"],["1.1998"],["1.2017"],["1.2027"],["1.2048"],["1.2015"],["1.2060"],["1.2132"],["1.2109"],["1.2179"],["1.2189"],["1.2196"]]}}
%---
%[output:3aa834ce]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"next_pv","rows":51,"type":"double","value":[["1.1638"],["1.1878"],["1.1866"],["1.1968"],["1.2006"],["1.2036"],["1.1968"],["1.2068"],["1.2031"],["1.2022"],["1.2128"],["1.2102"],["1.2195"],["1.2163"],["1.2208"]]}}
%---
%[output:9fe7797c]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"diff","rows":51,"type":"double","value":[["-0.0031"],["0.0102"],["-0.0020"],["0.0004"],["0.0009"],["0.0020"],["-0.0058"],["0.0020"],["0.0016"],["-0.0038"],["-0.0004"],["-0.0007"],["0.0015"],["-0.0026"],["0.0012"]]}}
%---
%[output:1eb20f1f]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"quantite1","rows":52,"type":"double","value":[["-1.3175"],["-1.3349"],["-1.3453"],["-1.3602"],["-1.3675"],["-1.3724"],["-1.3756"],["-1.3888"],["-1.3883"],["-1.3989"],["-1.4141"],["-1.4150"],["-1.4294"],["-1.4341"],["-1.4417"]]}}
%---
%[output:5965abc5]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"quantite2","rows":52,"type":"double","value":[["-0.2531"],["-0.2495"],["-0.2498"],["-0.2473"],["-0.2467"],["-0.2467"],["-0.2472"],["-0.2452"],["-0.2470"],["-0.2466"],["-0.2436"],["-0.2444"],["-0.2425"],["-0.2429"],["-0.2422"]]}}
%---
%[output:80e1a80e]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"current_pv","rows":52,"type":"double","value":[["-0.5721"],["-0.5852"],["-0.5967"],["-0.6080"],["-0.6149"],["-0.6205"],["-0.6252"],["-0.6335"],["-0.6349"],["-0.6438"],["-0.6556"],["-0.6582"],["-0.6699"],["-0.6756"],["-0.6819"]]}}
%---
%[output:9155ef86]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"next_pv","rows":51,"type":"double","value":[["-0.5712"],["-0.5862"],["-0.5953"],["-0.6082"],["-0.6158"],["-0.6215"],["-0.6222"],["-0.6339"],["-0.6337"],["-0.6432"],["-0.6566"],["-0.6573"],["-0.6706"],["-0.6751"],["-0.6828"]]}}
%---
%[output:5088e0fd]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"diff","rows":51,"type":"double","value":[["0.0009"],["-0.0009"],["0.0013"],["-0.0003"],["-0.0009"],["-0.0010"],["0.0030"],["-0.0004"],["0.0012"],["0.0006"],["-0.0010"],["0.0009"],["-0.0006"],["0.0005"],["-0.0008"]]}}
%---
%[output:36f9cca1]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Date","q","PV1_current","PV1_next","Difference_PV1","k1","k2","PV2_current","PV2_next","Difference_PV2"],"columns":10,"dataTypes":["datetime","double","double","double","double","double","double","double","double","double"],"header":"52×10 table","name":"result_table","rows":52,"type":"table","value":[["08-Jan-2015","-0.8903","1.1669","1.1638","-0.0031","-1.3175","-0.2531","-0.5721","-0.5712","9.2879e-04"],["15-Jan-2015","-0.8739","1.1776","1.1878","0.0102","-1.3349","-0.2495","-0.5852","-0.5862","-9.2375e-04"],["22-Jan-2015","-0.8730","1.1886","1.1866","-0.0020","-1.3453","-0.2498","-0.5967","-0.5953","0.0013"],["29-Jan-2015","-0.8615","1.1964","1.1968","3.7544e-04","-1.3602","-0.2473","-0.6080","-0.6082","-2.5460e-04"],["05-Feb-2015","-0.8580","1.1998","1.2006","8.5493e-04","-1.3675","-0.2467","-0.6149","-0.6158","-8.5663e-04"],["12-Feb-2015","-0.8568","1.2017","1.2036","0.0020","-1.3724","-0.2467","-0.6205","-0.6215","-0.0010"],["19-Feb-2015","-0.8580","1.2027","1.1968","-0.0058","-1.3756","-0.2472","-0.6252","-0.6222","0.0030"],["26-Feb-2015","-0.8486","1.2048","1.2068","0.0020","-1.3888","-0.2452","-0.6335","-0.6339","-4.4252e-04"],["05-Mar-2015","-0.8550","1.2015","1.2031","0.0016","-1.3883","-0.2470","-0.6349","-0.6337","0.0012"],["12-Mar-2015","-0.8516","1.2060","1.2022","-0.0038","-1.3989","-0.2466","-0.6438","-0.6432","6.1006e-04"],["19-Mar-2015","-0.8388","1.2132","1.2128","-3.8412e-04","-1.4141","-0.2436","-0.6556","-0.6566","-9.9085e-04"],["26-Mar-2015","-0.8411","1.2109","1.2102","-6.7783e-04","-1.4150","-0.2444","-0.6582","-0.6573","8.5151e-04"],["02-Apr-2015","-0.8322","1.2179","1.2195","0.0015","-1.4294","-0.2425","-0.6699","-0.6706","-6.4097e-04"],["09-Apr-2015","-0.8328","1.2189","1.2163","-0.0026","-1.4341","-0.2429","-0.6756","-0.6751","4.5037e-04"]]}}
%---
%[output:79939911]
%   data: {"dataType":"tabular","outputData":{"columnNames":["Date","q","PV1_current","PV1_next","Difference_PV1","k1","k2","PV2_current","PV2_next","Difference_PV2"],"columns":10,"dataTypes":["datetime","double","double","double","double","double","double","double","double","double"],"header":"52×10 table","name":"result_table","rows":52,"type":"table","value":[["08-Jan-2015","-0.8903","1.1669","1.1638","-0.0031","-1.3175","-0.2531","-0.5721","-0.5712","9.2900e-04"],["15-Jan-2015","-0.8739","1.1776","1.1878","0.0102","-1.3349","-0.2495","-0.5852","-0.5862","-9.2400e-04"],["22-Jan-2015","-0.8730","1.1886","1.1866","-0.0020","-1.3453","-0.2498","-0.5967","-0.5953","0.0014"],["29-Jan-2015","-0.8615","1.1964","1.1968","3.7500e-04","-1.3602","-0.2473","-0.6080","-0.6082","-2.5500e-04"],["05-Feb-2015","-0.8580","1.1998","1.2006","8.5500e-04","-1.3675","-0.2467","-0.6149","-0.6158","-8.5700e-04"],["12-Feb-2015","-0.8568","1.2017","1.2036","0.0020","-1.3724","-0.2467","-0.6205","-0.6215","-0.0010"],["19-Feb-2015","-0.8580","1.2027","1.1968","-0.0058","-1.3756","-0.2472","-0.6252","-0.6222","0.0030"],["26-Feb-2015","-0.8486","1.2048","1.2068","0.0020","-1.3888","-0.2452","-0.6335","-0.6339","-4.4300e-04"],["05-Mar-2015","-0.8550","1.2015","1.2031","0.0016","-1.3883","-0.2470","-0.6349","-0.6337","0.0012"],["12-Mar-2015","-0.8516","1.2060","1.2022","-0.0038","-1.3989","-0.2466","-0.6438","-0.6432","6.1000e-04"],["19-Mar-2015","-0.8388","1.2132","1.2128","-3.8400e-04","-1.4141","-0.2436","-0.6556","-0.6566","-9.9100e-04"],["26-Mar-2015","-0.8411","1.2109","1.2102","-6.7800e-04","-1.4150","-0.2444","-0.6582","-0.6573","8.5200e-04"],["02-Apr-2015","-0.8322","1.2179","1.2195","0.0015","-1.4294","-0.2425","-0.6699","-0.6706","-6.4100e-04"],["09-Apr-2015","-0.8328","1.2189","1.2163","-0.0026","-1.4341","-0.2429","-0.6756","-0.6751","4.5000e-04"]]}}
%---
%[output:61a64798]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"0.0029"}}
%---
%[output:4ee75088]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"0.0011"}}
%---
