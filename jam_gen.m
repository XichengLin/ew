function [sig_jam] = jam_gen(jam_mode,B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,sig)
%JAM_GEN 生成干扰信号
%   干扰模式选择通过jam_mode实现
% 'a'    目标回波
% 'b'    DDJ
% 'c'    DFTJ
% 'd'    ISRJ
% 'e'    SNJ
% 'f'    VDJ
% 'g'    RVDJ
% 'h'    SMSPJ
% 'i'    ISRJ + DDJ
% 'j'    ISRJ + VDJ
% 'k'    SMSPJ + DDJ
% 'l'    SMSPJ + VDJ
    sig_jam = zeros(size(sig));

    switch jam_mode
        case 'a'
            sig_jam = sig_jam;
        case 'b'
            sig_jam = DDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,3,5,2,9);
        case 'c'
            sig_jam = DFTJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,-1e3,1e3,3,5,50,200);
        case 'd'
            sig_jam = ISRJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,3,5,1.5e-6,3e-6,3,5,sig);
        case 'e'
            sig_jam = SNJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,3,5,1.5e-6,3e-6,3,5,sig,1);
        case 'f'
            sig_jam = VDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,-1e3,1e3,3,5,2,9);
        case 'g'
            sig_jam = DFTJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,-1e3,1e3,3,5,4,8);
        case 'h'
            sig_jam = SMSPJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,4,8,3,5,sig);
        case 'i'
            sig_jam = ISRJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,3,5,1.5e-6,3e-6,10,10,sig) +...
                DDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,0,3,2,9);
        case 'j'
            sig_jam = ISRJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,3,5,1.5e-6,3e-6,10,10,sig) +...
                VDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,-1e3,1e3,3,3,2,9);
        case 'k'
            sig_jam = SMSPJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,4,8,10,10,sig) + ...
                DDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,3,5,2,9);
        case 'l'
            sig_jam = SMSPJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,4,8,10,10,sig) + ...
                VDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,-1e3,1e3,3,3,2,9);
        otherwise
            disp("干扰模式选择错误");
    end
end
% sig_ddj = DDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,3,5,2,9);
% sig_vdj = VDJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,-1e3,1e3,3,5,2,9);
% sig_dftj = DFTJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,-1e3,1e3,3,5,50,200);
% sig_rvdj = DFTJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,5e-7,5e-6,-1e3,1e3,3,5,4,8);
% sig_isrj = ISRJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,3,5,1.5e-6,3e-6,3,5,sig);
% sig_snj = SNJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,3,5,1.5e-6,3e-6,3,5,sig,1);
% sig_smspj = SMSPJ(B,Tp,pri,fs,f0,pluse_num,c,target_p,target_v,4,8,3,5,sig);