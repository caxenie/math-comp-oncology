% growth kinetics of Fortner Plasmatcytoma 1 tumors
% point are the mean mass of subcutaneous tumor implants in mice
% curve is the least-squares, best Gompertz model 
% error bars are +/- 1 stadard error of the mean at each point
% data from Simpson-Herren and Lloyd
function sample_growth_kinetics()
   n = [20 15 39 71 65 54 87 37 86 92 93 106 58 86 26 ...
       73 62 46 32 21 15 22 18];
   sd = [226 173 362 381 709 1054 1164 2591 2567 3176 ...
       3278 3371 3598 3521 3737 3704 3686 5206 5326 ...
       4805 4463 6279 4455];
   mass = [400 330 470 491 852 1440 1251 4638 3780 4377 ...
       5916 5940 8762 6927 13130 11600 9735 15120 ...
       13585 14170 16550 17970 19865];
   time = 4:1:26; 
   E = sd./sqrt(n);
   G0 = 0.789; 
   alpha= 0.107; 
   N0= 18.4;
   t = [4:.1:30];
   N_t= N0*exp(G0/alpha*(1-exp(-alpha*t)));
   figure(1);
   subplot(1, 2, 1);
   set(gcf, 'color','w');
   box off;
   hold on;
   plot(t,N_t,'k');
   h = errorbar(time,mass,E,'ko');
   ylabel('Tumor mass (mg)');
   xlabel('Time (days)');
   ylim([0,2.5e4]);   
   subplot(1, 2, 2);
   set(gcf, 'color','w')
   box off;
   semilogy(time,mass,'ko');
   hold on;
   semilogy(t,N_t,'k');
   box off;
   ylabel('log tumor mass');
   xlabel('Time (days)');
end