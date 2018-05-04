%% PI control with antiwindup for linear and nonlinear models

close all, clear all

%% Controller set
% TO COMPLETE
kp=0;ki=0;kt=0;

theta_d = 0;		% set the hill angle
gear=1;             %gear

param= [kp,ki,kt,theta_d,gear];

%% Car parameters
cruise_carpar
% Defines operating conditions

%% PI controller simulation of linear and nonlinear models
%
%kt = 0;
% TO COMPLETE 
% USE ODE45 FUNCTION FOR CRUISE_CLSYSODE.M 
% BETWEEN 0-70 WITH INITIAL CONDITIONS [v_e u_e]
[t, x] = ode45(@(t,x) cruise_clsysode(t, x, param), [0 70], [v_e u_e]);


%% Plot the results
% Compute control signal for plotting
                   % speed error
                % throttle
           % saturate throttle  
         % throttle for linear model                       






