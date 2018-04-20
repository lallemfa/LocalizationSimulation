n=1000;
b=randn(2,n);
Gx=[3 1;1 3];
xbar=[2;3];
x=xbar*ones(1,n)+sqrtm(Gx)*b;
%plot(x(1,:),x(2,:),'+blue');
hold on;
%draw_ellipse(xbar,Gx,0.9,'red',2);
%draw_ellipse(xbar,Gx,0.99,'blue',2);
%draw_ellipse(xbar,Gx,0.999,'green',2);
dt=0.01;
A=[0 1;-1 0];
B=[2;3];
Ad=eye(2,2)+dt*A;
for t=0:dt:5
    ud=dt*sin(t)*B;
    x=Ad*x+ud*ones(1,n); 
    clf; hold on; axis([-20 20 -20 20]);
    plot(x(1,:),x(2,:),'+blue'); 
    xbar=Ad*xbar+ud;
    Gx=Ad*Gx*Ad';
    draw_ellipse(xbar,Gx,0.9,'red',2);    
    draw_ellipse(xbar,Gx,0.99,'green',2);    
    drawnow();    
end
