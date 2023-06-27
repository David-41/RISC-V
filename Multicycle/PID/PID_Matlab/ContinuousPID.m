%% Simulation Continuous PID

kp = 1;
ki = 0;
kd = 0;
t = 0.001;
td = kd;
ti = 1/ki;
k1 = kp+td/t;
k2 = -kp + t/ti - 2*td/t;
k3 = td/t;
k = [k1; k2; k3];

out = sim("Continuous_PID.slx");

dlmwrite('reffile.txt', int32(out.reference), 'precision', 10);
dlmwrite('fbfile.txt', int32(out.feedback), 'precision', 10);
dlmwrite('kfile.txt', int32(round(k)), 'precision', 10)

hold off
figure(1)
plot(out.control,'LineWidth',2)
hold on
plot(out.reference,'LineWidth',2)
plot(out.feedback,'LineWidth',2)
%plot(out.reference - out.feedback,'LineWidth',2)
grid minor
get(gca,'fontname');
set(gca,'fontname','Palatino Linotype')
legend("Control", "Reference", "Feedback")
fig = gca;
exportgraphics(fig, '5_2_ContinuousControl.pdf');

%% Read simulation files

discU = dlmread('ufile.txt', ' ', 1, 0);

hold off
figure(1)
plot(out.control,'LineWidth',2)
hold on
plot(discU,'LineWidth',2)
grid minor
get(gca,'fontname');
set(gca,'fontname','Palatino Linotype')
legend("Golden model", "DUT")
fig = gca;
exportgraphics(fig, '5_2_ComparisonControl.pdf');