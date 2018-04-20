function dubinspath
    function L =path(a,b,r,epsa,epsb)
        ca=a(1:2)+epsa*r*[-sin(a(3));cos(a(3))];
        cb=b(1:2)+epsb*r*[-sin(b(3));cos(b(3))];
        plot ([ca(1) cb(1)],[ca(2) cb(2)],'Oblack');
        draw_circle(ca,r,'black',1);
        draw_circle(cb,r,'blue',1);
        if (epsa*epsb==-1) % crossing
            ell2=0.25*norm(cb-ca)^2-r^2;
            if ell2<0, L=inf; return; end;
            ell=sqrt(ell2);
            alpha=-epsa*atan2(ell,r);
        else % no crossing
            ell=0.5*norm(cb-ca);
            alpha=-epsa*pi/2;
        end
        da=ca + (r/norm(cb-ca))*[cos(alpha),-sin(alpha);sin(alpha),cos(alpha)]*(cb-ca);
        db=cb+epsa*epsb*(da-ca);
        betaa=sawtooth(angle(a(1:2)-ca,da-ca),epsa);
        betab=sawtooth(angle(db-cb,b(1:2)-cb),epsb);
        draw_arc(ca,a(1:2),betaa,'black',2);
        draw_arc(cb,b(1:2),-betab,'blue',2);
        plot ([da(1) db(1)],[da(2) db(2)],'red','LineWidth',2);
        L=r*(abs(betaa)+abs(betab))+2*ell;
    end
%-----------------------------------------
init; r=10;
%a=[-r-8;0;pi/2]; b=[2.9*r-8;0;1.57]; ech=42;  %simu0
a=[-20;10;-3]; b=[20;-10;2]; ech=40;  %simu1
%a=[-3;1;0.9]; b=[2;-1;1]; ech=25;  %simu2
axis([-ech ech -ech ech]); axis square; hold on;
draw_tank(a,'black'); draw_tank(b,'blue');
L1=path(a,b,r,-1,-1); %RSR
L2=path(a,b,r,-1, 1); % RSL
L3=path(a,b,r, 1,-1); % LSR
L4=path(a,b,r, 1, 1); %LSL
L=min([L1,L2,L3,L4]);
clf; axis([-ech ech -ech ech]); axis square; hold on;
draw_tank(a,'black'); draw_tank(b,'blue');
if (L==L1), path(a,b,r,-1,-1); end;
if (L==L2), path(a,b,r,-1, 1); end;
if (L==L3), path(a,b,r, 1,-1); end;
if (L==L4), path(a,b,r, 1, 1); end;
end