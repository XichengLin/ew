function [t,dis_axi,sig,target_p,target_v] = lfm_echo_gen(B,Tp,pri,fs,f0,pluse_num,c)
% 生成回波信号
    K = B/Tp;
    t = (0:1/fs:pri-1/fs).';
    sig = zeros(length(t),pluse_num);
    dis_axi = c*t/2/1e3; % 单位km

    min_r = c*Tp/2;
    max_r = c*pri/2 - min_r/2;
    % max_r = c*pri/2;
    max_v = c/4/f0/pri;
    min_v = -max_v;

    target_p = (max_r-min_r)*rand() + min_r;
    target_v = (max_v-min_v)*rand() + min_v;
    % % 多普勒模型  目前不太对
    % for i = 1:pluse_num
    %     tao = 2*(target_p+target_v*t)/c;
    %     fd = 2*target_v/c*f0;
    %     sig(:,i) = (abs((t-tao)/Tp) <= 0.5).*exp(1j*2*pi*K/2*(t-tao).^2).*exp(1j*2*pi*fd*(t-tao)); 
    %     sig(:,i) = (abs((t-tao)/Tp) <= 0.5).*exp(1j*2*pi*K/2*(t-tao).^2).*exp(1j*2*pi*fd*(pluse_num-1)*pri);
    %     target_p = target_p + target_v * pri;
    % end 

    % 停跳模型
    for i = 1:pluse_num
        tao = 2*(target_p+target_v*(i-1)*pri)/c;
        fd = 2*target_v/c*f0;
        sig(:,i) = (abs((t-tao)/Tp) <= 0.5).*exp(1j*2*pi*K/2*(t-tao).^2).*exp(1j*2*pi*fd*(i-1)*pri); 
    end 
end

