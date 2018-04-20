function  wheel

function draw(x) % draw the wheel
   wheel0=[]; 
   for a=0:pi/8:2*pi,  % wheel pattern   
      radius=[0;rho*cos(a);rho*sin(a);1];
      wheel0=[wheel0,radius,[0;0;0;1],radius]; 
   end      
  E=eulermat(x(8),x(7),x(6)); %phi,theta,psi
  R=[E,[x(1);x(2);rho*cos(x(7))];0 0 0 1];
  wheel=R*wheel0;
  plot3(wheel(1,:),wheel(2,:),wheel(3,:),'blue');
  hold on;
  plot3(wheel(1,:),wheel(2,:),0*wheel(3,:),'black'); % shadow
  axis([-10,10,-10,10,0,10]);
  axis square;
end

function xdot=f(x)  % evolution function of the wheel
   w=x(3:5);
   m=1; g=9.81;
   psi=x(6);  theta=x(7); 
   I=diag([1 0.5 0.5])*(m/2)*rho^2;
   n=[sin(psi);-cos(psi);0];
   deuler=[0 -sin(psi) cos(theta)*cos(psi);
      0  cos(psi) cos(theta)*sin(psi);
      1    0         -sin(theta)       ]\w;
   dphi=deuler(3);   
   dw=m*rho*(rho*dphi*w(3)*cos(theta)-g*sin(theta))*inv(I)*n;
   xdot=[rho*dphi*n(1:2);dw;deuler];
end


init;
rho=1;dt=0.005;
%x=[0;0;0;10;0.1;pi/2;0.2;0]; %x,y,wx,wy,wz,psi,theta,phi
x=[0;0;0;10;0.0;pi/2;0.3;0]; %x,y,wx,wy,wz,psi,theta,phi
for t=0:dt:15, 
        clf;
        %t=t+dt;
        x=x+dt*(0.25*f(x)+0.75*(f(x+(2/3)*dt*f(x)))); %Runge Kutta
        if (abs(x(1))>10)||(abs(x(2))>10), x(1:2)=-x(1:2); end;
        draw(x);
        drawnow();
end

end