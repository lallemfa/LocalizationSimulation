function earth
%----------------------------------
    function p=T(lx,ly,rho)
        p=rho*[cos(ly)*cos(lx);cos(ly)*sin(lx);sin(ly)];
    end
%----------------------------------
    function draw_earth()
        M=[]; a=pi/10;
        Ly=-pi/2:a:pi/2; Lx=0:a:2*pi;
        for ly1=Ly, for lx1=Lx, M=[M,T(lx1,ly1,rho)]; end; end;
        plot3(M(1,:),M(2,:),M(3,:),'blue');
        M=[]; 
        for lx1=Lx, for ly1=Ly, M=[M,T(lx1,ly1,rho)]; end; end;
        plot3(M(1,:),M(2,:),M(3,:),'blue');                   
    end 
%------------------------------------------------
    function draw_rob(x,col,size)
        lx=x(1); ly=x(2); psi=x(3);
        rob0=[ 0  0  10  0   0   10   0   0 ;
              -1  1   0 -1  -0.2  0  0.2  1 ;
               0  0   0  0   1    0   1   0
               1  1   1  1   1    1   1   1  ] ;
        Rlatlong=[-sin(lx),-sin(ly)*cos(lx),cos(ly)*cos(lx);
               cos(lx),-sin(ly)*sin(lx),cos(ly)*sin(lx);
                    0    , cos(ly)        ,sin(ly)] ;  
        E=eulermat(0,0,psi); %phi,theta,psi
        R=[Rlatlong*E,T(lx,ly,rho);0 0 0 1];
        rob=R*rob0;
        plot3(rob(1,:),rob(2,:),rob(3,:),col,'LineWidth',size);
    end
%------------------------------------------------
    function draw(xa,x)
        clf; axis(rho*[-1,1,-1,1,-1,1]); axis square;hold on;
        draw_earth();          
        draw_rob(xa,'red',2)
        draw_rob(x,'black',2)
        drawnow();        
    end
%------------------------------------------------------
    function xdot=f(x,u)
        xdot=[cos(x(3))/(cos(x(2))*rho);sin(x(3))/rho;u];
    end
%----------------  Main  ------------------------
rho=30; 
init; dt=0.1;
xa=[0;0;0];
x=[3;1;1];
for t=0:dt:120,
   ua=0.1*randn(1);
   xa=xa+dt*f(xa,ua); 
   dx=xa-x;
   u=det([cos(x(3)) cos(x(2))*dx(1) ; sin(x(3)) dx(2)]);
   x=x+dt*f(x,u); 
   draw(xa,x);
end
end

