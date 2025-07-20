function [pc_out,mtd_out] = pc_mtd(sig,B,Tp,pri,fs,pluse_num)
%PC_MTD 进行脉冲压缩 和MTD
    K = B/Tp;
    pc_t = (-Tp/2:1/fs:Tp/2).';
    pc_sig = exp(-1j*2*pi*K/2*(-pc_t).^2);
    % plot(real(pc_sig));
    % 计算fft点数
    pc_num = round(Tp*fs)/2;
    pri_num = pri*fs;
    nfft_min = (Tp+pri)*fs + 1;
    nfft = 2^nextpow2(nfft_min);
    %pc加窗
    pc_win = hanning(length(pc_sig));
    pc_sig = pc_sig.*pc_win;

    sig_w = fft(sig,nfft,1);
    pc_w = fft(pc_sig,nfft);

    for i = 1:pluse_num
        sig_w(:,i) = sig_w(:,i).*pc_w;
    end
    pc_out = ifft(sig_w,nfft,1);
    pc_out = pc_out(1+pc_num:pc_num+pri_num,:);

    % mtd加窗
    mtd_win = hanning(pluse_num).';
    % mtd_win = rectwin(pluse_num).';

    mtd_out = zeros(size(pc_out));
    for i = 1:pri_num
        mtd_out(i,:) = pc_out(i,:).*mtd_win;
    end
    mtd_out = fftshift(fft(mtd_out,pluse_num,2),2);
end

