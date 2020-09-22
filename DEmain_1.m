clear all;
close all;
global TE G ts 
Size=30;  %��������
D=4;      %ÿ�������У����̶���,���ֳ�4��
Fmin=0.4;
Fmax=0.55;
CRmax=0.9;
CRmin=0.6;


Nmax=50;  %DE�Ż�����

TE=1;
TE1=1;TE2=1;TE3=1;     %�ο��켣����TE
q1d=1.0;q2d=1.0;q3d=0.6;

aim1=[TE1;q1d];%����·���յ�
aim2=[TE2;q2d];%����·���յ�
aim3=[TE3;q3d];

start=[0;0;0];%·�����
tmax=1*TE;  %����ʱ��

ts=0.001;   %Sampling time
G=tmax/ts;  %����ʱ��ΪG=3000
%***************���߲ο��켣*************%
q10=2;q20=0;q30=0;
q0=[q10 q20 q30];

dT=TE/1000; %��TE��Ϊ1000���㣬ÿ�γ���(����)ΪdT



for k=1:1:G
t(k)=k*dT;  %t(1)=0.001;t(2 )=0.002;.....
if t(k)<TE
    qr1(k)=(q1d-q10)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+q10;   %����ԭ��Ĳο��켣(1)
else 
    qr1(k)=q1d;
end
if t(k)<TE
    qr2(k)=(q2d-q20)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+q20;   %����ԭ��Ĳο��켣(1)
else 
    qr2(k)=q2d;
end
if t(k)<TE
    qr3(k)=(q3d-q30)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+q30;   %����ԭ��Ĳο��켣(1)
else 
    qr3(k)=q3d;
end

end
%***************��ʼ��·��**************%
for i=1:Size
    for j=1:D
    Path1(i,j)=rand*(q1d-q10)+q10;
    Path2(i,j)=rand*(q2d-q20)+q20;    
    Path3(i,j)=rand*(q3d-q30)+q30;   
    end
end
XX(1)=0;XX(2)=200*dT;XX(3)=400*dT;XX(4)=600*dT;XX(5)=800*dT;XX(6)=1000*dT;

%**********��ֽ�������***************%
for N=1:30
    CR=CRmin+(CRmax-CRmin)*N/Nmax;
    F=Fmax+(Fmin-Fmax)*N/Nmax;
  
%**************����**************%
    for i=1:Size
        %ȫ������
        object=[];
        for I=1:Size
            YY1(1)=q10;YY1(2)=Path1(I,1);YY1(3)=Path1(I,2);YY1(4)=Path1(I,3);YY1(5)=Path1(I,4);YY1(6)=q10;
            Path1_start=spline(XX,YY1(1:6),linspace(0,1,1000));
            YY2(1)=q10;YY2(2)=Path2(I,1);YY2(3)=Path2(I,2);YY2(4)=Path2(I,3);YY2(5)=Path2(I,4);YY2(6)=q20;
            Path2_start=spline(XX,YY2(1:6),linspace(0,1,1000));
            YY3(1)=q10;YY3(2)=Path3(I,1);YY3(3)=Path3(I,2);YY3(4)=Path3(I,3);YY3(5)=Path3(I,4);YY3(6)=q30;
            Path3_start=spline(XX,YY3(1:6),linspace(0,1,1000));
                for K=1:1000
                    Delta1(I,K)=abs(Path1_start(K)-qr1(K));
                    Delta2(I,K)=abs(Path2_start(K)-qr2(K));
                    Delta3(I,K)=abs(Path3_start(K)-qr3(K));
                end  
            object=[object,DEobj(Path1_start,Path2_start,Path3_start,Delta1(I,:),Delta2(I,:),Delta3(I,:),0)];  
        end
            [value,index]=min(object);
            Path1_global_best=Path1(index,:);
            Path2_global_best=Path3(index,:);
            Path3_global_best=Path3(index,:);
        %ȫ������
        
        %�ֲ�����
  
        r1=ceil(Size*rand);
        r2=ceil(Size*rand);
        r3=ceil(Size*rand);
        while(r1==r2||r1==r3||r2==r3||r1==i||r2==i||r3==i)%ѡȡ��ͬ��r1,r2,r3���Ҳ�����i
              r1=ceil(Size*rand);
              r2=ceil(Size*rand);
              r3=ceil(Size*rand);
        end
        for j=1:D
            mutate_Path1(i,j)=0.4*Path1(r1,j)+0.6*Path1_global_best(1,j)+F.*(Path1(r2,j)-Path1(r3,j));%ѡ��ǰ�벿�ֲ����������
            mutate_Path2(i,j)=0.4*Path2(r1,j)+0.6*Path2_global_best(1,j)+F.*(Path2(r2,j)-Path2(r3,j));%ѡ��ǰ�벿�ֲ����������
            mutate_Path3(i,j)=0.4*Path3(r1,j)+0.6*Path3_global_best(1,j)+F.*(Path3(r2,j)-Path3(r3,j));
        end
%****************����****************%
        for j=1:D
            if rand<=CR
                cross_Path1(i,j)=mutate_Path1(i,j);
                cross_Path2(i,j)=mutate_Path2(i,j);
                cross_Path3(i,j)=mutate_Path3(i,j);
            else
                cross_Path1(i,j)=Path1(i,j);
                cross_Path2(i,j)=Path2(i,j);
                cross_Path3(i,j)=Path3(i,j);
            end
        end
%�Ƚ�������������ֵ����ΪD=4ʱ���������%
        
        YY1(1)=q10;YY1(2)=cross_Path1(i,1);YY1(3)=cross_Path1(i,2);YY1(4)=cross_Path1(i,3);YY1(5)=cross_Path1(i,4);YY1(6)=q1d;
        YY2(1)=q20;YY2(2)=cross_Path2(i,1);YY2(3)=cross_Path2(i,2);YY2(4)=cross_Path2(i,3);YY2(5)=cross_Path2(i,4);YY2(6)=q2d;
        YY3(1)=q20;YY3(2)=cross_Path3(i,1);YY3(3)=cross_Path3(i,2);YY3(4)=cross_Path3(i,3);YY3(5)=cross_Path3(i,4);YY3(6)=q3d;
        
        dY=[0 0];
        cross_Path1_spline=spline(XX,YY1(1:6),linspace(0,1,1000));%�����ֵ��Ϻ�����ߣ�ע�ⲽ��nt��һ��,��ʱ���1000����
        cross_Path2_spline=spline(XX,YY2(1:6),linspace(0,1,1000));%�����ֵ��Ϻ�����ߣ�ע�ⲽ��nt��һ��,��ʱ���1000����
        cross_Path3_spline=spline(XX,YY3(1:6),linspace(0,1,1000));
        
        YY1(2)=Path1(i,1);YY1(3)=Path1(i,2);YY1(4)=Path1(i,3);YY1(5)=Path1(i,4);
        Path1_spline=spline(XX,YY1,linspace(0,1,1000));
        
        YY2(2)=Path2(i,1);YY2(3)=Path2(i,2);YY2(4)=Path2(i,3);YY2(5)=Path2(i,4);
        Path2_spline=spline(XX,YY2,linspace(0,1,1000));
        
        YY3(2)=Path3(i,1);YY3(3)=Path3(i,2);YY3(4)=Path3(i,3);YY3(5)=Path3(i,4);
        Path3_spline=spline(XX,YY3,linspace(0,1,1000));
%***   ����ָ�겢�Ƚ�***%
        for k=1:1000        
            delta1_cross(i,k)=abs(cross_Path1_spline(k)-qr1(k));          %���㽻���Ĺ켣��ο��켣�ľ���ֵ
            delta2_cross(i,k)=abs(cross_Path2_spline(k)-qr2(k));          %���㽻���Ĺ켣��ο��켣�ľ���ֵ
            delta3_cross(i,k)=abs(cross_Path3_spline(k)-qr3(k)); 
            delta_Path1(i,k)=abs(Path1_spline(k)-qr1(k));                 %�����ֵ��Ĺ켣��ο��켣�ľ���ֵ
            delta_Path2(i,k)=abs(Path2_spline(k)-qr2(k));                 %�����ֵ��Ĺ켣��ο��켣�ľ���ֵ
            delta_Path3(i,k)=abs(Path3_spline(k)-qr3(k));    
        end
        
        new_object    = DEobj(cross_Path1_spline,cross_Path2_spline,cross_Path3_spline,delta1_cross(i,:),delta2_cross(i,:),delta3_cross(i,:),0);   %���㽻��������������ͼ�·���ƽ����ֵ�ĺ�
        formal_object = DEobj(Path1_spline,Path2_spline,Path3_spline,delta_Path1(i,:),delta_Path2(i,:),delta_Path3(i,:),0);          %�����ֵ�������������ͼ�·���ƽ����ֵ�ĺ�

%%%%%%%%%%  ѡ���㷨  %%%%%%%%%%%
        if new_object<=formal_object
            Fitness(i)=new_object;
            Path1(i,:)=cross_Path1(i,:);
            Path2(i,:)=cross_Path2(i,:);
            Path3(i,:)=cross_Path3(i,:);
        else
            Fitness(i)=formal_object;            
            Path1(i,:)=Path1(i,:);
            Path2(i,:)=Path2(i,:);
            Path3(i,:)=Path3(i,:);
        end
    end
    [iteraion_fitness1(N),flag]=min(Fitness);%���µ�NC�ε�������С��ֵ����ά��
       
    lujing1(N,:)=Path1(flag,:);               %��NC�ε��������·��
    lujing2(N,:)=Path2(flag,:);               %��NC�ε��������·��
    lujing3(N,:)=Path3(flag,:);
    
    fprintf('��������=%d Ŀ�꺯��ֵ=%g\n',N,iteraion_fitness1(N));    
  
end

for N=31:50
    CR=CRmin+(CRmax-CRmin)*N/Nmax;
    F=Fmax+(Fmin-Fmax)*N/Nmax;
    for i=1:Size
        r1=ceil(Size*rand);
        r2=ceil(Size*rand);
        r3=ceil(Size*rand);
        while(r1==r2||r1==r3||r2==r3||r1==i||r2==i||r3==i)%ѡȡ��ͬ��r1,r2,r3���Ҳ�����i
              r1=ceil(Size*rand);
              r2=ceil(Size*rand);
              r3=ceil(Size*rand);
        end
        for j=1:D
            mutate_Path1(i,j)=Path1(r1,j)+F.*(Path1(r2,j)-Path1(r3,j));%ѡ��ǰ�벿�ֲ����������
            mutate_Path2(i,j)=Path2(r1,j)+F.*(Path2(r2,j)-Path2(r3,j));%ѡ��ǰ�벿�ֲ����������
            mutate_Path3(i,j)=Path3(r1,j)+F.*(Path3(r2,j)-Path3(r3,j));
        end
%****************����****************%
        for j=1:D
            if rand<=CR
                cross_Path1(i,j)=mutate_Path1(i,j);
                cross_Path2(i,j)=mutate_Path2(i,j);
                cross_Path3(i,j)=mutate_Path3(i,j);
            else
                cross_Path1(i,j)=Path1(i,j);
                cross_Path2(i,j)=Path2(i,j);
                cross_Path3(i,j)=Path3(i,j);
            end
        end
%�Ƚ�������������ֵ����ΪD=4ʱ���������%
        XX(1)=0;XX(2)=200*dT;XX(3)=400*dT;XX(4)=600*dT;XX(5)=800*dT;XX(6)=1000*dT;
        YY1(1)=q10;YY1(2)=cross_Path1(i,1);YY1(3)=cross_Path1(i,2);YY1(4)=cross_Path1(i,3);YY1(5)=cross_Path1(i,4);YY1(6)=q1d;
        YY2(1)=q20;YY2(2)=cross_Path2(i,1);YY2(3)=cross_Path2(i,2);YY2(4)=cross_Path2(i,3);YY2(5)=cross_Path2(i,4);YY2(6)=q2d;
        YY3(1)=q20;YY3(2)=cross_Path3(i,1);YY3(3)=cross_Path3(i,2);YY3(4)=cross_Path3(i,3);YY3(5)=cross_Path3(i,4);YY3(6)=q3d;
        
        dY=[0 0];
        cross_Path1_spline=spline(XX,YY1(1:6),linspace(0,1,1000));%�����ֵ��Ϻ�����ߣ�ע�ⲽ��nt��һ��,��ʱ���1000����
        cross_Path2_spline=spline(XX,YY2(1:6),linspace(0,1,1000));%�����ֵ��Ϻ�����ߣ�ע�ⲽ��nt��һ��,��ʱ���1000����
        cross_Path3_spline=spline(XX,YY3(1:6),linspace(0,1,1000));
        
        YY1(2)=Path1(i,1);YY1(3)=Path1(i,2);YY1(4)=Path1(i,3);YY1(5)=Path1(i,4);
        Path1_spline=spline(XX,YY1,linspace(0,1,1000));
        
        YY2(2)=Path2(i,1);YY2(3)=Path2(i,2);YY2(4)=Path2(i,3);YY2(5)=Path2(i,4);
        Path2_spline=spline(XX,YY2,linspace(0,1,1000));
        
        YY3(2)=Path3(i,1);YY3(3)=Path3(i,2);YY3(4)=Path3(i,3);YY3(5)=Path3(i,4);
        Path3_spline=spline(XX,YY3,linspace(0,1,1000));
%***   ����ָ�겢�Ƚ�***%
        for k=1:1000        
            delta1_cross(i,k)=abs(cross_Path1_spline(k)-qr1(k));          %���㽻���Ĺ켣��ο��켣�ľ���ֵ
            delta2_cross(i,k)=abs(cross_Path2_spline(k)-qr2(k));          %���㽻���Ĺ켣��ο��켣�ľ���ֵ
            delta3_cross(i,k)=abs(cross_Path3_spline(k)-qr3(k)); 
            delta_Path1(i,k)=abs(Path1_spline(k)-qr1(k));                 %�����ֵ��Ĺ켣��ο��켣�ľ���ֵ
            delta_Path2(i,k)=abs(Path2_spline(k)-qr2(k));                 %�����ֵ��Ĺ켣��ο��켣�ľ���ֵ
            delta_Path3(i,k)=abs(Path3_spline(k)-qr3(k));    
        end
        
        new_object    = DEobj(cross_Path1_spline,cross_Path2_spline,cross_Path3_spline,delta1_cross(i,:),delta2_cross(i,:),delta3_cross(i,:),0);   %���㽻��������������ͼ�·���ƽ����ֵ�ĺ�
        formal_object = DEobj(Path1_spline,Path2_spline,Path3_spline,delta_Path1(i,:),delta_Path2(i,:),delta_Path3(i,:),0);          %�����ֵ�������������ͼ�·���ƽ����ֵ�ĺ�

%%%%%%%%%%  ѡ���㷨  %%%%%%%%%%%
        if new_object<=formal_object
            Fitness(i)=new_object;
            Path1(i,:)=cross_Path1(i,:);
            Path2(i,:)=cross_Path2(i,:);
            Path3(i,:)=cross_Path3(i,:);
        else
            Fitness(i)=formal_object;            
            Path1(i,:)=Path1(i,:);
            Path2(i,:)=Path2(i,:);
            Path3(i,:)=Path3(i,:);
        end
    end
    [iteraion_fitness1(N),flag]=min(Fitness);%���µ�NC�ε�������С��ֵ����ά��
       
    lujing1(N,:)=Path1(flag,:);               %��NC�ε��������·��
    lujing2(N,:)=Path2(flag,:);               %��NC�ε��������·��
    lujing3(N,:)=Path3(flag,:);
    
    fprintf('��������=%d Ŀ�꺯��ֵ=%g\n',N,iteraion_fitness1(N));    
end
[Best_fitness,flag1]=min(iteraion_fitness1);
Best_solution1=lujing1(flag1,:);
Best_solution2=lujing2(flag1,:);
Best_solution3=lujing3(flag1,:);


YY1(2)=Best_solution1(1);YY1(3)=Best_solution1(2);YY1(4)=Best_solution1(3);YY1(5)=Best_solution1(4);
YY2(2)=Best_solution2(1);YY2(3)=Best_solution2(2);YY2(4)=Best_solution2(3);YY2(5)=Best_solution2(4);
YY3(2)=Best_solution3(1);YY3(3)=Best_solution3(2);YY3(4)=Best_solution3(3);YY3(5)=Best_solution3(4);

Finally_spline1dis=spline(XX,YY1,linspace(0,1,1000));
Finally_spline2dis=spline(XX,YY2,linspace(0,1,1000));
Finally_spline3dis=spline(XX,YY3,linspace(0,1,1000));
DEobj(Finally_spline1dis,Finally_spline2dis,Finally_spline3dis,delta_Path1(Size,:),delta_Path2(Size,:),delta_Path3(Size,:),1);



figure(3);
plot((1:Nmax),iteraion_fitness1,'k','linewidth',1);
xlabel('Time (s)');ylabel('Fitness Change');
