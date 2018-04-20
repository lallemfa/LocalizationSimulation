function staubli
    function T=Transl(v)
        T=eye(4,4); T(1:3,4)=v
    end
    function R=Rot(w)
        A=[0 -w(3) w(2); w(3) 0 -w(1);-w(2) w(1) 0];
        R=[expm(A),[0;0;0];0 0 0 1]
    end    
    function drawaxis(R)
        A=R*[0 1;0 0; 0 0; 1 1]; plot3(A(1,:),A(2,:),A(3,:),'red');
        A=R*[0 0;0 1; 0 0; 1 1]; plot3(A(1,:),A(2,:),A(3,:),'green');
        A=R*[0 0;0 0; 0 1; 1 1]; plot3(A(1,:),A(2,:),A(3,:),'blue');
    end
    function drawArm(R1,R2)
        J0=[-e 3*e -e -e; -e -e 3*e -e; 0 0 0 0; 1 1 1 1];
        J1=R1*J0; J2=R2*J0;
        J=[J1(:,1),J2(:,1),J2(:,2),J1(:,2),J1(:,3),J2(:,3),...
           J2(:,1),J2(:,2),J2(:,3),J1(:,3),J1(:,1),J1(:,2)];
        plot3(J(1,:),J(2,:),J(3,:),'black');
    end    
    function draw(q)
        clf; axis([-3 3 -3 3 -3 3]); axis square; hold on;
        R=eye(4,4); drawaxis(R);
        for j=1:length(a),
            Rold=R;
            R=R*Transl([0 0 r(j)])*Transl([d(j) 0 0])*Rot([0 a(j) 0]); 
            drawArm(Rold,R);
            R=R*Rot([0 0 q(j)]);
            drawaxis(R);   
        end
        drawnow();
    end

init;
e=0.1;
a=[0  ,pi/2,  0, -pi/2, -pi/2, -pi/2, 0  ];
d=[0  ,0.5 ,  0,  -0.1,  -0.3     -1, 0  ];
r=[1  ,0.5 ,  1,  0.1,     1    0.2,  0.2];
q=[0.3;0.3 ;0.3;  0;      1.5;  0.1;    1];
dt=0.05;
for i=1:length(a),
    for h=0:dt:2*pi, draw(q); q(i)=q(i)+dt; end;
end

end