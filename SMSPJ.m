function [sig_smspj] = SMSPJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,min_M,max_M,min_jsr,max_jsr,sig)
%SMSPJ 频谱弥散干扰
    t = (0:1/fs:pri-1/fs).';
    sig_smspj = zeros(length(t),pluse_num);

    M = randi([min_M,max_M]);%M为抽样复制次数
    smspj_jsr = (max_jsr - min_jsr) * rand() + min_jsr;
    smspj_jsr_amp = 10.^(smspj_jsr/10);

    for i = 1:pluse_num
        target_p_mid = target_p + (i-1)*target_v*pri;
        start_num = ceil((2*target_p_mid/c-Tp/2)*fs);
        end_num = round(start_num + Tp*fs - 1);
        sig_buffer = sig(start_num:end_num,i);
        sig_buffer = sig_buffer(1:M:end);
        sig_buffer = repmat(sig_buffer,M,1);
        sig_buffer = sig_buffer(1:round(Tp*fs));
        sig_smspj(start_num:end_num,i) = smspj_jsr_amp * sig_buffer;

        % if(end_num>length(t)) %超过末尾的点数
        %     sig_buffer(1:length(sig(start_num:end,i))) = sig(start_num:end,i);
        %     sig_buffer = reshape(sig_buffer,(K+1)*TL_num,H);
        %     sig_buffer = repmat(sig_buffer(1:TL_num,:),K+1,1);
        %     sig_buffer = reshape(sig_buffer,H*(K+1)*TL_num,1);
        %     valid_point = length(t) - start_num + 1;
        %     sig_smspj(start_num:end,i) = smspj_jsr_amp * sig_buffer(1:valid_point);
        % else
        %     sig_buffer = sig(start_num:end_num,i);
        %     sig_buffer = sig_buffer(1:M:end);
        %     sig_buffer = repmat(sig_buffer,M,1);
        %     sig_buffer = sig_buffer(1:Tp*fs);
        %     sig_smspj(start_num:end_num,i) = smspj_jsr_amp * sig_buffer;
        % end
    end
