%% PI control with antiwindup for linear and nonlinear models

clc, close all, clear all;

%% Controller set

kp = 0.5;
ki = 0.1;
kt = 0.015;

theta_d = 0;		% set the hill angle
gear    = 3;             % gear

v_ref = 35;

param = [kp, ki, kt, theta_d, gear, v_ref];

%% Car parameters
cruise_lin
% Defines operating conditions

%% PI controller simulation of linear and nonlinear models
%

% TO COMPLETE 
% USE ODE45 FUNCTION FOR CRUISE_CLSYSODE.M 
% BETWEEN 0-70 WITH INITIAL CONDITIONS [v_e u_e]
[t, x]  = ode45(@(t,x) cruise_clsysode(t, x, param, 0), [0 70], [v_e v_e u_e u_e]);
t_ss_w  = t;
x_ss_w  = x;

clearvars x;

[t, x]  = ode45(@(t,x) cruise_clsysode(t, x, param, 1), [0 70], [v_e v_e u_e u_e]);
t_av_w  = t;
x_av_w  = x;

% Sans windup
e_nl_ss_w    = v_ref - x_ss_w(:,1);
uu_nl_ss_w   = kp*e_nl_ss_w + ki*(x_ss_w(:,3));
u_nl_ss_w    = min(max(0, uu_nl_ss_w), 1);

e_l_ss_w     = v_ref - x_ss_w(:,2);
uu_l_ss_w    = kp*e_l_ss_w + ki*(x_ss_w(:,4));
u_l_ss_w     = min(max(0, uu_l_ss_w), 1);

% Avec windup
e_nl_av_w   = v_ref - x_av_w(:,1);
uu_nl_av_w  = kp*e_nl_av_w + ki*(x_av_w(:,3));
u_nl_av_w   = min(max(0, uu_nl_av_w), 1);

e_l_av_w   = v_ref - x_av_w(:,2);
uu_l_av_w  = kp*e_l_av_w + ki*(x_av_w(:,4));
u_l_av_w   = min(max(0, uu_l_av_w), 1);

%% Plot the results
% Compute control signal for plotting
figure;
subplot(2,2,1); hold on; plot(t_ss_w, x_ss_w(:,1), 'b'); plot(t_ss_w, x_ss_w(:, 2), 'r'); plot(t_ss_w, v_ref*ones(length(t_ss_w)), 'black--');
legend('Non lineaire', 'Lineaire', 'Location', 'southeast');
xlabel('t(s)'); ylabel('Vitesse'); title('Regulation sans anti-windup');
subplot(2,2,3); hold on; plot(t_ss_w, uu_nl_ss_w, 'b--'); plot(t_ss_w, u_nl_ss_w, 'b'); plot(t_ss_w, uu_l_ss_w, 'r--'); plot(t_ss_w, u_l_ss_w, 'r');
legend('Commande NL voulue', 'Commande NL réelle', 'Commande L voulue', 'Commande L réelle');
xlabel('t(s)'); ylabel('Controle');
subplot(2,2,2); hold on; plot(t_av_w, x_av_w(:,1), 'b'); plot(t_av_w, x_av_w(:, 2), 'r'); plot(t_av_w, v_ref*ones(length(t_av_w)), 'black--');
legend('Non lineaire', 'Lineaire', 'Location', 'southeast');
xlabel('t(s)'); ylabel('Vitesse'); title('Regulation avec anti-windup');
subplot(2,2,4); hold on; plot(t_av_w, uu_nl_av_w, 'b--'); plot(t_av_w, u_nl_av_w, 'b'); plot(t_av_w, uu_l_av_w, 'r--'); plot(t_av_w, u_l_av_w, 'r');
legend('Commande NL voulue', 'Commande NL réelle', 'Commande L voulue', 'Commande L réelle');
xlabel('t(s)'); ylabel('Controle');

                   % speed error
                % throttle
           % saturate throttle  
         % throttle for linear model                       

s = tf('s');
P = ss(a, [bg b], 1, 0);
C = (kp*s+ki)/s;
L = P*C;

figure; nichols(L);



