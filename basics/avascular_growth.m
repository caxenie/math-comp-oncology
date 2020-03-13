function avascular_growth()
m = 0;
x = linspace(0,200,200);
t = linspace(0,14,141);
sol = pdepe(m,@mypde,@myic,@mybc,x,t);
u1 = sol(:,:,1);
u2 = sol(:,:,2);
u3 = sol(:,:,3);
set(gcf, 'color','w');
subplot(3,1,1)
hold on
for i=0:2:14
    plot(x,u1(i*10+1,:)); box off;
end
ylabel('Proliferating cells, p');
xlim([0 200]); ylim([-.1 .6]);
subplot(3,1,2)
hold on
for i=0:2:14
    plot(x,u2(i*10+1,:));
end
ylabel('Quiescent cells, q');
xlim([0 200]); ylim([-.1 .6]);
subplot(3,1,3)
hold on
for i=0:2:14
    plot(x,u3(i*10+1,:));
end
ylabel('Necrotic cells, n');
xlabel('Space, x');
xlim([0 200]); ylim([-.1 1.1]);
% -------------------------------------
function [c,f,s] = mypde(x,t,u,DuDx)
c = [1; 1; 1];
co = 1; alpha = .8; gamma = 9;
k = (co*gamma*(1-alpha*...
    (u(1)+u(2)+u(3))))/(gamma+u(1));
fc = .5*(1-tanh(4*k-2));
gc = 1+.1*k;
hc = .5*fc;
f = [u(1)/(u(1)+u(2)) * (DuDx(1) + DuDx(2));
    u(2)/(u(1)+u(2)) * (DuDx(1) + DuDx(2));
    0];
s = [gc*(u(1)*(1-u(1)-u(2)-u(3))) - fc*u(1);
    fc*u(1) - hc*u(2);
    hc*u(2)];
% -----------------------------------------------
function u0 = myic(x)
u0 = [exp(-.1*x); 0; 0];
% -----------------------------------------------
function [pl,ql,pr,qr] = mybc(xl,ul,xr,ur,t)
pl = [0; 0; 0];
ql = [1; 1; 1];
pr = [0; 0; 0];
qr = [1; 1; 1];
