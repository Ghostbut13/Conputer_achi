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
load -ASCII stringsearch_nset.mat
load -ASCII stringsearch_bsize.mat
load -ASCII stringsearch_associativity.mat
load -ASCII stringsearch_cachesize.mat
load -ASCII stringsearch_misses.mat
load -ASCII stringsearch_cpi.mat

%%% modify data<1KB
qsort_cachesize(1,1)=0.5;           % 0.5 KB
stringsearch_cachesize(1,1)=0.5;    % 0.5 KB

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
Q_num_ins=41898703;
S_num_ins=300951;
Q_miss_rate=qsort_misses./Q_num_ins;
S_miss_rate=stringsearch_misses./S_num_ins;

%%% calculate speedup (CPIbase)
Q_CPIbase=15.1828;
S_CPIbase=17.7021;
Q_speedup=Q_CPIbase./qsort_cpi;
S_speedup=S_CPIbase./stringsearch_cpi;

%%% ascending sort of cache size
Q=[qsort_cachesize,...
    qsort_nset,...
    qsort_bsize,...
    qsort_associativity,...
    Q_miss_rate,...
    Q_speedup];
S=[stringsearch_cachesize,...
    stringsearch_nset,...
    stringsearch_bsize,...
    stringsearch_associativity,...
    S_miss_rate,...
    S_speedup];
clear qs* str* tmp* S_* Q_*

Ascending_sort_cachesize_Q=sortrows(Q,[1 2 3 4]);
Ascending_sort_cachesize_S=sortrows(S,[1 2 3 4]);
Ascending_sort_bsize_Q=sortrows(Q,[3 2 4]);
%.....%


%%% draw 
%plot(Ascending_sort_cachesize_Q(:,5),Ascending_sort_cachesize_Q(:,6))
loglog(Ascending_sort_bsize_Q(:,2),Ascending_sort_bsize_Q(:,5)*1000)