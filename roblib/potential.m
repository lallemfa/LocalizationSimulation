function potential

function xpoint=f(x,u)  %  x=[x,y,v,theta]
     xpoint=[x(3)*cos(x(4));
             x(3)*sin(x(4));
             u(1);u(2)];
end

function draw_field(phat,qhat,vhat) 
   X = xmin:0.1:xmax;
   Y = ymin:0.1:ymax;
   [P1,P2] = meshgrid(X,Y);
   Nq1=P1-qhat(1);
   Nq2=P2-qhat(2);
   VX=vhat(1)-0.5*(P1-phat(1))+(Nq1)./((Nq1.^2+Nq2.^2).^(3/2));
   VY=vhat(2)-0.5*(P2-phat(2))+(Nq2)./((Nq1.^2+Nq2.^2).^(3/2));
   VX=VX./sqrt(VX.^2+VY.^2);
   VY=VY./sqrt(VX.^2+VY.^2);
   quiver(X,Y,VX,VY);  
end

init;
xmin=-3;xmax=3;ymin=-3;ymax=3;
x=[2;1;1;0];  % x,y,v,theta
dt=0.1;
for t=0:dt:100,
        phat=[cos(0.1*t);2*sin(0.1*t)]; 
        vhat=[-0.1*sin(0.1*t);2*0.1*cos(0.1*t)]; 
        qhat=[2*cos(-0.2*t);2*sin(-0.2*t)]; 
        p=x(1:2);
        clf(); hold on;axis([xmin,xmax,ymin,ymax]); axis square;        
        w=vhat-0.5*(p-phat)+(p-qhat)/(norm(p-qhat)^3);        
        vbar=norm(w); thetabar=angle(w);    
        u=[vbar-x(3);sawtooth(thetabar-x(4))];        
        x=x+f(x,u)*dt;                 
        draw_tank(x([1,2,4]),'red',0.1);
        draw_field(phat,qhat,vhat);
        plot(phat(1),phat(2),'oblack','LineWidth',3);
        plot(qhat(1),qhat(2),'ored','LineWidth',3);
        drawnow();
end;
end