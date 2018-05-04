function dx=cruise_clsysode(t, x, param, windup)
%%
%cruise_clsysode.m - dynamics for car with PI speed controller 
% 
% PI control with anti-windup for linear and nonlinear models
% systems
% Nonlinear model
% x(1)	vehicle speed
% x(2)  controller state (integrator) nonlinear model

%% get model parameters

kp      = param(1);
ki      = param(2);
kt      = param(3);
theta_d = param(4);
gear    = param(5);
v_ref   = param(6);

%cruise_carpar;
cruise_lin;                     

% Hill parameters: 6 deg slot at time t = 5
if (t < 5) 
  theta = 0; 
elseif (t < 6)
  % Provide a linear transition to the hill
  theta = (theta_d/180 * pi) * (t-5);
else
  theta = theta_d/180 * pi;
end

v_act_nl    = x(1);
v_act_l     = x(2);

%% PI Controller with antiwindup
% COMPLETE THE PI
% 
e_nl   = v_ref - v_act_nl;        % speed error
uu_nl  = kp*e_nl + ki*(x(3));   % nominal control signal
u_nl   = min(max(0, uu_nl), 1);	% saturated control signal

if(windup)
    dI_nl  = (ki + kt*(u_nl - uu_nl)) *e_nl; % update integral term with windup protection
else
    dI_nl  = ki*e_nl; 
end

e_l   = v_ref - v_act_l;        % speed error
uu_l  = kp*e_l + ki*(x(4));   % nominal control signal
u_l   = min(max(0, uu_l), 1);	% saturated control signal

if(windup)
    dI_l  = (ki + kt*(u_l - uu_l)) *e_l; % update integral term with windup protection
else
    dI_l  = ki*e_l; 
end


%% ------------ Nonlinear model
% Compute the torque produced by the engine

dv_nl  = cruisedyn(v_act_nl, u_nl, gear, theta);


%%
%% ------------ linear model
% Compute the torque produced by the engine
dv_l  =  a*(v_act_l-v_e) - bg*(theta-theta_e) + b*(u_l - u_e);


%%
dx = [dv_nl;dv_l;dI_nl; dI_l];

