function [sig_vdj] = VDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,min_fd,max_fd,min_jsr,max_jsr,min_num,max_num)
%VDJ 速度欺骗干扰
%   距离为真实速度
    K = B/Tp;
    t = (0:1/fs:pri-1/fs).';
    sig_vdj = zeros(length(t),pluse_num);

    vdj_num = round((max_num - min_num) * rand() + min_num);
    vdj_jsr = (max_jsr - min_jsr) * rand(vdj_num,1) + min_jsr;
    vdj_jsr_amp = 10.^(vdj_jsr/10);
    vdj_fd = (max_fd - min_fd) * rand(vdj_num,1) + min_fd;
    vdj_v = c*vdj_fd/2/f0;
    % 停跳模型
    for i = 1:vdj_num
        for j = 1:pluse_num
            tao = 2*(target_p+(target_v+vdj_v(i))*(j-1)*pri)/c;
            fd = 2*target_v/c*f0 + vdj_fd(i);
            sig(:,j) = vdj_jsr_amp(i)*(abs((t-tao)/Tp) <= 0.5).*exp(1j*2*pi*K/2*(t-tao).^2).*exp(1j*2*pi*fd*(j-1)*pri); 
        end
        sig_vdj = sig_vdj + sig;
    end 
end

