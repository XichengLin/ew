clear;clc;

%% 定义常量
c = 3e8;
f0 = 15e9;
fs = 20e6;
B = 10e6;
Tp = 20e-6;
pri = 100e-6;
pluse_num = 128;
lambda = c/f0;

%% 生成随机位置随机速度单目标回波信号 添加噪声
[t,dis_axi,sig,target_p,target_v] = lfm_echo_gen(B,Tp,pri,fs,f0,pluse_num,c); 
% 添加底噪
snr = 0; %信噪比  % 10*log10(1/2*(sigma^2)) = snr 
sigma2 = 1/(10^(snr/10))/2; %实部或虚部sigma^2
noise = sqrt(sigma2)*(randn(length(sig(:,1)),pluse_num) + 1j*randn(length(sig(:,1)),pluse_num));

% plot(dis_axi,real(sig(:,1))); %时域
% plot(linspace(-fs/2,fs/2,length(t)),ifftshift(abs(fft(sig(:,1))))); %频域

%% 进行干扰 min_dly和max_dly都是正数 min_fd和max_fd前负后正
sig_jam = jam_gen('a',B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,sig);
sig = sig + noise + sig_jam;
%% 干扰评估

% *进行pc mtd 并画图
[pc_out,mtd_out] = pc_mtd(sig,B,Tp,pri,fs,pluse_num);
figure(1);
mesh(lambda/4/pri/(pluse_num/2)*(-pluse_num/2:pluse_num/2-1),dis_axi,10*log10(abs(mtd_out)));

% 取单帧
sig_single = sig(:,1);
stft_win_len = 32;
overlap_num = 24;
stft_nfft = 100;
[sig_stft,f_stft,t_stft] = stft(sig_single,fs,"Window",hamming(stft_win_len),...
    "OverlapLength",overlap_num,"FFTLength",stft_nfft);
figure(2);
mesh(t_stft,f_stft,(abs(sig_stft)));


