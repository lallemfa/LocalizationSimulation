function vanderpol

function xpoint=f(x,u)  %  x=[x,y,theta,v,delta]
     xpoint=[x(4)*cos(x(5))*cos(x(3));
             x(4)*cos(x(5))*sin(x(3));
             x(4)*sin(x(5))/3;
             u(1);u(2) ];
end

function draw_field(xmin,xmax,ymin,ymax)
   Mx = xmin:2:xmax;
   My = ymin:2:ymax;
   [X1,X2] = meshgrid(Mx,My);
   VX=X2;
   VY=-(0.01*X1.^2-1).*X2-X1;
   VX=VX./sqrt(VX.^2+VY.^2);
   VY=VY./sqrt(VX.^2+VY.^2);
   quiver(Mx,My,VX,VY);  
end

init; Lx=50;Ly=30;  
x=[0;5;pi/2;2;0.6];  % x,y,theta,v,delta
dt=0.01;
for t=0:dt:5,
        clf(); hold on; 
        axis([-Lx,Lx,-Ly,Ly]);   
        vdp=[x(2);-(0.01*x(1)^2-1)*x(2)-x(1)]; % field to follow
        w=[10;angle(vdp)];  % desired input      
        ubar=[w(1);-3*sawtooth(x(3)-w(2))];
        u=10*(ubar-[x(4)*cos(x(5));x(4)*sin(x(5))/3]);
        x=x+f(x,u)*dt;                 
        draw_car(x);
        draw_field(-Lx,Lx,-Ly,Ly);
        drawnow();
end;
        
end