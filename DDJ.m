function [sig_ddj] = DDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,min_dly,max_dly,min_jsr,max_jsr,min_num,max_num)
%DDJ 距离欺骗干扰
%   速度为真实速度
    K = B/Tp;
    t = (0:1/fs:pri-1/fs).';
    sig_ddj = zeros(length(t),pluse_num);

    ddj_r_max = c*max_dly/2;
    ddj_r_min = c*min_dly/2;
    ddj_num = round((max_num - min_num) * rand() + min_num);
    ddj_jsr = (max_jsr - min_jsr) * rand(ddj_num,1) + min_jsr;
    ddj_jsr_amp = 10.^(ddj_jsr/10);
    ddj_r = ((ddj_r_max - ddj_r_min) * rand(ddj_num,1) + ddj_r_min).*(2*randi([0,1],ddj_num,1)-1);
    ddj_r = target_p + ddj_r; %加上差的距离

    % 停跳模型
    for i = 1:ddj_num
        for j = 1:pluse_num
            tao = 2*(ddj_r(i)+target_v*(j-1)*pri)/c;
            fd = 2*target_v/c*f0;
            sig(:,j) = ddj_jsr_amp(i)*(abs((t-tao)/Tp) <= 0.5).*exp(1j*2*pi*K/2*(t-tao).^2).*exp(1j*2*pi*fd*(j-1)*pri); 
        end
        sig_ddj = sig_ddj + sig;
    end 

    % for i = 1:ddj_num
    %     tao = 2*(ddj_r(i)+target_v*(i-1)*pri)/c;
    %     fd = 2*target_v/c*f0;
    %     sig_ddj(:,i) = ddj_jsr_amp(i)*(abs((t-tao)/Tp) <= 0.5).*exp(1j*2*pi*K/2*(t-tao).^2).*exp(1j*2*pi*fd*(i-1)*pri) + sig_ddj; 
    % end
end

