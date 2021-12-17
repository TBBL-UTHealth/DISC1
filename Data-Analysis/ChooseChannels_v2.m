%v2 of choose channels now has the number of channels as a switch so it
%automatically selects the channel number. Dates changes from ifs to switch
temp=[7	23	39	55	71	87	103	119;...
    8	24	40	56	72	88	104	120;...
    6	22	38	54	70	86	102	118;...
    9	25	41	57	73	89	105	121;...
    5	21	37	53	69	85	101	117;...
    10	26	42	58	74	90	106	122;...
    4	20	36	52	68	84	100	116;...
    11	27	43	59	75	91	107	123;...
    3	19	35	51	67	83	99	115;...
    12	28	44	60	76	92	108	124;...
    2	18	34	50	66	82	98	114;...
    13	29	45	61	77	93	109	125;...
    1	17	33	49	65	81	97	113;...
    14	30	46	62	78	94	110	126;...
    0	16	32	48	64	80	96	112;...
    15	31	47	63	79	95	111	127];

temp2=[7		39		71		103	;...
    8		40		72		104	;...
    6		38		70		102	;...
    9		41		73		105	;...
    5		37		69		101	;...
    10		42		74		106	;...
    4		36		68		100	;...
    11		43		75		107	;...
    3		35		67		99	;...
    12		44		76		108	;...
    2		34		66		98	;...
    13		45		77		109	;...
    1		33		65		97	;...
    14		46		78		110	;...
    0		32		64		96	;...
  15		47		79		111	];
%%% FOR DISC
channels_interest=struct();
switch date
    case '10-31-20'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        switch num_ch_RV
            case 8
                channels_interest.RV=[10 26	42	58	74	90	106	122];% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
            case 4
                 channels_interest.RV=[10 	42		74		106	];% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11
                    6		38		70		102	 ;  9		41		73		105	 ;...
                    5		37		69		101	 ; 10		42		74		106	 ;...
                    4		36		68		100	 ; 11		43		75		107	 ;...
                    3		35		67		99	 ; 12		44		76		108	 ;...
                    2		34		66		98	 ];
            case 24
                channels_interest.model=[ 6	22	38	54	70	86	102	118 ;... % for 10.31.20
                    10	26	42	58	74	90	106	122 ;...
                    12	28	44	60	76	92	108	124];
            case 12
                channels_interest.model=[ 6		38		70		102	 ;... % for 10.31.20
                    10		42		74		106	 ;...
                    12		44		76		108	];
             case 11
                channels_interest.model=[ 71; 72;... % rows 1-11
                    70; 73; 69; 74; 68; 75; 67; 76; 66];
            case 8
                channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=74;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                else
                    channels_interest.model=24;
                    
                end

        end
        
    case '11-01-20'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        switch num_ch_RV
            case 8
                channels_interest.RV=[10 26	42	58	74	90	106	122];% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
            case 4
                 channels_interest.RV=[10 	42		74		106	];% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11
                    6		38		70		102	 ;  9		41		73		105	 ;...
                    5		37		69		101	 ; 10		42		74		106	 ;...
                    4		36		68		100	 ; 11		43		75		107	 ;...
                    3		35		67		99	 ; 12		44		76		108	 ;...
                    2		34		66		98	 ];
            case 24
                channels_interest.model=[ 8	24	40	56	72	88	104	120 ;... % for 11.01.20
                    10	26	42	58	74	90	106	122 ;...
                    12	28	44	60	76	92	108	124];
            case 12
                channels_interest.model=[ 8	40	72	104 ;... % for 11.01.20
                    10		42		74		106	 ;...
                    12		44		76		108	];
            case 11
                channels_interest.model=[ 71; 72;... % rows 1-11
                    70; 73; 69; 74; 68; 75; 67; 76; 66];
            case 8
                channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=74;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                else
                    channels_interest.model=24;
                    
                end

        end        

    case '11-03-20'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        switch num_ch_RV
            case 8
                channels_interest.RV=[3 19	35	51	67	83	99	115]; % row 9  for RV/tuning curves, 11-03-20, 1-15-21, 1-28-21
            case 4
                channels_interest.RV=[3	35	67	99	]; % row 9  for RV/tuning curves, 11-03-20, 1-15-21, 1-28-21
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7	39	71	103 ;  8	40 	72	104 ;... % rows 1-11
                    6	38	70	102 ;  9	41	73	105 ;...
                    5	37	69	101 ; 10	42	74	106 ;...
                    4	36	68	100 ; 11	43	75	107 ;...
                    3	35	67	99 ; 12	44	76	108 ;...
                    2	34	66	98 ];
            case 24
                channels_interest.model=[ 8	24	40	56	72	88	104	120 ;... % for 11.03.20
                    4	20	36	52	68	84	100	116 ;...
                    3	19	35	51	67	83	99	115];
            case 11
                channels_interest.model=[ 71; 72;... % rows 1-11
                    70; 73; 69; 74; 68; 75; 67; 76; 66];
            case 12
                channels_interest.model=[ 8	40	72	104 ;... % for 11.03.20
                    10		42		74		106	 ;...
                    12		44		76		108	];
            case 8
                channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=74;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                else
                    channels_interest.model=24;
                    
                end

        end           
    case '8-31-21'
        channels_interest.DISCMacro=[ 8  24	40  56	72	88	104	120 ; 6	 22	38	54	70	86	102	118 ;... % rows 2-12
            9	 25	41	57	73	89	105	121 ; 5	 21	37	53	69	85	101	117 ;...
            10 26	42	58	74	90	106	122 ; 4	 20	36	52	68	84	100	116 ;...
            11 27	43	59	75	91	107	123 ; 3	 19	35	51	67	83	99	115 ;...
            12 28	44	60	76	92	108	124 ; 2	 18	34	50	66	82	98	114;...
            13 29	45	61	77	93	109	125];
        switch num_ch_RV
            case 8
                channels_interest.RV=[4  20	36	52	68	84	100	116]; % row 7 for
                %     RV/tuning curves, 8-31-21
            case 4
                channels_interest.RV=[4  36 68	100]; % row 7 for RV/tuning curves,8-31-21
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 8  	40  	72		104	 ; 6	 	38		70		102	 ;... % rows 1-12
                    9   41		73		105	 ; 5	 	37		69		101	 ;...
                    10 	42		74		106	 ; 4	 	36		68		100	 ;...
                    11 	43		75		107	 ; 3	 	35		67		99	 ;...
                    12 	44		76		108	 ; 2	 	34		66		98	;...
                    13 	45		77		109	];
            case 24
                channels_interest.model=[ 9	25	41	57	73	89	105	121;... % for 8-31-21
                    4	20	36	52	68	84	100	116 ;...
                    2	18	34	50	66	82	98	114];
            case 12
                channels_interest.model=[ 9		41		73		105	;... % for 8-31-21
                    4		36		68		100	 ;...
                    2		34		66		98	];
             case 11
                channels_interest.model=[72;... % rows 2-12
                    70; 73; 69; 74; 68; 75; 67; 76; 66; 77];
            case 8
                channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                else
                    channels_interest.model=[2 3 5 7];
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=74;% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
                else
                    channels_interest.model=5;
                    
                end

        end
        
    case '9-9-21'
        channels_interest.DISCMacro=[ 8  24	40  56	72	88	104	120 ; 6	 22	38	54	70	86	102	118 ;... % rows 2-12
            9	 25	41	57	73	89	105	121 ; 5	 21	37	53	69	85	101	117 ;...
            10 26	42	58	74	90	106	122 ; 4	 20	36	52	68	84	100	116 ;...
            11 27	43	59	75	91	107	123 ; 3	 19	35	51	67	83	99	115 ;...
            12 28	44	60	76	92	108	124 ; 2	 18	34	50	66	82	98	114;...
            13 29	45	61	77	93	109	125];
        switch num_ch_RV
            case 8
                channels_interest.RV=[11 27	43	59	75	91	107	123]; % row 7 for
            case 4
                channels_interest.RV=[11 	43		75		107	]; % row 7 for RV/tuning curves
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 8 40 72 104; 6	38	70	102;... % rows 2-12
                    9	41		73		105	 ; 5	 	37		69		101	 ;...
                    10 	42		74		106	 ; 4	 	36		68		100	 ;...
                    11 	43		75		107	 ; 3	 	35		67		99	 ;...
                    12 	44		76		108	 ; 2	 	34		66		98	;...
                    13 	45		77		109	];
            case 24
                channels_interest.model=[ 8	24	40	56	72	88	104	120 ;... % for 9.7.21
                    11 27	43	59	75	91	107	123 ;...
                    12 28	44	60	76	92	108	124];
            case 12
                channels_interest.model=[ 8	40	72	104 ;... % for 9.7.21
                    11	43	75	107 ;...
                    12	44	76	108];
             case 11
                channels_interest.model=[ 71; 72;... % rows 1-11
                    70; 73; 69; 74; 68; 75; 67; 76; 66];
            case 8
                channels_interest.model=channels_interest.RV;
            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                else
                    channels_interest.model=[2 3 5 7];
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=74;
                else
                    channels_interest.model=5;
                    
                end

        end
        
    case '1-11-21'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        switch num_ch_RV
            case 8
                channels_interest.RV=[10 26	42	58	74	90	106	122];% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
            case 4
                channels_interest.RV=[10 	42		74		106	];% row 6 for RV/tuning curves, 10-31-20, 11-01-20, 1-11-21
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11
                    6		38		70		102	 ;  9		41		73		105	 ;...
                    5		37		69		101	 ; 10		42		74		106	 ;...
                    4		36		68		100	 ; 11		43		75		107	 ;...
                    3		35		67		99	 ; 12		44		76		108	 ;...
                    2		34		66		98	 ];
            case 24
             channels_interest.model=[ 6	22	38	54	70	86	102	118 ;... % for 1.11.21
                 10	26	42	58	74	90	106	122 ;...
                 3	19	35	51	67	83	99	115];
            case 12
            channels_interest.model=[ 6		38		70		102	 ;... % for 1.11.21
                10		42		74		106	 ;...
                3		35		67		99	];
            case 11
                channels_interest.model=[ 71; 72;... % rows 1-11
                    70; 73; 69; 74; 68; 75; 67; 76; 66];
            case 8
                channels_interest.model=channels_interest.RV;
                channels_interest.model=[4	20	36	52	68	84	100	116];

            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                    channels_interest.model=[4	36	68	100];

                else
                    channels_interest.model=17:20;
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=68;
                else
                    channels_interest.model=20;
                    channels_interest.RV=17:20;
                end

        end
        
    case '1-13-21'
        channels_interest.DISCMacro=[ 8  24	40  56	72	88	104	120 ; 6	 22	38	54	70	86	102	118 ;... % rows 2-12
            9	 25	41	57	73	89	105	121 ; 5	 21	37	53	69	85	101	117 ;...
            10 26	42	58	74	90	106	122 ; 4	 20	36	52	68	84	100	116 ;...
            11 27	43	59	75	91	107	123 ; 3	 19	35	51	67	83	99	115 ;...
            12 28	44	60	76	92	108	124 ; 2	 18	34	50	66	82	98	114;...
            13 29	45	61	77	93	109	125];
        
        switch num_ch_RV
            case 8
                channels_interest.RV=[2	18	34	50	66	82	98	114;]; % row 11 for RV/tuning curves for 1-13-21
            case 4
                channels_interest.RV=[2	34	66	98;]; % row 11 for RV/tuning curves for 1-13-21
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 8  	40  	72		104	 ; 6	38	70	102	 ;... % rows 2-12
                    9	 	41		73		105	 ; 5	 	37		69		101	 ;...
                    10  	42		74		106	 ; 4	 	36		68		100	 ;...
                    11      43		75		107	 ; 3	 	35		67		99	 ;...
                    12 		44		76		108	 ; 2	 	34		66		98	;...
                    13  	45		77		109	];
            case 24
                channels_interest.model=[ 8	24	40	56	72	88	104	120 ;... % for 1.13.21
                    4	20	36	52	68	84	100	116 ;...
                    2	18	34	50	66	82	98	114];
            case 12
                channels_interest.model=[ 8		40		72		104	 ;... % for 1.13.21
                    4		36		68		100	 ;...
                    2		34		66		98	];
            case 11
                 channels_interest.model=[ 40; 38;... % rows 2-12
                    41; 37;	42; 36; 43; 35; 44; 34; 45];
            case 8
                channels_interest.model=channels_interest.RV;
                channels_interest.model=[11 27	43	59	75	91	107	123];

            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                    channels_interest.model=[11	43	75	107];

                else
                    channels_interest.model=0:3;
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=107; %43;
                else
                    channels_interest.model=0;
                    channels_interest.RV=0:3;
                end
                
        end
 
     case '1-15-21'
         channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11
             6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
             5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
             4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
             3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
             2	18	34	50	66	82	98	114 ];
        
         switch num_ch_RV
             case 8
                 channels_interest.RV=[3 19	35	51	67	83	99	115]; % row 9  for RV/tuning curves, 11-03-20, 1-15-21, 1-28-21
             case 4
                 channels_interest.RV=[3 	35		67		99	]; % row 9  for RV/tuning curves, 11-03-20, 1-15-21, 1-28-21
         end
         switch num_ch
             case 128
                 channels_interest.model=temp;
             case 64
                 channels_interest.model=temp2;
             case 88
                 channels_interest.model=channels_interest.DISCMacro;
             case 44
                 channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11
                     6		38		70		102	 ;  9		41		73		105	 ;...
                     5		37		69		101	 ; 10		42		74		106	 ;...
                     4		36		68		100	 ; 11		43		75		107	 ;...
                     3		35		67		99	 ; 12		44		76		108	 ;...
                     2		34		66		98	 ];
             case 24
                 channels_interest.model=[ 7	23	39	55	71	87	103	119 ;... % for 1.15.21
                     4	20	36	52	68	84	100	116 ;...
                     3	19	35	51	67	83	99	115];
             case 12
                 channels_interest.model=[ 7		39		71		103	 ;... % for 1.15.21
                     4		36		68		100	 ;...
                     3		35		67		99	];
             case 11
                 channels_interest.model=[55; 56;...
                     54; 57; 53; 58; 52; 59; 51; 60; 50];

             case 8
                 channels_interest.model=channels_interest.RV;
                 channels_interest.model=[4	20	36	52	68	84	100	116];

             case 4
                 if strcmp(device,'DISC')
                     channels_interest.model=channels_interest.RV;
                     channels_interest.model=[4	36	68	100];

                 else
                     channels_interest.model=17:20;
                     channels_interest.RV=channels_interest.model;
                 end
             case 1
                 if strcmp(device,'DISC')
                     channels_interest.model=68; %52;
                 else
                     channels_interest.model=19;
                     channels_interest.RV=17:20;
                 end
                 
         end
    case '1-27-21'
        channels_interest.DISCMacro=[ 8  24	40  56	72	88	104	120 ; 6	 22	38	54	70	86	102	118 ;... % rows 2-12
            9	 25	41	57	73	89	105	121 ; 5	 21	37	53	69	85	101	117 ;...
            10 26	42	58	74	90	106	122 ; 4	 20	36	52	68	84	100	116 ;...
            11 27	43	59	75	91	107	123 ; 3	 19	35	51	67	83	99	115 ;...
            12 28	44	60	76	92	108	124 ; 2	 18	34	50	66	82	98	114;...
            13 29	45	61	77	93	109	125];
        
        switch num_ch_RV
            case 8
                channels_interest.RV=[4  20	36	52	68	84	100	116;]; % row 7 for RV/tuning curves, 1-27-20
            case 4
                channels_interest.RV=[4  37 68	100	;]; % row 7 for RV/tuning curves, 1-27-20
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 8  	40  	72		104	 ; 6	 	38		70		102	 ;... % rows 1-12
                    9   41		73		105	 ; 5	 	37		69		101	 ;...
                    10 	42		74		106	 ; 4	 	36		68		100	 ;...
                    11 	43		75		107	 ; 3	 	35		67		99	 ;...
                    12 	44		76		108	 ; 2	 	34		66		98	;...
                    13 	45		77		109	];
            case 24
                channels_interest.model=[ 9	25	41	57	73	89	105	121;... % for 1.27.21
                    4	20	36	52	68	84	100	116 ;...
                    2	18	34	50	66	82	98	114];
            case 12
                channels_interest.model=[ 9		41		73		105	;... % for 1.27.21
                    4		36		68		100	 ;...
                    2		34		66		98	];
            case 11
                 channels_interest.model=[ 40; 38;... % rows 2-12
                    41; 37;	42; 36; 43; 35; 44; 34; 45];
            case 8
                channels_interest.model=channels_interest.RV;
                channels_interest.model=[11 27	43	59	75	91	107	123];

            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                    channels_interest.model=[11	43	75	107];

                else
                    channels_interest.model=0:3; % for 1-13-21, 1-27-21 and 1-28-21
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=59; %36;
                else
                    channels_interest.model=0;
                    channels_interest.RV=0:3;
                end
                
        end       
        
    case '1-28-21'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        
        switch num_ch_RV
            case 8
                channels_interest.RV=[3 19	35	51	67	83	99	115]; % row 9  for RV/tuning curves, 11-03-20, 1-15-21, 1-28-21
            case 4
                channels_interest.RV=[3 	35		67		99	]; % row 9  for RV/tuning curves, 11-03-20, 1-15-21, 1-28-21, 4 columns
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11 % 11 x4
                    6		38		70		102	 ;  9		41		73		105	 ;...
                    5		37		69		101	 ; 10		42		74		106	 ;...
                    4		36		68		100	 ; 11		43		75		107	 ;...
                    3		35		67		99	 ; 12		44		76		108	 ;...
                    2		34		66		98	 ];
            case 24
                channels_interest.model=[ 6	22	38	54	70	86	102	118 ;... % for 1.28.21
                    4	20	36	52	68	84	100	116 ;...
                    3	19	35	51	67	83	99	115];
            case 12
                channels_interest.model=[ 6		38		70		102	 ;... % for 1.28.21
                    4		36		68		100	 ;...
                    3		35		67		99	];
            case 11
                channels_interest.model=[7; 8;...
                    6; 9; 5; 10; 4; 11; 3; 12; 2];
            case 8
                channels_interest.model=channels_interest.RV;
                channels_interest.model=[4	20	36	52	68	84	100	116];

            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                     channels_interest.model=[4	36	68	100];

                else
                    channels_interest.model=17:20; % for 1-11-21, 1-15-21 and 1-28-21
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=4;
                else
                    channels_interest.model=19;
                    channels_interest.RV=17:20;
                end
                
        end
    case '8-27-21'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        
        switch num_ch_RV
            case 8
                channels_interest.RV=[10 26 42	58	74	90	106	122];% row 6 for RV/tuning curves
            case 4
                channels_interest.RV=[10 	42		74		106	];% row 6 for RV/tuning curves
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11 % 11 x4
                    6		38		70		102	 ;  9		41		73		105	 ;...
                    5		37		69		101	 ; 10		42		74		106	 ;...
                    4		36		68		100	 ; 11		43		75		107	 ;...
                    3		35		67		99	 ; 12		44		76		108	 ;...
                    2		34		66		98	 ];
            case 24
                channels_interest.model=[  7 23	39	55	71	87	103	119	 ; 10 26	42	58	74	90	106	122 ;...
                    2	18	34	50	66	82	98	114 ];
            case 12
                channels_interest.model=[ 7		39		71		103	 ; 10		42		74		106	 ;...
                    2		34		66		98	 ];
            case 11
                channels_interest.model=[87; 88;...
                    86;89; 85; 90; 84; 91; 83; 92; 82];            
            case 8
                channels_interest.model=channels_interest.RV;
                channels_interest.model=[4	20	36	52	68	84	100	116];
                
            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                    channels_interest.model=[4	36	68	100];

                else
                    channels_interest.model=[2 3 5 7];
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=84; %90;
                else
                    channels_interest.model=7;
                    channels_interest.RV=[2 3 5 7];
                end
                
        end
case '9-7-21'
    channels_interest.DISCMacro=[ 8  24	40  56	72	88	104	120 ; 6	 22	38	54	70	86	102	118 ;... % rows 2-12
        9	 25	41	57	73	89	105	121 ; 5	 21	37	53	69	85	101	117 ;...
        10 26	42	58	74	90	106	122 ; 4	 20	36	52	68	84	100	116 ;...
        11 27	43	59	75	91	107	123 ; 3	 19	35	51	67	83	99	115 ;...
        12 28	44	60	76	92	108	124 ; 2	 18	34	50	66	82	98	114;...
        13 29	45	61	77	93	109	125];
        switch num_ch_RV
            case 8
    channels_interest.RV=[11 27	43	59	75	91	107	123]; % row 8 for RV/tuning curves for 9-7-2021
            case 4
    channels_interest.RV=[11 	43		75		107	]; % row 8 for RV/tuning curves for 9-7-2021
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 8 40 72 104; 6	38	70	102;... % rows 2-12
            9	41		73		105	 ; 5	 	37		69		101	 ;...
            10 	42		74		106	 ; 4	 	36		68		100	 ;...
            11 	43		75		107	 ; 3	 	35		67		99	 ;...
            12 	44		76		108	 ; 2	 	34		66		98	;...
            13 	45		77		109	];
            case 24
                channels_interest.model=[ 8	24	40	56	72	88	104	120 ;... % for 9.7.21
                    11 27	43	59	75	91	107	123 ;...
                    12 28	44	60	76	92	108	124];
            case 12
                channels_interest.model=[ 8	40	72	104 ;... % for 9.7.21
                    11	43	75	107 ;...
                    12	44	76	108];
            case 11
                channels_interest.model=[120; 118;...
                    121; 117; 122; 116; 123; 115; 124; 114; 125];
            case 8
                channels_interest.model=channels_interest.RV;
                channels_interest.model=[11 27	43	59	75	91	107	123];
            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                    channels_interest.model=[11	43	75	107];

                else
                    channels_interest.model=[2 3 5 7];
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=123;
                else
                    channels_interest.model=5;
                    channels_interest.RV=[2 3 5 7];
                end
                
        end
        
 case '9-29-21'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11, 8 col
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        switch num_ch_RV
            case 8
    channels_interest.RV=[5	21	37	53	69	85	101	117]; % row 5
            case 4
        channels_interest.RV=[5		37		69		101	]; % row 5
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11, 4 col
                    6		38		70		102	 ;  9		41		73		105	 ;...
                    5		37		69		101	 ; 10		42		74		106	 ;...
                    4		36		68		100	 ; 11		43		75		107	 ;...
                    3		35		67		99	 ; 12		44		76		108	 ;...
                    2		34		66		98	 ];
                    case 24
                channels_interest.model=[  8	24	40  56	72	88	104	120 ;... % rows 2,5, 9, 8 col
                    5	21	37	53	69	85	101	117 ; ...
                    3	19	35	51	67	83	99	115 ];
            case 12
                channels_interest.model=[  8	40 	72	104 ;... % rows 2,5, 9, 8 col
                    5	37	69	101 ; ...
                    3	35	67	99 ];
            case 11
                channels_interest.model=[87; 88; ...
                    86; 89; 85; 90; 84; 91; 83; 92; 82];
            case 8
                channels_interest.model=channels_interest.RV;                
                channels_interest.model=[4	20	36	52	68	84	100	116];

            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                    channels_interest.model=[4	36	68	100];

                else
                    channels_interest.model=24:27;
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=116; %85;
                else
                    channels_interest.model=26;
                    channels_interest.RV=24:27;
                end
                
        end
 case '10-05-21'
        channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11, 8 col
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        switch num_ch_RV
            case 8
    channels_interest.RV=[5	21	37	53	69	85	101	117]; % row 5
            case 4
        channels_interest.RV=[5		37		69		101	]; % row 5
        end
        switch num_ch
            case 128
                channels_interest.model=temp;
            case 64
                channels_interest.model=temp2;
            case 88
                channels_interest.model=channels_interest.DISCMacro;
            case 44
                channels_interest.model=[ 7		39		71		103	 ;  8		40  	72		104	 ;... % rows 1-11, 4 col
                    6		38		70		102	 ;  9		41		73		105	 ;...
                    5		37		69		101	 ; 10		42		74		106	 ;...
                    4		36		68		100	 ; 11		43		75		107	 ;...
                    3		35		67		99	 ; 12		44		76		108	 ;...
            2		34		66		98	 ];
            case 24
                 channels_interest.model=[  8	24	40  56	72	88	104	120 ;... % rows 2,5, 9, 8 col
                    5	21	37	53	69	85	101	117 ; ...
                    3	19	35	51	67	83	99	115 ];
            case 12
                 channels_interest.model=[  8	40 	72	104 ;... % rows 2,5, 9, 8 col
                    5	37	69	101 ; ...
                    3	35	67	99 ];
            case 11
                channels_interest.model=[ 71; 72;... % rows 1-11
                    70; 73; 69; 74; 68; 75; 67; 76; 66];
            case 8
                channels_interest.model=channels_interest.RV;                
                channels_interest.model=[4	20	36	52	68	84	100	116];

            case 4
                if strcmp(device,'DISC')
                    channels_interest.model=channels_interest.RV;
                    channels_interest.model=[4	36	68	100];

                else
                    channels_interest.model=12:15;
                    channels_interest.RV=channels_interest.model;
                end
            case 1
                if strcmp(device,'DISC')
                    channels_interest.model=36; %73;
                else
                    channels_interest.model=15;
                    channels_interest.RV=12:15;
                end
                
                
                
                
        end         
    case '11-12-20'
        channels_interest.DISCMacro=[ 7	24 ];
        channels_interest.RV=[ 7	24 ];
        channels_interest.model=[ 7	24 ];
    case '03-02-21'
                channels_interest.DISCMacro=[ 7	23	39	55	71	87	103	119 ;  8	24	40  56	72	88	104	120 ;... % rows 1-11, 8 col
            6	22	38	54	70	86	102	118 ;  9	25	41	57	73	89	105	121 ;...
            5	21	37	53	69	85	101	117 ; 10	26	42	58	74	90	106	122 ;...
            4	20	36	52	68	84	100	116 ; 11	27	43	59	75	91	107	123 ;...
            3	19	35	51	67	83	99	115 ; 12	28	44	60	76	92	108	124 ;...
            2	18	34	50	66	82	98	114 ];
        channels_interest.RV=channels_interest.DISCMacro;
        channels_interest.model=channels_interest.DISCMacro;
end

% % %%%% For MACRO
% %channels_interest.Macro=6;