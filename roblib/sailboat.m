function sailboat

function draw(x,a,b) 
   clf; axis([-100,100,-60,60]); hold on; 
   plot([a(1) b(1)],[a(2) b(2)],'red');
   theta=x(3);
   hull=[-1  5 7  7 5 -1 -1 -1; -2 -2 -1 1 2 2  -2 -2 ; 1 1 1 1 1 1 1 1] ;
   sail=[-5 0;0 0;1 1];
   rudder=[-1 1;0 0;1 1];
   R=[cos(theta),-sin(theta),x(1);sin(theta),cos(theta),x(2);0 0 1];
   hull=R*hull;
   Rdeltas=[cos(deltas),-sin(deltas),3;sin(deltas),cos(deltas),0;0 0 1];
   Rdeltar=[cos(u(1)),-sin(u(1)),-1;sin(u(1)),cos(u(1)),0;0 0 1];
   sail=R*Rdeltas*sail;
   rudder=R*Rdeltar*rudder;
   Mfs=[-1 -1;0 -fs/1000;1 1];
   Mfr=[0 0;0 fr/100;1 1];
   Mfs=R*Rdeltas*Mfs;
   Mfr=R*Rdeltar*Mfr;
   draw_arrow(x(1)+5,x(2),psi,5*awind,'red');
   plot(hull(1,:),hull(2,:),'black');       
   plot(sail(1,:),sail(2,:),'red');       
   plot(rudder(1,:),rudder(2,:),'red');
   plot(Mfs(1,:),Mfs(2,:),'blue')
   plot(Mfr(1,:),Mfr(2,:),'blue')
end

function  xdot = f(x,u)
    theta=x(3); v=x(4); w=x(5); deltar=u(1); deltasmax=u(2);
    w_ap=[awind*cos(psi-theta)-v;awind*sin(psi-theta)]; %Apparent wind
    psi_ap=angle(w_ap);   
    a_ap=norm(w_ap);
    sigma=cos(psi_ap)+cos(deltasmax);
    if (sigma<0), deltas=pi+psi_ap;  
    else deltas=-sign(sin(psi_ap))*deltasmax;  
    end;
    fr = p5*v*sin(deltar);  fs = p4*a_ap*sin(deltas-psi_ap);
    dx=v*cos(theta)+p1*awind*cos(psi);
    dy=v*sin(theta)+p1*awind*sin(psi);
    dtheta=w;
    dv=(1/p9)*(sin(deltas)*fs-sin(deltar)*fr-p2*v^2);
    dw=(1/p10)*((p6-p7*cos(deltas))*fs-p8*cos(deltar)*fr-p3*w*v);
    xdot=([dx;dy;dtheta;dv;dw]);       
end

function [u,q] = control(x,q)
    theta=x(3);
    r=10; zeta=pi/4;
    m=[x(1);x(2)];     
    e=det([(b-a)/norm(b-a),m-a]);
    phi=angle(b-a);    
    if (abs(e)>r), q=sign(e); end;    
    thetabar=phi-atan(e/r);
    if (cos(psi-thetabar)+cos(zeta)<0)...   
        || ((abs(e)<r)&&(cos(psi-phi)+cos(zeta)<0))
        thetabar=pi+psi-zeta*q; 
    end;    
    deltar=0.3*sawtooth(theta-thetabar);
    deltasmax=pi/4*(cos(psi-thetabar)+1);     
    u=[deltar;deltasmax];
end

init;
x=[10;-40;-3;1;0]; %x=(x,y,theta,v,w)
p1=0.1; p2=1; p3=6000; p4=1000; p5=2000;
p6=1; p7=1; p8=2; p9=300;p10=10000;     
  
awind=2; psi=-2;  q=1; dt=0.1;
deltas=0; fs=0; fr=0;
a=[-1000;-2000];b=[1000;2000]; 

for t=0:dt:100,
     [u,q]=control(x,q);
     x=x+f(x,u)*dt;        
     draw(x,a,b);
     drawnow();
end;

end
