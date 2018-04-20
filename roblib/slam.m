function slam()
%--------------------------------------------------------------
    function draw(k,xhat,Gx,colortraj,colormark)
        if mod(k,200)==0  % We draw only every 200 steps
            draw_ellipse(xhat(1:2),Gx(1:2,1:2),0.9,colortraj,0.3);
            for i=4:2:length(xhat)-1,  % landmarks
                draw_ellipse(xhat(i:i+1),Gx(i:i+1,i:i+1),0.9,colormark,2);
            end
            drawnow;
        end
    end
%--------------------------------------------------------------
    function [y,C,Gbeta]=g(k)
        y=depth(k); C=zeros(1,nx); C(1,3)=1; Gbeta=0.01;
        T=[10540  10920 13740  17480  30380  36880  40240  48170  51720  52320  52790  56880;
            1      2     1      0       1      5      4      3     3      4      5     1  ;
            52.42  12.47 54.40  52.68  27.73  26.98  37.90  36.71  37.37  31.03  33.51  15.05];
        j=find(T(1,:)==k);
        if (~isempty(j))
            r=T(3,j);
            Rk=eulermat(phi(k),theta(k),psi(k));
            e=Rk*[0;-sqrt(r^2-(alt(k))^2);-alt(k)];
            y=[e(1:2);y];
            jm=3+2*T(2,j)+1; % component of the associated state vector
            C=[zeros(2,nx);C];
            C(1,1)=1; C(1,jm)=-1; C(2,2)=1; C(2,jm+1)=-1;
            Gbeta=diag([1 1 0.01]);
        end
    end
%--------------------------------------------------------------
    function predict()
        xhat=zeros(3,1);
        Gx=diag([0,0,0]);
        Galpha=0.01*eye(3,3);
        A=eye(3,3);
        for k=1:kmax,
            uk=dt*eulermat(phi(k),theta(k),psi(k))*vr(k,:)';
            [xhat,Gx]=kalman(xhat,Gx,uk,[],Galpha,[],A,[]);
            draw(k,xhat,Gx,'blue')
        end;
    end
%--------------------------------------------------------------
    function filter()
        xhat=zeros(nx,1);
        Gx=diag([0,0,0,10^6*ones(1,2*nm)]);
        Galpha=diag([0.01 0.01 0.01 zeros(1,2*nm)]);
        A=eye(nx,nx);
        for k=1:kmax,
            uk=[dt*eulermat(phi(k),theta(k),psi(k))*vr(k,:)';zeros(2*nm,1)];
            [y,C,Gbeta]=g(k);
            [xhat,Gx]=kalman(xhat,Gx,uk,y,Galpha,Gbeta,A,C);
            draw(k,xhat,Gx,'blue','black')
        end;
    end;
    %--------------------------------------------------------------
    function smoother()
        x_forw{1}=zeros(nx,1);
        G_forw{1}=diag([0,0,0,10^6*ones(1,2*nm)]);
        Galpha=diag([0.01 0.01 0.01 zeros(1,2*nm)]);
        A=eye(nx,nx);
        for k=1:kmax,
            Rk=eulermat(phi(k),theta(k),psi(k));
            u{k}=[dt*Rk*vr(k,:)';zeros(2*nm,1)];
            [y,C,Gbeta]=g(k);
            [x_forw{k+1},G_forw{k+1},xup{k},Gup{k}]=kalman(x_forw{k},G_forw{k},u{k},y,Galpha,Gbeta,A,C);
            draw(k,x_forw{k},G_forw{k},'blue','black')
        end;
        x_back{kmax}=xup{kmax};  G_back{kmax}=Gup{kmax};
        for k=kmax-1:-1:1,
            J=Gup{k}*A'/G_forw{k+1};
            x_back{k}=xup{k}+J*(x_back{k+1}-x_forw{k+1});
            G_back{k}=Gup{k}+J*(G_back{k+1}-G_forw{k+1})*J';
            draw(k,x_back{k},G_back{k},'red','black');
        end;
    end % smoother
%---------------------main program ---------------------------
init;
np=3; nm=6; nx=np+2*nm;
M=load('slam_data.txt');
t=M(:,1); phi=M(:,2); theta=M(:,3); psi=M(:,4); vr=M(:,5:7);
depth=M(:,8); alt=M(:,9);
dt=0.1; kmax=length(M);
hold on; axis([-200,900,-400,800]);
predict();
%filter();
%smoother();
end % end slam()

