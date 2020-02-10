%% Notes

% This code simulates the three-compartment model with and without
% treatment for particular values of the tumor growth parameters. As an
% example, the result using parameter values obtained from fitting the
% Roland dataset are used (parameter values are listed in Table S4). Once  
% the tumor has reached a size of 0.1 cm3, bevacizumab is administered 
% twice weekly at a dose of 2 mg/kg for 6 weeks. The RTV value calculated
% here matches the results listed in Table S4.

% The code calls the "Model_equations.m" function, which contains the model
% parameter values and differential equations.

%% specify initial conditions
clear all;
close all

initvalue(1,1) = 0;
initvalue(2,1) = 0;
initvalue(3,1) = 8.1958e-11;
initvalue(4,1) = 9.0241e-12;
initvalue(5,1) = 4.0886e-11;
initvalue(6,1) = 1.3572e-14;
initvalue(7,1) = 9.048e-15;
initvalue(8,1) = 4.524e-13;
initvalue(9,1) = 0;
initvalue(10,1) = 0;
initvalue(11,1) = 0;
initvalue(12,1) = 0;
initvalue(13,1) = 0;
initvalue(14,1) = 0;
initvalue(15,1) = 0;
initvalue(16,1) = 0;
initvalue(17,1) = 0;
initvalue(18,1) = 0;
initvalue(19,1) = 0;
initvalue(20,1) = 2.2594e-12;
initvalue(21,1) = 0;
initvalue(22,1) = 0;
initvalue(23,1) = 0;
initvalue(24,1) = 0;
initvalue(25,1) = 0;
initvalue(26,1) = 0;
initvalue(27,1) = 0;
initvalue(28,1) = 0;
initvalue(29,1) = 0;
initvalue(30,1) = 0;
initvalue(31,1) = 0;
initvalue(32,1) = 0;
initvalue(33,1) = 0;
initvalue(34,1) = 0;
initvalue(35,1) = 0;
initvalue(36,1) = 0;
initvalue(37,1) = 0;
initvalue(38,1) = 0;
initvalue(39,1) = 0;
initvalue(40,1) = 0;
initvalue(41,1) = 0;
initvalue(42,1) = 0;
initvalue(43,1) = 0;
initvalue(44,1) = 0;
initvalue(45,1) = 0;
initvalue(46,1) = 0;
initvalue(47,1) = 0;
initvalue(48,1) = 0;
initvalue(49,1) = 0;
initvalue(50,1) = 0;
initvalue(51,1) = 0;
initvalue(52,1) = 0;
initvalue(53,1) = 0;
initvalue(54,1) = 0;
initvalue(55,1) = 0;
initvalue(56,1) = 1.7008e-13;
initvalue(57,1) = 1.1338e-13;
initvalue(58,1) = 5.6692e-12;
initvalue(59,1) = 0;
initvalue(60,1) = 0;
initvalue(61,1) = 0;
initvalue(62,1) = 0;
initvalue(63,1) = 0;
initvalue(64,1) = 0;
initvalue(65,1) = 0;
initvalue(66,1) = 0;
initvalue(67,1) = 6.227e-16;
initvalue(68,1) = 4.9816e-17;
initvalue(69,1) = 6.6003e-15;
initvalue(70,1) = 0;
initvalue(71,1) = 0;
initvalue(72,1) = 0;
initvalue(73,1) = 0;
initvalue(74,1) = 0;
initvalue(75,1) = 0;
initvalue(76,1) = 0;
initvalue(77,1) = 0;
initvalue(78,1) = 0;
initvalue(79,1) = 0;
initvalue(80,1) = 0;
initvalue(81,1) = 0;
initvalue(82,1) = 0;
initvalue(83,1) = 0;
initvalue(84,1) = 0;
initvalue(85,1) = 0;
initvalue(86,1) = 0;
initvalue(87,1) = 0;
initvalue(88,1) = 0;
initvalue(89,1) = 0;
initvalue(90,1) = 0;
initvalue(91,1) = 0;
initvalue(92,1) = 0;
initvalue(93,1) = 0;
initvalue(94,1) = 0;
initvalue(95,1) = 0;
initvalue(96,1) = 0;
initvalue(97,1) = 0;
initvalue(98,1) = 0;
initvalue(99,1) = 0;
initvalue(100,1) = 0;
initvalue(101,1) = 0;
initvalue(102,1) = 0;
initvalue(103,1) = 0;
initvalue(104,1) = 0;
initvalue(105,1) = 0;
initvalue(106,1) = 0;
initvalue(107,1) = 0;
initvalue(108,1) = 0;
initvalue(109,1) = 0;
initvalue(110,1) = 0;
initvalue(111,1) = 0;
initvalue(112,1) = 0;
initvalue(113,1) = 0;
initvalue(114,1) = 0;
initvalue(115,1) = 0;
initvalue(116,1) = 0;
initvalue(117,1) = 0;
initvalue(118,1) = 0;
initvalue(119,1) = 0;
initvalue(120,1) = 0;
initvalue(121,1) = 0;
initvalue(122,1) = 0;
initvalue(123,1) = 0;
initvalue(124,1) = 0;
initvalue(125,1) = 0;
initvalue(126,1) = 0;
initvalue(127,1) = 0;
initvalue(128,1) = 0;
initvalue(129,1) = 0;
initvalue(130,1) = 0;
initvalue(131,1) = 0;
initvalue(132,1) = 0;
initvalue(133,1) = 0;
initvalue(134,1) = 0;
initvalue(135,1) = 0;
initvalue(136,1) = 0;
initvalue(137,1) = 0;
initvalue(138,1) = 0;
initvalue(139,1) = 0;
initvalue(140,1) = 0;
initvalue(141,1) = 0;
initvalue(142,1) = 0;
initvalue(143,1) = 0;
initvalue(144,1) = 0;
initvalue(145,1) = 0;
initvalue(146,1) = 0;
initvalue(147,1) = 0;
initvalue(148,1) = 0;
initvalue(149,1) = 0;
initvalue(150,1) = 0;
initvalue(151,1) = 0;
initvalue(152,1) = 0;
initvalue(153,1) = 0;
initvalue(154,1) = 0;
initvalue(155,1) = 0;
initvalue(156,1) = 0;
initvalue(157,1) = 0;
initvalue(158,1) = 0;
initvalue(159,1) = 0;
initvalue(160,1) = 0;
initvalue(161,1) = 0;
initvalue(162,1) = 0;
initvalue(163,1) = 0;
initvalue(164,1) = 0;
initvalue(165,1) = 0;
initvalue(166,1) = 0;
initvalue(167,1) = 0;
initvalue(168,1) = 0;
initvalue(169,1) = 0;
initvalue(170,1) = 0;
initvalue(171,1) = 0;
initvalue(172,1) = 0;
initvalue(173,1) = 0;
initvalue(174,1) = 0;
initvalue(175,1) = 0;
initvalue(176,1) = 0;
initvalue(177,1) = 0;
initvalue(178,1) = 0;
initvalue(179,1) = 0;
initvalue(180,1) = 0;
initvalue(181,1) = 0;
initvalue(182,1) = 2.1869e-10;
initvalue(183,1) = 1.2635e-11;
initvalue(184,1) = 6.6071e-11;
initvalue(185,1) = 2.3362e-13;
initvalue(186,1) = 1.869e-14;
initvalue(187,1) = 2.4763e-12;
initvalue(188,1) = 0;
initvalue(189,1) = 0;
initvalue(190,1) = 0;
initvalue(191,1) = 0;
initvalue(192,1) = 0;
initvalue(193,1) = 0;
initvalue(194,1) = 0;
initvalue(195,1) = 0;
initvalue(196,1) = 0;
initvalue(197,1) = 0;
initvalue(198,1) = 0;
initvalue(199,1) = 1.0804e-12;
initvalue(200,1) = 5.4018e-13;
initvalue(201,1) = 3.8794e-11;
initvalue(202,1) = 0;
initvalue(203,1) = 3.8794e-11;
initvalue(204,1) = 0;
initvalue(205,1) = 0;
initvalue(206,1) = 0;
initvalue(207,1) = 0;
initvalue(208,1) = 0;
initvalue(209,1) = 0;
initvalue(210,1) = 0;
initvalue(211,1) = 0;
initvalue(212,1) = 0;
initvalue(213,1) = 0;
initvalue(214,1) = 0;
initvalue(215,1) = 0;
initvalue(216,1) = 0;
initvalue(217,1) = 0;
initvalue(218,1) = 0;
initvalue(219,1) = 0;
initvalue(220,1) = 0;
initvalue(221,1) = 0;
initvalue(222,1) = 0;
initvalue(223,1) = 0;
initvalue(224,1) = 0;
initvalue(225,1) = 0;
initvalue(226,1) = 0;
initvalue(227,1) = 0;
initvalue(228,1) = 0;
initvalue(229,1) = 0;
initvalue(230,1) = 0;
initvalue(231,1) = 0;
initvalue(232,1) = 0;
initvalue(233,1) = 0;
initvalue(234,1) = 0;
initvalue(235,1) = 0;
initvalue(236,1) = 0;
initvalue(237,1) = 0;
initvalue(238,1) = 0;
initvalue(239,1) = 0;
initvalue(240,1) = 0;
initvalue(241,1) = 0;
initvalue(242,1) = 0;
initvalue(243,1) = 0;
initvalue(244,1) = 0;
initvalue(245,1) = 0;
initvalue(246,1) = 0;
initvalue(247,1) = 0;
initvalue(248,1) = 0;
initvalue(249,1) = 0;
initvalue(250,1) = 0;
initvalue(251,1) = 0;
initvalue(252,1) = 0;
initvalue(253,1) = 0;
initvalue(254,1) = 0;
initvalue(255,1) = 0;
initvalue(256,1) = 0;
initvalue(257,1) = 0;
initvalue(258,1) = 0;
initvalue(259,1) = 0.0001;


%% specify tumor growth parameters (use parameter values from fitting)

% Roland
k0 = 0.000014863138;
k1 = 0.0000021023161;
Ang0 = 9.9967419E-15;

tumorGrowthParams = [k0 k1 Ang0];

startTime = 2690703; % time when tumor reaches 0.1 cm3, given these growth parameters

%% control

start = startTime; 
tspan = [0 start+(6*7*24*3600)];
options = odeset('RelTol',1e-6,'AbsTol',1e-26); 
dose = 0;
[timeCtrl, concCtrl] = ode15s(@Model_equations,tspan,initvalue,options,tumorGrowthParams,dose);
finalVol_Ctrl = concCtrl(end,end);

% plot results
figure(1);
plot(timeCtrl/(3600*24*7),concCtrl(:,end),'-k','LineWidth',2)
xlabel('Time (weeks)')
ylabel('Tumor volume (cm^3)')

%% treatment

% simulate with NO drug until the tumor reaches 0.1 cm3
dose = 0; % in units of mg/kg
tspan = [0 start];
options = odeset('RelTol',1e-6,'AbsTol',1e-26); 
[timeTx, concTx] = ode15s(@Model_equations,tspan,initvalue,options,tumorGrowthParams,dose);
allTime{1,1} = timeTx;
allConc{1,1} = concTx;

doseInt = 302400; % 3.5 days (in units of seconds)
numInj = 12; % number of drug injections
injTime = 60; % length of the injection time

% simulate drug injections
for i = 1:numInj
    dose = 2; % turn on drug for the length of the injection time
    start = startTime+doseInt*(i-1);
    stop  = startTime+doseInt*(i-1) + injTime;
    tspan = [start stop];
    options = odeset('RelTol',1e-6,'AbsTol',1e-26); 
    [timeDrug, concDrug] = ode15s(@Model_equations,tspan,allConc{i,1}(end,:),options,tumorGrowthParams,dose);
    
    dose = 0; % turn off drug until the next injection
    start = startTime+doseInt*(i-1) + injTime;
    stop  = startTime+doseInt*i;
    tspan = [start stop];
    options = odeset('RelTol',1e-6,'AbsTol',1e-26); 
    [timeTx, concTx] = ode15s(@Model_equations,tspan,concDrug(end,:),options,tumorGrowthParams,dose);
    allConc{i+1,1} = [concDrug; concTx];
    allTime{i+1,1} = [timeDrug; timeTx];
    
end
finalVol_Tx = concTx(end,end);

% plot results
figure(2)
plot(timeCtrl/(3600*24*7),concCtrl(:,end),'-k','LineWidth',2)
hold on;

for i = 1:size(allConc,1)
    t = allTime{i,1};
    y = allConc{i,1};
    plot(t/(3600*24*7),y(:,end),'-b','LineWidth',2)
    hold on;
end
xlabel('Time (weeks)')
ylabel('Tumor volume (cm^3)')

% calculate the relative tumor volume
RTV = finalVol_Tx/finalVol_Ctrl;



