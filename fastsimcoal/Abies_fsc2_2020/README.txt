
Demographic scenarios were hierarchically compared at 1) species level, 2) within-A. religiosa level and 3) considering different migration patterns, respectively. Each scenario was simulated in a directory, as indicate the following tables:

Species level (see also Table S6):
Demographic model	Samples	Missing data	Directory
Ha	Complete	50	Ha*
Hb	Complete	50	Hb
Hc	Complete	50	Hc
Ha	Aj+Af+C	50	Ha1*
Hb	Aj+Af+C	50	Hb1
Hc	Aj+Af+C	50	Hc1
Ha	Aj+Af+E	50	Ha2*
Hb	Aj+Af+E	50	Hb2
Hc	Aj+Af+E	50	Hc2
Ha	Complete	13	Ha87*
Hb	Complete	13	Hb87
Hc	Complete	13	Hc87

Within-A. religiosa level (see also Table S7):
Demographic model	Process	Directory
Hc10	Serial colonization	Hc10
Hc11	2 pop sources	Hc11
Hc12	2 pop sources	Hc12
Hc9	Stepwise col.	Hc9

Migration patterns (see also Table 1):
Demographic model	Process	Migration	Directory
Hc12	2 pop sources	RIM	Hc12_justRel
Hc9	Serial colonization	A-RIM	Hc9_recIntra_ancInter
Hc9	Serial colonization	RIM	Hc9_justRel
Hc12	2 pop sources	A-RIM	Hc12_both
Hc12	2 pop sources	No	Hc12
Hc9	Serial colonization	No	Hc9
Hc9	Serial colonization	Ancient	Hc9_ancmig
Hc12	2 pop sources	Recent	Hc12_recmig
Hc9	Serial colonization	Recent	Hc9_recmig
Hc12	2 pop sources	Ancient	Hc12_IM*

* -> These directories contain all multi-SFSs created with ../easySFS/easySFS/1_easySFS_Abies.sh
Hc12_IM directory has scripts that were used to run coalescent simulations and to choose the best run. These scripts were used to asses all other demographic scenarios.  



