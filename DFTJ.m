function [sig_dftj] = DFTJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,min_dly,max_dly,min_fd,max_fd,min_jsr,max_jsr,min_num,max_num)
%DFTJ 密集假目标干扰
%   
    K = B/Tp;
    t = (0:1/fs:pri-1/fs).';
    sig_dftj = zeros(length(t),pluse_num);

    dftj_num = round((max_num - min_num) * rand() + min_num);
    dftj_jsr = (max_jsr - min_jsr) * rand(dftj_num,1) + min_jsr;
    dftj_jsr_amp = 10.^(dftj_jsr/10);
    dftj_fd = (max_fd - min_fd) * rand(dftj_num,1) + min_fd;
    dftj_v = c*dftj_fd/2/f0;
    dftj_r_max = c*max_dly/2;
    dftj_r_min = c*min_dly/2;
    dftj_r = ((dftj_r_max - dftj_r_min) * rand(dftj_num,1) + dftj_r_min).*(2*randi([0,1],dftj_num,1)-1);
    dftj_r = target_p + dftj_r; %加上差的距离
    % 停跳模型
    for i = 1:dftj_num
        for j = 1:pluse_num
            tao = 2*(dftj_r(i)+(target_v+dftj_v(i))*(j-1)*pri)/c;
            fd = 2*target_v/c*f0 + dftj_fd(i);
            sig(:,j) = dftj_jsr_amp(i)*(abs((t-tao)/Tp) <= 0.5).*exp(1j*2*pi*K/2*(t-tao).^2).*exp(1j*2*pi*fd*(j-1)*pri); 
        end
        sig_dftj = sig_dftj + sig;
    end 
end

