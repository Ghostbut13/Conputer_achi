clear
clc
close

%% read
load -ASCII qsort_nset.mat
load -ASCII qsort_bsize.mat
load -ASCII qsort_associativity.mat
load -ASCII qsort_cachesize.mat
load -ASCII qsort_misses.mat
load -ASCII qsort_cpi.mat
load -ASCII qsort_cycles.mat
load -ASCII stringsearch_nset.mat
load -ASCII stringsearch_bsize.mat
load -ASCII stringsearch_associativity.mat
load -ASCII stringsearch_cachesize.mat
load -ASCII stringsearch_misses.mat
load -ASCII stringsearch_cpi.mat
load -ASCII stringsearch_cycles.mat

%% prepare
%%% change cachesize into KB
qsort_cachesize(:,1)=qsort_cachesize(:,1)/1024;           
stringsearch_cachesize(:,1)=stringsearch_cachesize(:,1)/1024;

%%% check the txt file and get the num_of_inst
Q_num_ins=41898703;
S_num_ins=300951;

%%% check cache size
tmpQ=qsort_nset.*...
    qsort_bsize.*...
    qsort_associativity./...
    1024;
tmpS=stringsearch_nset.*...
    stringsearch_bsize.*...
    stringsearch_associativity./...
    1024;
if( 0 ~= sum(sum(tmpQ-qsort_cachesize)) ...
        + sum(sum(tmpS-stringsearch_cachesize)) )
    disp ("redo your lab")
else
    disp ("yes, your cache size correct")
end

%%% calculate miss rates
Q_miss_rate=qsort_misses./Q_num_ins;
S_miss_rate=stringsearch_misses./S_num_ins;

%%% calculate speedup (CPIbase)
Q_CPIbase=15.1828;
S_CPIbase=17.7021;
Q_speedup=Q_CPIbase./qsort_cpi;
S_speedup=S_CPIbase./stringsearch_cpi;

%%% tidy uup
Q=[qsort_cachesize,...
    qsort_nset,...
    qsort_bsize,...
    qsort_associativity,...
    Q_miss_rate,...
    Q_speedup,...
    qsort_cycles];
S=[stringsearch_cachesize,...
    stringsearch_nset,...
    stringsearch_bsize,...
    stringsearch_associativity,...
    S_miss_rate,...
    S_speedup,...
    qsort_cycles];
clear qs* str* tmp* S_* Q_*

%% y: HIT_rate (which is 1-miss_rate) ; x: cache_size
%%% control parameters
clc
clear FIXED_cachesize FIXED_nset FIXED_bsize FIXED_associativity
clear cachesize nset bsize associativity Q_fixed_parameter
clear MISS_Y SPEEDUP_Y EXE_Y
cachesize=1;
nset=2;
bsize=3;
associativity=4;
Q_fixed_parameter=Q;

% % % --------------------------------------------------
% FIXED_cachesize=8;   % KB
% Q_row=find(Q_fixed_parameter(:,cachesize)==FIXED_cachesize);
% Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

% FIXED_nset = 32;   % 1 2  4  8  16 32
% Q_row=find(Q_fixed_parameter(:,nset)==FIXED_nset);
% Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_bsize = 128;  % 16 32  64  128 256
Q_row=find(Q_fixed_parameter(:,bsize)==FIXED_bsize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_associativity = 4;   % 1 2   4   8   16  32
Q_row=find(Q_fixed_parameter(:,associativity)==FIXED_associativity);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);
% % % ----------------------------------------------------

%%% Ascending_sort_Q
Ascending_sort_Q=sortrows(Q_fixed_parameter,[1 2 3 4]);
%%%draw
MISS_Y=5;
SPEEDUP_Y=6;
EXE_Y=7;

figure(1)
plot(Ascending_sort_Q(:,cachesize),1-Ascending_sort_Q(:,MISS_Y))
hold on
grid on
scatter(Ascending_sort_Q(:,cachesize),1-Ascending_sort_Q(:,MISS_Y),"filled")
[T,t]=title("","")
T.FontSize=10;
t.FontSize=9;
t.FontAngle="italic";
T.String=[" ";" HIT\_rate - Cache\_size Curve of qsort "]
t.String=["with fixed Bsize: 128-byte and Associativity : 4";" "]
xlabel("Cache\_size (KB)")
ylabel("HIT\_rate")

%% y: HIT_rate ; x: bsize with fixed cache_size and fixed nset
%%% control parameters
clc
clear FIXED_cachesize FIXED_nset FIXED_bsize FIXED_associativity
clear cachesize nset bsize associativity Q_fixed_parameter
clear MISS_Y SPEEDUP_Y EXE_Y
cachesize=1;
nset=2;
bsize=3;
associativity=4;
Q_fixed_parameter=Q;

% % % --------------------------------------------------
FIXED_cachesize = 8;   % 1 2 4 8 16 32 64 128 256 KB
Q_row=find(Q_fixed_parameter(:,cachesize)==FIXED_cachesize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_nset = 32;   % 1 2  4  8  16 32
Q_row=find(Q_fixed_parameter(:,nset)==FIXED_nset);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

% FIXED_bsize = 64;  % 16 32  64  128 256
% Q_row=find(Q_fixed_parameter(:,bsize)==FIXED_bsize);
% Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

% FIXED_associativity = 16;   % 1  2   4   8   16  32
% Q_row=find(Q_fixed_parameter(:,associativity)==FIXED_associativity);
% Q_fixed_parameter=Q_fixed_parameter(Q_row,:);
% % % ----------------------------------------------------

%%% Ascending_sort_Q
Ascending_sort_Q=sortrows(Q_fixed_parameter,[1 2 3 4]);
%%%draw
MISS_Y=5;
SPEEDUP_Y=6;
EXE_Y=7;

figure(2)
hold on
yyaxis left
plot(Ascending_sort_Q(:,bsize),1-Ascending_sort_Q(:,MISS_Y))
scatter(Ascending_sort_Q(:,bsize),1-Ascending_sort_Q(:,MISS_Y),"filled")
ylabel("HIT\_rate")

yyaxis right
plot(Ascending_sort_Q(:,bsize),Ascending_sort_Q(:,EXE_Y))
scatter(Ascending_sort_Q(:,bsize),Ascending_sort_Q(:,EXE_Y),"filled")
ylabel("Execution time (cycles)")

grid on
[T,t]=title("","")
T.FontSize=10;
t.FontSize=9;
t.FontAngle="italic";
T.String=[" ";" HIT\_rate - Block\_size Curve of qsort "]
t.String=["with fixed Nset: 32 and Cache\_size: 8 KB";" "]
xlabel("Block\_size (bytes)")


%% y: HIT_rate ; x: fully-asso-map
%%% control parameters
clc
yy=[];
clear FIXED_cachesize FIXED_nset FIXED_bsize FIXED_associativity
clear cachesize nset bsize associativity Q_fixed_parameter
clear MISS_Y SPEEDUP_Y EXE_Y
cachesize=1;
nset=2;
bsize=3;
associativity=4;
Q_fixed_parameter=Q;

% % % --------------------------------------------------
FIXED_cachesize = 4;   % 1 2 4 8 16 32 64 128 256 KB
Q_row=find(Q_fixed_parameter(:,cachesize)==FIXED_cachesize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_nset = 1;   % 1 2  4  8  16 32
Q_row=find(Q_fixed_parameter(:,nset)==FIXED_nset);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_bsize = 256;  % 16 32  64  128 256
Q_row=find(Q_fixed_parameter(:,bsize)==FIXED_bsize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_associativity = 16;   % 1 2   4   8   16  32
Q_row=find(Q_fixed_parameter(:,associativity)==FIXED_associativity);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);
% % % ----------------------------------------------------

%%% Ascending_sort_Q
Ascending_sort_Q=sortrows(Q_fixed_parameter,[1 2 3 4]);
%%%draw
MISS_Y=5;
SPEEDUP_Y=6;
EXE_Y=7;

yy(1,:)=1-Ascending_sort_Q(1,MISS_Y);
yyy(1,:)=Ascending_sort_Q(1,EXE_Y);

%% y: HIT_rate ; x: directly-map
%%% control parameters
clc
clear FIXED_cachesize FIXED_nset FIXED_bsize FIXED_associativity
clear cachesize nset bsize associativity Q_fixed_parameter
clear MISS_Y SPEEDUP_Y EXE_Y
cachesize=1;
nset=2;
bsize=3;
associativity=4;
Q_fixed_parameter=Q;

% % % --------------------------------------------------
FIXED_cachesize = 4;   % 1 2 4 8 16 32 64 128 256 KB
Q_row=find(Q_fixed_parameter(:,cachesize)==FIXED_cachesize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_nset = 16;   % 1 2  4  8  16 32
Q_row=find(Q_fixed_parameter(:,nset)==FIXED_nset);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_bsize = 256;  % 16 32  64  128 256
Q_row=find(Q_fixed_parameter(:,bsize)==FIXED_bsize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_associativity = 1;   % 1 2   4   8   16  32
Q_row=find(Q_fixed_parameter(:,associativity)==FIXED_associativity);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);
% % % ----------------------------------------------------

%%% Ascending_sort_Q
Ascending_sort_Q=sortrows(Q_fixed_parameter,[1 2 3 4]);
%%%draw
MISS_Y=5;
SPEEDUP_Y=6;
EXE_Y=7;

yy(2,:)=1-Ascending_sort_Q(1,MISS_Y);
yyy(2,:)=Ascending_sort_Q(1,EXE_Y);
%% y: HIT_rate ; x: N-way asso
%%% control parameters
clc
clear FIXED_cachesize FIXED_nset FIXED_bsize FIXED_associativity
clear cachesize nset bsize associativity Q_fixed_parameter
clear MISS_Y SPEEDUP_Y EXE_Y
cachesize=1;
nset=2;
bsize=3;
associativity=4;
Q_fixed_parameter=Q;

% % % --------------------------------------------------
FIXED_cachesize = 4;   % 1 2 4 8 16 32 64 128 256 KB
Q_row=find(Q_fixed_parameter(:,cachesize)==FIXED_cachesize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_nset = 4;   % 1 2  4  8  16 32
Q_row=find(Q_fixed_parameter(:,nset)==FIXED_nset);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_bsize = 256;  % 16 32  64  128 256
Q_row=find(Q_fixed_parameter(:,bsize)==FIXED_bsize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);

FIXED_associativity = 4;   % 1 2   4   8   16  32
Q_row=find(Q_fixed_parameter(:,associativity)==FIXED_associativity);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);
% % % ----------------------------------------------------

%%% Ascending_sort_Q
Ascending_sort_Q=sortrows(Q_fixed_parameter,[1 2 3 4]);
%%%draw
MISS_Y=5;
SPEEDUP_Y=6;
EXE_Y=7;

yy(3,:)=1-Ascending_sort_Q(1,MISS_Y);
yyy(3,:)=Ascending_sort_Q(1,EXE_Y);

%% draw: fully-2way-directly
figure(3)
yyaxis left
scatter([0.5,1.5,2.5],yy,"filled")
ylabel("HIT\_rate")

yyaxis right
scatter([0.5,1.5,2.5],yyy,"filled")
ylabel("Execution time (cycles)")

hold on
[T,t]=title("","")
T.FontSize=10;
t.FontSize=9;
t.FontAngle="italic";
T.String=[" ";" HIT\_rate - Cache\_size Curve of qsort "]
t.String=["with fixed Bsize: 128-byte and Associativity : 4";" "]
xlabel("Cache\_size (KB)")
ylabel("HIT\_rate")




%% where is the minimum
% [x,y]=find(Q==min(Q(:,7)))
% Q(x,:)