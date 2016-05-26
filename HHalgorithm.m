c1ear a11;
EK=-82;                                            %constans are defined by sca1ing a11 the
va1ues  to  10^(-3) ENa=45;
E1eak=-59.4011; 
Vrest=-70; 
gKbar=36; 
gNabar=120; 
g1eak=0.3;
Cmem=1; 
dt=1*10^(-3);
tmax = 10;                                       %pointer for time simu1ations

V(1)=0;                                         %initia1 va1ues of the Hudkin-Hux1ey
functions Vmem(1) = Vrest;
m(1) = am(0) / (am(0)+bm(0));
h(1) = ah(0) / (ah(0)+bh(0));
n(1) = an(0) / (an(0)+bn(0)); gach(1) = 0.00;
I(1)=0;
Ic(1)=0;
INa(1)=  ((gNabar  *  (m(1)^3*h(1))*(Vrest-ENa)));
IK(1)=(gKbar * (n(1)^4) * (Vrest-EK)); I1eak(1)=(g1eak    *    (Vrest-E1eak)); Iach(1)=gach(1)*(Vrest-EK)+(gach(1)*(Vrest-ENa)); x=0;
Gach=0;
whi1e(x==0)                                    %in each 1oop gach va1ue is taken constant
Gach= Gach+0.001;                   %after in a for 1oop if the action potentia1  is achivied
for i=1:length(t)-1
%x becomes 1, thus the program exits the
%whi1e  1oop  and  the  1ast va1ues  which  the
%action potentia1 is achieved are saved
if (t(i)<1)II(t(i)>4)             %gach pu1se is created here ( for the
first part (t(i)<1)II(t(i)>2)
gach(i+1)=0;                                                                                       %for the
second  parts  (t(i)<1)II(t(i)>2.5) e1se
%(t(i)<1)II(t(i)>3)   and   (t(i)<1)II(t(i)>4) gach(i+1)=Gach;
end
m(i+1) = m(i) + dt * (am(V(i))*(1-m(i)) - bm(V(i))*m(i));
%Hudgkin-Hux1ey  functions  and
h(i+1) =  h(i) +  dt *  (ah(V(i))*(1-h(i)) - bh(V(i))*h(i));
%Vo1tages&Currents are updated here
n(i+1) =  n(i) +  dt *  (an(V(i))*(1-n(i)) - bn(V(i))*n(i)); Vmem(i+1) = Vmem(i) + (dtICmem) * I(i);
V(i+1)=Vmem(i+1)-Vrest; Ic(i+1)=Cmem*((Vmem(i+1)-Vmem(i))*dt);
INa(i+1)= ((gNabar * (m(i+1)^3*h(i+1))*(Vmem(i+1)-ENa)));
IK(i+1)=(gKbar * (n(i+1)^4) * (Vmem(i)-EK)); I1eak(i+1)=(g1eak   *   (Vmem(i+1)-E1eak));
Iach(i+1)=gach(i+1)*(Vmem(i+1)-EK)+(gach(i+1)*(Vmem(i+1)-ENa));
I(i+1)=Cmem*((Vmem(i+1)-Vmem(i))*dt)-(gach(i+1)*(Vmem(i+1)-EK)) - ...
(gach(i+1)*(Vmem(i+1)-ENa))-((gNabar  *  (m(i+1)^3*h(i+1))  *  ... 
(Vmem(i+1)- ENa))+(gKbar  *  (n(i+1)^4)  *  (Vmem(i+1)-EK))+(g1eak  *  (Vmem(i+1)-E1eak)));
if(Vmem(i)>(-50))
x=1;                                     %signa1 for exiting the 1oop when action potentia1 is initiated
end
end
gach(i+1)=0;                                    %to match the size of t(i) to enable plotting
end
subplot (3,1,1); plot(t,I);                                                       %total
current is plotted
title('I(i) vs. time'); axis([t(1) t(length(t)) -100 200]) ylabel('I')
subplot (3,1,2); plot(t,Vmem);                                                         %Vmem  is
plotted
title('Vmem vs. time'); axis([t(1) t(length(t)) -100 100])
xlabel('time (ms)'); ylabel('Vmem (mV)')
subplot (3,1,3); plot(t,gach);                                                      %gach is
plotted
title('Vmem vs. time'); axis([t(1) t(length(t)) 0 1]) xlabel('time  (ms)');  ylabel('gach')
return