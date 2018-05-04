function dx=cruise_clsysode(t, x, param)
%%
%cruise_clsysode.m - dynamics for car with PI speed controller 
% 
% PI control with anti-windup for linear and nonlinear models
% systems
% Nonlinear model
% x(1)	vehicle speed
% x(2)  controller state (integrator) nonlinear model

%% get model parameters

kp=param(1);
ki=param(2);
kt=param(3);
theta_d=param(4);
gear=param(5);

cruise_carpar;
%cruise_lin;                     

% Hill parameters: 6 deg slot at time t = 5
if (t < 5) 
  theta = 0; 
elseif (t < 6)
  % Provide a linear transition to the hill
  theta = (theta_d/180 * pi) * (t-5);
else
  theta = theta_d/180 * pi;
end

%% PI Controller with antiwindup
% COMPLETE THE PI
e = 0;                 %speed error
uu =0;                  %nominal control signal
u=0;         %saturated control signal
dI=0;              %update integral term with windup protection

%% ------------ Nonlinear model
% Compute the torque produced by the engine
v=x(1);
dv=cruisedyn(v, u, gear, theta);


%%
%% ------------ linear model
% Compute the torque produced by the engine



%%
dx = [dv;dI];

