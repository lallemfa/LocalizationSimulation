function locboat

function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
theta=x(3);v=x(4);
xdot=[v*cos(theta); v*sin(theta); u(1); u(2)];
end

function phat = loc(u,y,m,dm)
  alpha=y(1);      
  dalpha=y(2);      
  theta=y(3);
  v=y(4);  
  beta=theta+alpha;
  dbeta=u(1)+dalpha;
  phat=[sin(beta),cos(beta);-cos(beta), sin(beta) ]*...
       [-m(2),m(1); m(1)-(dm(2)-v*sin(theta))/dbeta,...
          m(2)+(dm(1)-v*cos(theta))/dbeta]*...
       [cos(beta);sin(beta) ];
end

function y = g(x,u,m,dm)
      st=sin(x(3));ct=cos(x(3));
      v=m-x(1:2);
      alpha=-x(3)+angle(v);
      dalpha=-u(1)+(1/norm(v)^2)*(v(1)*...
              (dm(2)-x(4)*st)-v(2)*(dm(1)-x(4)*ct));
      y=[alpha;dalpha;x(3);x(4)];    
end


init;
x=[0;0;0;1];        
u=[0.1;0];              
dt=0.1; 
for t=0:dt:50,
  m=[6+2*sin(t);7+3*cos(t)];
  dm=[2*cos(t);-3*sin(t)];  
  clf; axis([-50,50,-50,50]); axis square; hold on;  
  y=g(x,u,m,dm);
  y=y+0*0.01*randn(size(y));
  phat=loc(u,y,m,dm); 
  draw_tank(x,'blue');
  x=x+f(x,u)*dt;   
  plot(phat(1),phat(2),'+magenta');
  plot(m(1),m(2),'*red');
  drawnow();     
end;

end



