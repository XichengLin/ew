function [sig_snj] = SNJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,min_K,max_K,min_TL,max_TL,min_jsr,max_jsr,sig,sigma2)
%SNJ 灵巧噪声干扰
%   K为重复转发次数 TL为切片宽度
    K = B/Tp;
    t = (0:1/fs:pri-1/fs).';
    sig_snj = zeros(length(t),pluse_num);

    % 切片宽度 
    TL = (max_TL - min_TL) * rand() + min_TL;
    K = randi([min_K,max_K]);
    TL_num = round(TL*fs);
    Tp_num = Tp*fs;
    H = ceil(Tp_num/TL_num/(K+1)); % 切片数

    snj_jsr = (max_jsr - min_jsr) * rand() + min_jsr;
    snj_jsr_amp = 10.^(snj_jsr/10);

    for i = 1:pluse_num
        target_p_mid = target_p + (i-1)*target_v*pri;
        start_num = ceil((2*target_p_mid/c-Tp/2)*fs);
        end_num = start_num + H*(K+1)*TL_num - 1;
        sig_buffer = zeros(H*(K+1)*TL_num,1);
        if(end_num>length(t)) %超过末尾的点数
            sig_buffer(1:length(sig(start_num:end,i))) = sig(start_num:end,i);
            sig_buffer = reshape(sig_buffer,(K+1)*TL_num,H);
            sig_buffer = repmat(sig_buffer(1:TL_num,:),K+1,1);
            sig_buffer = reshape(sig_buffer,H*(K+1)*TL_num,1);
            valid_point = length(t) - start_num + 1;
            sig_snj(start_num:end,i) = snj_jsr_amp * sig_buffer(1:valid_point);
        else
            sig_buffer = sig(start_num:end_num,i);
            sig_buffer = reshape(sig_buffer,(K+1)*TL_num,H);
            sig_buffer = repmat(sig_buffer(1:TL_num,:),K+1,1);
            sig_buffer = reshape(sig_buffer,H*(K+1)*TL_num,1);
            sig_snj(start_num:end_num,i) = snj_jsr_amp * sig_buffer;
        end
    end

    noise = sqrt(sigma2)*(randn(length(t),pluse_num) + 1j*randn(length(t),pluse_num));
    sig_snj = sig_snj .* noise;