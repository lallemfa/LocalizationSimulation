function dv = cruisedyn(v, u, gear, theta)
% cruisedyn - dynamic model for cruise control
%
% Usage: dv = cruisedyn(v, u, gear, theta)
% 
% This function returns the acceleration of the vehicle given the 
% current velocity (in m/s), throttle setting (0 <= u <= 1), gear (1-5),
% road slope.

% Parameters for defining the system dynamics
cruise_carpar

% Saturate the input to the range of 0 to 1
u = min(u, 1);  u = max(0, u);

% Compute the torque produced by the engine, Tm
omega = gears(gear) * v;		% engine speed
torque = u * Tm * ( 1 - bbeta * (omega/wm - 1)^2 );
F = gears(gear) * torque;

% Compute the external forces on the vehicle
Fr = m * g * Cr;			% Rolling friction
Fa = 0.5 * rho * Cd * A * v^2;		% Aerodynamic drag
Fg = m * g * sin(theta);		% Road slope force
Fd = Fr + Fa + Fg;			% total deceleration

% Now compute the acceleration 
dv = (F - Fd) / m;
