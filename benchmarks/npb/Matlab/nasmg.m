function nasmg(class)
%
% FUNCTION nasmg(class)
% 
% Kernal MG: a simple 3D multigrid benchmark. From "The NAS Parallel
% Benchmarks", RNR Technical Report RNR-94-007, March 1994.
% Function coded by: Benjamin J Buss, The Ohio State University (2004)
%
% INPUT(S):
%   class [optional] -- This code is set up to run one of any of the 5
%     specified classes of the problem.  The class may be passed in as an
%     agrument or entered when the menu prompts the user to enter the class.
%     Valid arguments are:
%      {'S','s',0} = Class S problem -- Sample to ensure code is error-free
%      {'W','w',1} = Class W problem -- Intended to run on workstations
%      {'A','a',2} = Class A problem
%      {'B','b',3} = Class B problem
%      {'C','c',4} = Class C problem -- Not tested
%
% Displayed to screen:
%     Header including CLASS, SIZE and number of ITERATIONS
%     INITIALIZATION TIME
%     An indication of completion
%     An indication of whether the checksum is correct or not
%     IF verification fails: "CORRECT" L2 NORM
%     Calculated L2 NORM and ERROR
%     A summary table: CLASS, SIZE, ITERATIONS, TIME, Mop/s, OP TYPE,
%     SUCCESS/FAILURE, VERSION, and RUN DATE.
%
% REQUIRES vranlc.m to run <-- included in this file for this version, but
% will separate if a toolbox is created.

if nargin ~= 1,
    class=input('Please choose to run one of the following:\n (0) Class S\n (1) Class W\n (2) Class A\n (3) Class B\n (4) Class C\n');
end

switch class
    case {'S','s',0}
        class='S'; mtxdim=32; nit=4; L2_norm_ref=0.530770700573*10^(-04); runclass='Running Class S benchmark.';
    case {'W','w',1}
        class='W'; mtxdim=64; nit=40; L2_norm_ref=0.250391406439*10^(-17); runclass='Running Class W benchmark.';
    case {'A','a',2}
        class='A'; mtxdim=256; nit=4; L2_norm_ref=0.2433365309*10^(-05); runclass='Running Class A benchmark.';
    case {'B','b',3}
        class='B'; mtxdim=256; nit=20; L2_norm_ref=0.180056440132*10^(-05); runclass='Running Class B benchmark.';
    case {'C','c',4}
        class='C'; mtxdim=512; nit=20; L2_norm_ref=0.570674826298*10^(-06); runclass='Running Class C benchmark.';
end

% Display to screen:
fprintf('\n %s \n\n','NAS Parallel Benchmarks in MATLAB-serial version - MG Benchmark')
fprintf(' %s\n',runclass)
fprintf(' %s %3d%2s%3d%2s%3d\n','Size:',mtxdim,'x',mtxdim,'x',mtxdim)
fprintf(' %s %5d\n\n','Iterations:',nit)

t0=clock; % Start initialization timer.
switch class
    case {'A','S','W'}
        %% Coefficients for the S(a) smoother
        s=[-3/8, 1/32, -1/64, 0];
    otherwise
        %% Coefficients for the S(b) smoother
        s=[-3/17, 1/33, -1/61, 0];
end

% Create v
v=makev(mtxdim);
v=padarray(v,[1 1 1],'circular','both');

% Uncomment the following to see coordinates and values for non-zeros in v:
%displaynonzeros(v)

% Initialize other variables:
u=zeros(size(v));  
k=fix(log2(mtxdim));

init_time_sec=etime(clock,t0);
fprintf(' %s %6.3f %s\n\n','Initialization time:',init_time_sec,'seconds')
t0=clock; % Restart timer.

% V-cycle multigrid operator (Table 2.3)
% evaluate residual (RESID)
r=v-dlaplacian(u,[-8/3,0,1/6,1/12]);

for i=1:nit,
    % apply correction (RECURSIVE MACHINE)
    u=u+Vcycle(k,r,s); 
    
    % evaluate residual (RESID)
    r=v-dlaplacian(u,[-8/3,0,1/6,1/12]);
end

% Verification test:
L2_norm=sqrt( sum(sum(sum(r(2:end-1,2:end-1,2:end-1).^2)))/((size(r,1)-2)^3) );
a=max(max(max(abs(r(2:end-1,2:end-1,2:end-1)))));

benchmark_time_sec=etime(clock,t0);   % End timer.

fprintf(' %s\n','Benchmark Completed.')
% Reference value --> absolute tolerance of 10^(-14)
error=max(abs(L2_norm_ref-L2_norm));
if (error<10^-14)
    fprintf(' %s\n','VERIFICATION SUCESSFUL')
    verif='SUCCESSFUL';
else    
    fprintf(' %s\n','VERIFICATION FAILED')
    verif='UNSECCESSFUL';
    fprintf(' %s %11.12e\n','The CORRECT L2 Norm is',L2_norm_ref)
end
fprintf(' %s %11.12e\n','L2 Norm is',L2_norm)
fprintf(' %s %11.12e\n\n','Error is  ',error)

fprintf('%s\n',' MG Benchmark Completed.')
fprintf('%s %15s\n',' Class           = ',class)
fprintf('%s %5d%2s%3d%2s%3d\n',' Size            = ',mtxdim,'x',mtxdim,'x',mtxdim)
fprintf('%s %15d\n',' Iterations      = ',nit)
fprintf('%s %15.3f\n',' Time in seconds = ',benchmark_time_sec)
fprintf('%s %15s\n',' Mop/s total     = ','unknown')
fprintf('%s %15s\n',' Operation type  = ','floating point')
fprintf('%s %15s\n',' Verification    = ',verif)
fprintf('%s %15s\n',' Version         = ','MATLAB')
fprintf('%s %15s\n\n',' Run date        = ',date)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [z]=Vcycle(k,r,s)
if k>1,
    % restrict residual (Fine2Coarse) (RPRJ3)
    temp=dlaplacian(padarray(r(2:end-1,2:end-1,2:end-1),[2 2 2],'circular','both'),[1/2,1/4, 1/8,1/16]);
    rn=zeros(size(temp)/2);
    rn(1:end,1:end,1:end)=temp(2:2:end,2:2:end,2:2:end);
    
    % recursive solve (RECURSIVE CALL)
    zn=Vcycle(k-1,rn,s);
    
    % prolongate (Coarse2Fine) (INTER)
    z=zeros(2*(size(zn)));
    z(1:2:end,1:2:end,1:2:end)=zn;
    z=dlaplacian(z,[1,1/2,1/4,1/8]);
    z=z(1:end-2,1:end-2,1:end-2);
    
    % evaluate residual (RESID)   
    temp=dlaplacian(padarray(z(2:end-1,2:end-1,2:end-1),[2 2 2],'circular','both'),[-8/3,0,1/6,1/12]);
    r=r-temp(2:end-1,2:end-1,2:end-1);  
    
    % apply smoother (PSINV)  
    temp=dlaplacian(padarray(r(2:end-1,2:end-1,2:end-1),[2 2 2],'circular','both'),s);
    z=z+temp(2:end-1,2:end-1,2:end-1);    
    clear temp
else
    % apply smoother (PSINV)  
    z=dlaplacian(r,s);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v=makev(mtxdim)
%% Makes the v matrix for the NAS MG algorithm.  It functions as if
%% creating a cube using the specified random number generator, then finding
%% the positions of the largest and smallest 10 values.  The created v matrix 
%% is then all zeros except for the positions found to contain the 20 values
%% specified above.  The positions of the largest and smallest values contain
%% 1 and -1 respectively.
[v,ind]=sort(vranlc(314159265,mtxdim^3));
v=zeros(mtxdim,mtxdim,mtxdim);
v(ind(1:10))=-1;
v(ind(end-9:end))=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m=dlaplacian(n,f)
c=1:size(n,1);
u=[c(2:end) c(1)];
d=[c(end) c(1:end-1)];
m = f(1).*(n(c,c,c)) + f(2).*(n(c,c,u)+n(c,c,d)+n(c,u,c)+n(c,d,c)+n(u,c,c)+n(d,c,c)) + f(3).*(n(c,u,u)+n(c,u,d)+n(c,d,u)+n(c,d,d)+n(u,c,u)+n(u,c,d)+n(d,c,u)+n(d,c,d)+n(u,u,c)+n(u,d,c)+n(d,u,c)+n(d,d,c)) + f(4).*(n(u,u,u)+n(u,u,d)+n(u,d,u)+n(u,d,d)+n(d,u,u)+n(d,u,d)+n(d,d,u)+n(d,d,d));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function displaynonzeros(v)
%% Displays the coordinates (1D & 3D) and values 
%% for all non-zero values in v
coord=find(v);
[fi,fii,fval]=find(v);
[fj,fk]=ind2sub(size(v,3),fii);
coord_3d_val=[coord fi fj fk fval]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y,x] = vranlc(x,n)
%
%% FUNCTION: [y,x]=vranlc(x,n)
%% INPUTS:
%%   x = seed
%%   n = number of pseudorandom numbers desired
%% OUTPUTS:
%%   y = vector of n pseudorandom numbers
%%   x = altered seed so the sequence can be continued
%%
%% THIS IS A DIRECT TRANSLATION TO MATLAB FROM THE FORTRAN VERSION SUCH 
%% THAT a=fix(5^13) IS DEFINED INTERNALLY.  THESE COMMENTS FROM THE FORTRAN
%% VERSION:
%c---------------------------------------------------------------------
%c
%c   This routine generates N uniform pseudorandom double precision numbers in
%c   the range (0, 1) by using the linear congruential generator
%c
%c   x_{k+1} = a x_k  (mod 2^46)
%c
%c   where 0 < x_k < 2^46 and 0 < a < 2^46.  This scheme generates 2^44 numbers
%c   before repeating.  The argument A is the same as 'a' in the above formula,
%c   and X is the same as x_0.  A and X must be odd double precision integers
%c   in the range (1, 2^46).  The N results are placed in Y and are normalized
%c   to be between 0 and 1.  X is updated to contain the new seed, so that
%c   subsequent calls to VRANLC using the same arguments will generate a
%c   continuous sequence.  If N is zero, only initialization is performed, and
%c   the variables X, A and Y are ignored.
%c
%c   This routine is the standard version designed for scalar or RISC systems.
%c   However, it should produce the same results on any single processor
%c   computer with at least 48 mantissa bits in double precision floating point
%c   data.  On 64 bit systems, double precision should be disabled.
%c
%c---------------------------------------------------------------------

      a=fix(5^13);
      y=zeros(n,1);
%%      integer i,n
%%      double precision y,r23,r46,t23,t46,a,x,t1,t2,t3,t4,a1,a2,x1,x2,z
%%      dimension y(*)
r23 = 0.5^23; r46 = r23^2; t23 = 2.0^23; t46 = t23^2;

%c---------------------------------------------------------------------
%c   Break A into two parts such that A = 2^23 * A1 + A2.
%c---------------------------------------------------------------------
      t1 = r23 * a;
      a1 = fix (t1);
      a2 = a - t23 * a1;

%c---------------------------------------------------------------------
%c   Generate N results.   This loop is not vectorizable.
%c---------------------------------------------------------------------
      for i = 1:n,

%c---------------------------------------------------------------------
%c   Break X into two parts such that X = 2^23 * X1 + X2, compute
%c   Z = A1 * X2 + A2 * X1  (mod 2^23), and then
%c   X = 2^23 * Z + A2 * X2  (mod 2^46).
%c---------------------------------------------------------------------
        t1 = r23 * x;
        x1 = fix (t1);
        x2 = x - t23 * x1;
        t1 = a1 * x2 + a2 * x1;
        t2 = fix (r23 * t1);
        z = t1 - t23 * t2;
        t3 = t23 * z + a2 * x2;
        t4 = fix (r46 * t3);
        x = t3 - t46 * t4;
        y(i) = r46 * x;
      end