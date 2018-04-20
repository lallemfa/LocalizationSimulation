function radar
    function y=g(x)
        y=[norm(x([1,3])-a)^2;norm(x([1,3])-b)^2];
    end

% ----------------    Main  -----------------
init;
dt=0.01;a=[0;0]; b=[1;0]; x=[0;0;2;0]; 
Ak=[1 dt 0 0;  0 (1-dt) 0 0 ; 0 0 1 dt; 0 0 0 (1-dt)];
Galpha=dt*diag([0;1;0;1]); Gbeta=eye(2,2);
xhat=[1;0;3;0]; Gx=10000*eye(4,4); 
for t=0:dt:10,
     clf(); axis([-5,5,-5,5]); axis square, hold on;
  	 plot(x(1),x(3),'o red');
  	 plot(a(1),a(2),'o green');
  	 plot(b(1),b(2),'o green');
     beta=mvnrnd([0;0],Gbeta)'; 
  	 y=g(x)+beta;
     draw_circle(a,sqrt(abs(y(1)))); draw_circle(b,sqrt(abs(y(2))));
     Ck=2*[xhat(1)-a(1),0,xhat(3)-a(2),0; 
           xhat(1)-b(1),0,xhat(3)-b(2),0];
     zk=y-g(xhat)+Ck*xhat; 
     [xhat,Gx]=kalman(xhat,Gx,0,zk,Galpha,Gbeta,Ak,Ck);
     draw_ellipse(xhat([1;3]),Gx([1;3],[1;3]),0.9,'magenta');
     alpha=mvnrnd([0;0;0;0],Galpha)'; 
     x=Ak*x+alpha;
     drawnow();
end;
end
