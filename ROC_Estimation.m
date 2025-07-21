clc

clear

close all

format long;


%% Variables

W=2400; %lbs

S=160; %ft^2

n = 2700; %RPM

D = 74/12; %propeller diameter

CD_o = 0.0317;

e_o = 0.6;

AR = 5.71;

eng_power = 180; %hp

h_conv = 3.281; %1m = 3.281ft

rho_conv = 0.00194032; %1kg/m^3 = 0.00194032 slug/ft^3

h=[0 5000 10000 15000]; % ft

[T, a, P, rho]=atmosisa(h./h_conv);

rho = rho.*rho_conv; % density in slug/ft^3


k=1/(pi*e_o*AR);

V=65:220; %ft/s


prop_J = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.980];

prop_eff = [0.53, 0.63, 0.71, 0.76, 0.80, 0.81, 0.76, 0.60];

eff = interp1( prop_J, prop_eff, V./(D*n/60), "spline") ;

P_av = eng_power.*eff;


for i=1:4

    q(:,i) = 0.5*(V.^2).*rho(i);

    CL(:,i)=W./(q(:,i).*S);

    CLSM = CL;

    CLSM(CLSM>1.45/1.1)=1.45/1.1;

    CD(:,i)=CD_o+k*CL(:,i).^2;

    CDSM(:,i)=CD_o+k*CLSM(:,i).^2;

    P_req(:,i) = W*sqrt((2*W*CD(:,i).^2)./(S*rho(i)*CL(:,i).^3));

    P_reqSM(:,i) = W*sqrt((2*W*CDSM(:,i).^2)./(S*rho(i)*(CLSM(:,i)).^3));

    EAS(:,i)=V.*sqrt(rho(i)/rho(1))./1.688; %kts

    ROC(:,i)=(transpose(eng_power*550*eff*(rho(i)/rho(1))) - P_req(:,i))*60/W;

    ROCSM(:,i)=(transpose(eng_power*550*eff*(rho(i)/rho(1))) - P_reqSM(:,i))*60/W;


    % Hodograph

    gamma(:,i) = asin(ROC(:,i)./transpose(V*60));

    gammaSM(:,i) = asin(ROCSM(:,i)./transpose(V*60));

    VH(:,i) = EAS(:,i).*cos(gamma(:,i));

   

    % Fastest ROC

    Vfast(:,i) =  V(find(ROC(:,i)==max(ROC(:,i)))).*sqrt(rho(i)/rho(1))./1.688;

       

    % Steepest ROC

    Vsteep(:,i) =  V(find(gamma(:,i)==max(gamma(:,i)))).*sqrt(rho(i)/rho(1))./1.688;

    ROCsteep(i) = V(find(gamma(:,i)==max(gamma(:,i)))).*max(gamma(:,i))*60;

    ROCsteepSM(i) = (V(find(gammaSM(:,i)==max(gammaSM(:,i)))).*max(gammaSM(:,i))*60);


end



ROC_max = [max(ROC(:,1)), max(ROC(:,2)), max(ROC(:,3)), max(ROC(:,4))];

p=polyfit(h, ROC_max, 1);

abs_ceil = -p(2)/p(1);


% Time to Climb

p = polyfit(h, ROC_max, 1)

abs_ceil = round(-p(2)/p(1), 2, 'significant');

ROC_inv = matlabFunction(1/poly2sym(p));

t = cumtrapz(ROC_inv(0:abs_ceil));


figure(1)

hold on

grid on

plot(EAS(:,1), ROC(:,1));

plot(EAS(:,2), ROC(:,2));

plot(EAS(:,3), ROC(:,3));

plot(EAS(:,4), ROC(:,4));

% max(ROC(:,:,1))


xlim([35 inf])

ylim([0 900])

plot(Vsteep, ROCsteep, 'o--');

plot(Vfast,ROC_max, 'o--' );

legend("SSL", "5000 ft", "10000 ft", "15000 ft", 'Steepest ROC', 'Fastest ROC')

xlabel('Equivalent Airspeed (kts)')

ylabel('Rate of Climb (ft/min)')

hold off


% Hodograph

figure(2)


hold on

grid on

plot(VH(:,1),ROC(:,1));

plot(VH(:,2), ROC(:,2));

plot(VH(:,3), ROC(:,3));

plot(VH(:,4), ROC(:,4));

legend("SSL", "5000 ft", "10000 ft", "15000 ft")

title("Hodograph of Rate of Climb vs Horizontal Airspeed")

ylim([0 900])

xlim([35,inf])

xlabel("Horizantal Airspeed (kts)")

ylabel("Rate of Climb (ft/min)")


hold off


figure(3)

hold on

plot (ROC_max,h,'o');

plot (polyval(p, 0:abs_ceil), 0:abs_ceil);

xlim([0 900])

ylim([0 18000])

title ("Maximum ROC vs Altitude")

xlabel ("ROC [ft/min]")

ylabel ("Altitude [ft]")

plot(0,16509, 'r*')

plot(100,14528, 'd')

legend("Max ROC", "Line of Best Fit", "Absolute Ceiling", "Service Ceiling")

grid on

hold off


% Time to Climb

figure(4)

hold on

plot(t,0:abs_ceil);

yline(abs_ceil, '--', 'Absolute ceiling')

yline(14500, '--', 'Service ceiling')

ylabel('Height (ft)');

xlabel('Time (min)');

title('Time to climb to altitude')

ylim([0 17000])

xlim([0 80])

grid on

hold off
