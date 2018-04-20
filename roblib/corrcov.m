init;
n=1000;
xbar=[1; 2];
Gx=[3 1;1 3];
b=randn(2,n);
x=mvnrnd(xbar,Gx,n)';
axis([-10 10 -10 10]); hold on;
plot(x(1,:),x(2,:),'.blue'); 
draw_ellipse(xbar,Gx,0.9,'red',2);

x2=-10:10; 
x1=1+(1/3)*(x2-2);
plot(x1,x2,'black','LineWidth',2);

x1=-10:10; 
x2=2+(1/3)*(x2-1);
plot(x1,x2,'black','LineWidth',2);

