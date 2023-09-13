clear
clc
close

%%% read
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

%%% fix other's parameters
cachesize=1;
nset=2;
bsize=3;
associativity=4;


% FIXED_cachesize=1   %
FIXED_nset = 4   % 1 2  4  8  16 32
FIXED_bsize = 32  % 16 32  64  128 256
% FIXED_associativity = 8   % 1 2   4   8   16  32



Q_row=find(Q(:,nset)==FIXED_nset);
Q_fixed_parameter=Q(Q_row,:);
Q_row=find(Q_fixed_parameter(:,bsize)==FIXED_bsize);
Q_fixed_parameter=Q_fixed_parameter(Q_row,:);


%%% and ascending sort on (cache size or ........)
% Ascending_sort_cachesize_Q=sortrows(Q_fixed_parameter,[1 2 3 4]);
% Ascending_sort_cachesize_S=sortrows(S_fixed_parameter,[1 2 3 4]);
Ascending_sort_bsize_Q=sortrows(Q_fixed_parameter,[3 2 4]);
%.....%


%%% draw 
%plot(Ascending_sort_cachesize_Q(:,1),Ascending_sort_cachesize_Q(:,6))
plot(Ascending_sort_bsize_Q(:,associativity),Ascending_sort_bsize_Q(:,7))

%%% where is the minimum
[x,y]=find(Q==min(Q(:,7)))


