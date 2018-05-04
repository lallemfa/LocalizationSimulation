clc; close all; clear all;

%% Influence des parametres

s = tf('s');

P = 1/(s+1)^3;

% Influence de Kp

figure(1); hold on;
figure(2); hold on;
figure(3); hold on;
labels = {};

for i = 1:10
    Kp = i*0.1;
    Ki = 0;
    Kd = 0;

    labels{end+1} = ['Kp = ' num2str(Kp)];

    C = (Kp*s+Ki+Kd*s^2)/s;

    L = P*C;

    figure(1);
    step(L/(1+L));
    figure(2);
    margin(L);
    figure(3);
    nyquist(L);
end
figure(1); legend(labels);
figure(2); legend(labels);
figure(3); legend(labels);

% Influence de Ki
figure(4); hold on;
figure(5); hold on;
figure(6); hold on;
labels = {};

for i = 0:10
    Kp = 0.5;
    Ki = i*0.1;
    Kd = 0;

    labels{end+1} = ['Ki = ' num2str(Ki)];

    C = (Kp*s+Ki+Kd*s^2)/s;

    L = P*C;

    figure(4);
    step(L/(1+L));
    figure(5);
    margin(L);
    figure(6);
    nyquist(L);
end
lgd = legend(labels);
figure(4); title(lgd, 'Kp = 0.5');
lgd = legend(labels);
figure(5); title(lgd, 'Kp = 0.5');
lgd = legend(labels);
figure(6); title(lgd, 'Kp = 0.5');

% Influence de Kd
figure(7); hold on;
figure(8); hold on;
figure(9); hold on;
labels = {};

for i = 0:10
    Kp = 0.5;
    Ki = 0.5;
    Kd = i*0.1;

    labels{end+1} = ['Kd = ' num2str(Kd)];

    C = (Kp*s+Ki+Kd*s^2)/s;

    L = P*C;
    figure(7);
    step(L/(1+L));
    figure(8);
    margin(L);
    figure(9);
    nyquist(L);
end
lgd = legend(labels);
figure(7); title(lgd, 'Kp = 0.5 | Ki = 0.5');
lgd = legend(labels);
figure(8); title(lgd, 'Kp = 0.5 | Ki = 0.5');
lgd = legend(labels);
figure(9); title(lgd, 'Kp = 0.5 | Ki = 0.5');

%%

s = tf('s');

P = 1/(s+1)^3;

Kp = 1;
Ki = 0.5;
Kd = 1;

C = (Kp*s+Ki+Kd*s^2)/s;

L = P*C;

figure; step(L/(1+L));

figure; hold on; margin(L); margin(L/(1+L)); legend('L', 'L/(1+L)');
figure; hold on; nyquist(L); nyquist(L/(1+L)); legend('L', 'L/(1+L)');
figure; hold on; nichols(L); nichols(L/(1+L)); legend('L', 'L/(1+L)');