function invpend ()

function v=f(x,u)
    v=[x(3);x(4);
      (m*sin(x(2))*(g*cos(x(2))-l*x(4)^2)+u)/(M+m*sin(x(2))^2);
      (sin(x(2))*((M+m)*g-m*l*x(4)^2*cos(x(2)))+u*cos(x(2)))/(l*(M+m*sin(x(2))^2))];
end;

function draw(x)
    clf(); hold on; axis('off'); axis([-3,3,-3,3]);   
    plot([ x(1), x(1)-l*sin(x(2))], [0, l*cos(x(2))],'blue','LineWidth',2);  % pendulum
    plot(x(1)+[-.5,.5,.5,-.5,-.5], [0,0,-.25,-.25,0],'magenta','LineWidth',2);   
    drawnow();   
end

init;
m=1;M=5;l=1;g=9.81; dt=0.05;
A=[0 0 1 0;0 0 0 1;0 m*g/M 0 0;0 (M+m)*g/(l*M) 0 0];		
B=[0;0;1/M;1/(l*M)];
C=[1 0 0 0;0 1 0 0];
E=[1 0 0 0];
K=place(A,B,[-2 -2.01 -2.02 -2.03]);
H=-inv(E*((A-B*K)\B)); %H=-inv(E*inv(A-B*K)*B);
kalm=true;   % if true then the Kalman filter is chosen otherwize Luenberger is chosen
sigm_y=0.01;  %sensor noise
if (kalm)
  P=eye(4,4); %  Kalman initialization
  Q_alpha=dt*0.00001*eye(4,4);  %almost no state noise
  Q_beta=sigm_y^2*eye(2,2);
else
    L=place(A',C',[-2 -2.01 -2.02 -2.03])'; %Luenberger gain
end;
x=[0;0.02;0;0];		xr=[0;0;0;0];
for t=0:dt:30,
  w=1;
  y=C*x+sigm_y*randn(2,1); 
  u=-K*xr+H*w;
  if (kalm),
     [xr,P]=kalman(xr,P,dt*B*u,y,Q_alpha,Q_beta,eye(4,4)+A*dt,C);    %Kalman
  else 
     xr=xr+(A*xr+B*u-L*(C*xr-y))*dt;      %Luenberger
  end;
  x=x+f(x,u)*dt;
  draw(x);
end

end