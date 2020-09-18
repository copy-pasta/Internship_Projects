//SET UP - Midi connection to Disklavier
MIDIClient.init;
m = MIDIOut.newByName("YAMAHA USB Device", "Port1");

(
v = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,

)
)

m.control(0, 64, 90);
m.control(0, 64, 0);

q = ();
d = ();

///////////////////////////////////////////////////////////////////////////////
//Definition of semi-random patterns
///////////////////////////////////////////////////////////////////////////////
//0. Silence:

(

q[\silence_long] = Pbindf(v,
	\midinote, 0,
	\dur, Pwhite(1, 4, 1),
	\tempo, 1;);



q[\silence_short] = Pbindf(v,
	\midinote, 0,
	\dur, Pwhite(0.4, 1, 1),
	\tempo, 1;)
)


//1. Pattern Dry: Rain Dance//////////////////////////////////////////////////////

(
q[\rain_chant] = Pbindf(v,
	\midinote, Pclump(2, Pshuf([41, 43, 42], inf)),
	\dur, 1/2,
	\amp, Pseq([0.3, 0.3, 0.3], 1),
	\tempo, 0.5,
);


q[\rain_drum] = Pbindf(v,
	\midinote, 29,
	\dur, Pseq([1], 1),
	\tempo, Pwhite(0.2, 0.3),
	\amp, Pwhite(0.6, 0.7),
	\sustain, 10,

);

q[\rain_drum_laut] = Pbindf(v,
	\midinote, 29,
	\dur, Pseq([1], 1),
	\tempo, 0.8,
	\amp, 0.8,
	\sustain, 10,
);

q[\rain_chant_2] = Pbindf(v,
	\midinote, Pclump(2, Pshuf([41, 43, 42], inf)),
	\dur, 1/2,
	\amp, Pseq([0.5, 0.0, 0.0, 0.0], 1),
	\tempo, 0.5,
	\sustain, 1,
);

~rain_laut = Pseq([q[\rain_drum_laut]]);

~rain_dance_2 = Pseq([Ptpar([0.0, q[\rain_drum], 0.5, q[\rain_chant]])], 4);

~rain_dance_1 = Pseq([Ptpar([0.0, q[\rain_drum], 6])], 2);

~rain_dance = Pseq([~rain_dance_1, ~rain_dance_2], 1);

)

//2. Pattern rain_breaks_in_dry//////////////////////////////////////////////////////
(
q[\Arp_1] = Pbindf(v,
	\midinote, Pclump(1, Pseq([87, 86, 83, 89, 81], inf) - 45),
	\dur, Pseq([Pshuf([1/8], 20)]),
		\amp, Pseq([Pseq([0.4, 0.5], 20)]),
	\tempo, Pseg(Pseq([Pwhite(0.7, 1, 16)]),1),
	\sustain, 0.1,
);


~rain_arp = q[\Arp_1];


q[\Arp_2] = Pbindf(v,
	\midinote, Pclump(1, Pseq([87, 86, 83, 89, 81], inf) - 45 + 12),
	\dur, Pseq([Pshuf([1/4], 5)]),
		\amp, Pseq([Pseq([0.2, 0.3], 20)]),
	\tempo, Pseg(Pseq([Pwhite(0.4, 2)]),5),
);


q[\Arp_3] = Pbindf(v,
	\midinote, Pclump(1, Pseq([87, 86, 83, 89, 81], inf) - 45 + 18),
	\dur, Pseq([Pshuf([1/4], 5)]),
		\amp, Pseq([Pseq([0.5, 0.6], 20)]),
	\tempo, Pseg(Pseq([Pwhite(0.7, 2)]),5),
);


q[\zufallsprozess_17_laut] = Pbindf(v,
	\midinote, Pclump(1, Pseq([87, 86, 83, 89, 81], inf) - 45),
	\dur, Pseq([Pshuf([1/8], 16)]),
	\amp, 0.5,
	\tempo, Pseg(Pseq([Pwhite(0.2, 1, 16)]),1),
);

q[\zufallsprozess_17_leise] = Pbindf(v,
	\midinote, Pclump(1, Pseq([87, 86, 83, 89, 81], inf) - 45),
	\dur, Pseq([Pshuf([1/8], 16)]),
	\amp, 0.2,
	\tempo, Pseg(Pseq([Pwhite(0.2, 1, 16)]),1),
);


~rain_arp_high = q[\Arp_2];
~rain_arp_high_2 = q[\Arp_3];
~rain_arp_high_2;
~rain_arp_high;
~kurz_tief_2_laut = Pfindur(0.5, q[\zufallsprozess_17_laut]);
~kurz_tief_2_leise = Pfindur(0.5, q[\zufallsprozess_17_leise]);


~arps1 = Pseq([~kurz_tief_2_leise, q[\silence_long], q[\silence_long], ~rain_arp_high, q[\silence_long],q[\silence_long], q[\silence_short], ~kurz_tief_2_leise, q[\silence_long], ~kurz_tief_2_laut, q[\silence_long] , ~rain_arp_high_2, q[\silence_short], ~rain_arp_high, ~kurz_tief_2_laut, Pfindur(2, ~rain_laut), q[\silence_short], q[\silence_long], q[\silence_short], q[\silence_long]]);


)
///////////////////////////////////////////////////////////////////////////////
//3. nisel:

(
q[\nisel_1] = Pbindf(v,
	\midinote, Pclump(Prand([2, 8], inf),Pseq([87, 99, 108], inf)),
	\dur, Pwhite(0.15, 0.25, 4),
	\amp, 0.4,
	\tempo, 0.2,
);


q[\nisel_2] = Pbindf(v,
	\midinote, Pclump(4,Pseq([89, 81], inf)),
	\dur, 0.6,
	\amp, 0.35,
	\tempo,0.8,
);


q[\nisel_3] = Pbindf(v,
	\midinote, Pclump(Prand([2, 8], inf),Pseq([87, 99, 108], inf)) - 3,
	\dur, Pwhite(0.15, 0.25, inf),
	\amp, 0.3,
	\tempo, 0.2,
);


q[\nisel_1_l] = Pbindf(v,
	\midinote, Pclump(Prand([2, 8], inf),Pseq([87, 99, 108], inf)),
	\dur, Pwhite(0.15, 0.25, 6),
	\amp, 0.4,
	\tempo, Pseg([0.2, 0.1], 1),
);


q[\nisel_2_l] = Pbindf(v,
	\midinote, Pclump(4,Pseq([89, 81], inf)),
	\dur, 0.6,
	\amp, 0.25,
	\tempo, Pseg([0.8, 0.1], 1),
);


q[\nisel_3_l] = Pbindf(v,
	\midinote, Pclump(Prand([2, 8], inf),Pseq([87, 99, 108], inf)) - 3,
	\dur, Pwhite(0.15, 0.25, inf),
	\amp, 0.1,
	\tempo, Pseg([0.2, 0.01], 1),
);

q[\nisel_4] = Pbindf(v,
	\midinote, Pclump(4,Pwhite(98, 108, inf)),
	\dur, 0.3,
	\amp, 0.2,
	\tempo,0.6,
);

d[\screw] = 0;

q[\Notes_with_screws] = Pbindf(v,
	\midinote, Pshuf([72, 75, 76, 78], 1),
	\dur, 0.6,
	\amp, Pwhite(0.4, 0.6),
	\tempo, 0.6,
	\screw, Pfunc({|x| d[\screw] = x[\midinote]}),
);

(

~nisel =  (
Pfindur(4,
Ppar([
Ptpar([0.0, q[\nisel_1], 1, q[\nisel_2]]),
Ptpar([0.1, q[\nisel_3], 1.1, q[\nisel_4]]),
q[\Notes_with_screws]


]
	)
)));


~nisel_rit = Pfindur(10, Ptpar([0, q[\nisel_1_l], 0.15, q[\nisel_2_l], 0.2, q[\nisel_3_l]]));

)

/////////////////////////////////////////////////////////////////////////////////
//4. Hund

(
q[\hund] = Pbindf(v,
	\midinote, Pseq([Pclump(3, Pseq([90, 92, 94])), Pclump(3,Pseq([91, 93, 95]))], 5),
	\dur, Pseq([0.07, 0.05, 0.06, Pwhite(0.04, 0.06)], inf),
	\amp, Pseq([0.2, 0.25, 0.3, 0.35, 0.4, 0.5, 0.6,  0.7, 0.8, 0.9], inf) ,
\tempo, 1,
);

~hund = q[\hund];
)


/////////////////////////////////////////////////////////////////////
//5. intensifying rain - Relativ random

(
q[\more_rain_fast] = Pbindf(v,
	\midinote, Pclump(8, Pseq([87, 86, 83, 89, 81], inf) + Pseq([Pwhite(12, 24, 3), Pwhite(-6, 0, 3)], inf)),
	\dur, Pseq([Pshuf([1/16], 12)]),
	\amp, 0.56,
	\tempo, Pseg([Pseq([Pwhite(0.8, 1, 16)])],1),
);

q[\more_rain_slow] = Pbindf(v,
	\midinote, Pclump(2, Pseq([87, 86, 83, 89, 81], inf) + Pseq([Pwhite(12, 24, 3), Pwhite(-6, 0, 3)], inf)) - 20,
	\dur, Pseq([Pshuf([1/32], 100), 1]),
	\amp, Pseq([Pseq([0.4], 100), 0.8], 1),
	\tempo, Pseg([Pseq([0.8, 1.2])], inf),
	\sustain, 0.1,
);


q[\more_rain_slow_2] = Pbindf(v,
	\midinote, Pclump(2, Pseq([87, 86, 83, 89, 81], inf) + Pseq([Pwhite(12, 24, 3), Pwhite(-6, 0, 3)], inf)) - 3,
	\dur, Pseq([Pshuf([1/32], 100), 1]),
	\amp, Pseq([Pseq([0.4], 100), 0.8], 1),
	\tempo, Pseg([Pseq([0.8, 1.2])], inf),
	\sustain, 0.1,
);


~more_rain_fast = q[\more_rain_fast];


~more_rain_slow = q[\more_rain_slow];
~more_rain_slow_2 = q[\more_rain_slow_2];

)

////////////////////////////////////////////////////////////////////
//6. Cloud Formationen

(
q[\zufallsprozess_12] = Pbindf(v,
	\midinote, Pclump(Pseq([2, 3, 4, 5, 6, 7, 8, 3, 8, 7, 6, 5, 4, 3], 2), Pseq([70, 63, 83, 89, 81, 50], inf) + Pseq([Pwhite(-12, 12 , inf), Pwhite(-9, 0, 3)], inf)),
	\dur, Pseq([Pseq([0.1, 0.1], 1), Prand([0.1, 1]), Prand([0.2, 0.6]), Prand([1, 3]), Prand([0.1, 2])], inf),
	\amp, 0.6,
	\tempo, Pseg([1, 0.1], 15),
);

q[\cloudformation_21] = Pbindf(v,
	\midinote, Pclump(3, Pseq([64, 65, 66, 63, 67], inf)),
	\dur, Prand([1, 2, 3, 4], inf),
	\amp, Pwhite( 0.1, 0.6),
	\tempo, Pseg([0.7, 1, 0.6], inf),
	\sustain, 1,

);


q[\cloudformation_22] = Pbindf(v,
	\midinote,Pclump(Prand([2, 4], inf), Pseq([52, 53, 54, 55, 58, 59, 61, 63, 74, 76], inf)),
	\dur, Prand([0.1, 2], inf),
	\amp, Pwhite( 0.1, 0.5),
	\tempo, Pseg([0.2, 1, 0.6], 12),
	\sustain, 1,

);


q[\cloudformation_22_other] = Pbindf(v,
	\midinote,Pclump(Prand([2, 4], inf), Pseq([52, 53, 54, 55, 58, 59, 61, 63, 74, 76], inf)) + Pseq([12, 14, 18]),
	\dur, Prand([0.1, 0.3], inf),
	\amp, Pwhite( 0.1, 0.6),
	\tempo, Pseg([0.6, 1.6, 0.6], 12),
	\sustain, 1,

);


q[\cloudformation_23] = Pbindf(v,
	\midinote,Pclump(5, Pseq([71, 72, 74, 78, 79, 80, 81], inf)),
	\dur, Prand([1, 2, 3, 4], inf),
	\amp, Pwhite( 0.1, 0.5),
	\tempo, Pseg([0.3, 1, 0.6], 12),
	\sustain, 1,

);


q[\cloudformation_23_high] = Pbindf(v,
	\midinote,Pclump(5, Pshuf([71, 72, 74, 78, 79, 80, 81], inf)) + Pseq([Prand([12, -12], inf), Prand([14, -14], inf),Prand([24, -24],inf) ], inf),
	\dur, Prand([1, 2, 3, 4], inf),
	\amp, Pwhite( 0.1, 0.5, inf),
	\tempo, Pseg([0.3, 1, 1], 12),
	\sustain, 1,

);


q[\cloudformation_24] = Pbindf(v,
	\midinote,Pshuf([71, 72, 74, 78, 79, 80, 81], inf) + Pseq([1, 2, 3], inf),
	\dur, Prand([0.1], 32),
	\amp, Pwhite( 0.2, 0.6),
	\tempo, Pseg(Pseq([0.4, 6]), 24),
	\sustain, 0.1,
	\dummy, Pfunc({|x| d[\cloud_midi] = x[\midinote]}),
	\dummyamp, Pfunc({|x| d[\cloud_amp] = x[\amp]}),
	\dummytemp, Pfunc({|x| d[\cloud_temp] = x[\tempo]}),
);


q[\cloudformation_interval_5] = Pbindf(v,
  \midinote, Pfunc({d[\cloud_midi]}) -  5,
	\dur, Prand([0.1], 32),
	\amp, 0.2,
	\tempo,Pfunc({d[\cloud_temp]}),
	\sustain, 0.1,

);

q[\cloudformation_interval_6] = Pbindf(v,
  \midinote, Pfunc({d[\cloud_midi]}) -  6,
	\dur, Prand([0.1], 32),
	\amp, 0.4,
	\tempo,Pfunc({d[\cloud_temp]}),
	\sustain, 0.1,

);


q[\cloudformation_interval_7] = Pbindf(v,
  \midinote, Pfunc({d[\cloud_midi]}) -  6,
	\dur, Prand([0.1], 32),
	\amp, 0.5,
	\tempo,Pfunc({d[\cloud_temp]}),
	\sustain, 0.1,

);


q[\cloudformation_interval_8] = Pbindf(v,
  \midinote, Pfunc({d[\cloud_midi]}) -  7,
	\dur, Prand([0.1], 32),
	\amp, 0.6,
	\tempo,Pfunc({d[\cloud_temp]}),
	\sustain, 0.1,

);

q[\cloudformation_interval_9] = Pbindf(v,
  \midinote, Pfunc({d[\cloud_midi]}) -  8,
	\dur, Prand([0.1], 32),
	\amp, 0.7,
	\tempo,Pfunc({d[\cloud_temp]}),
	\sustain, 1,

);

q[\cloudformation_interval_chord] = Pbindf(v,
  \midinote, 91 - 12 - 12 - 12  ,
	\dur, 1,
	\amp, 0.8,
	\tempo, 1,
	\sustain, 1,

);

q[\cloudformation_26] = Pbindf(v,
  \midinote, Pfunc({d[\cloud_midi]}) -  24,
	\dur, Prand([0.1], 32),
	\amp, 0.2,
	\tempo,Pfunc({d[\cloud_temp]}),
	\sustain, 0.1,

);


~interval_5 = Pfindur(0.5, Ppar([ ~cloud_4, q[\cloudformation_24], q[\cloudformation_interval_5]]));
~interval_6 = Pfindur(0.1, Ppar([ ~cloud_4, q[\cloudformation_24], q[\cloudformation_interval_6]]));
~interval_7 = Pfindur(0.5, Ppar([ ~cloud_4, q[\cloudformation_24], q[\cloudformation_interval_7]]));
~interval_8 = Pfindur(0.5, Ppar([ ~cloud_4, q[\cloudformation_24], q[\cloudformation_interval_8]]));
~interval_9 = Pfindur(4, Ppar([ ~cloud_4, q[\cloudformation_24], q[\cloudformation_interval_9] , q[\cloudformation_26]]));

~interval_chord = Pfindur(0.1, Ppar([ ~cloud_4, q[\cloudformation_24], q[\cloudformation_interval_chord] , q[\cloudformation_26]]));

~cloud_accellerando = Pseq([~interval_5, ~interval_6, ~interval_7, ~interval_8, ~interval_9, Pfindur(1, ~interval_chord)]);

~cloud_1 = Pfindur(6, q[\cloudformation_22]);
~cloud_2 = Pfindur(2, q[\cloudformation_23]);
~cloud_3 = Pfindur(4, q[\cloudformation_21]);
~cloud_4 = Pfindur(4, q[\cloudformation_24]);
~cloud_1_other = Pfindur(16, q[\cloudformation_22_other]);
~cloud_2_high = Pfindur(6, q[\cloudformation_23]);
~cloudseq1 = Ptpar([0, ~cloud_1, 2,~cloud_2, 2.3, ~cloud_3]);
~cloudseq2 = Ptpar([0, ~cloud_1, 0,~cloud_2_high, 0, ~cloud_3]);
)

////////////////////////////////////////////////////////////////////
//7. Kurze Motive

(

q[\zufallsprozess_16] = Pbindf(v,
	\midinote, Pclump(1, Pseq([87, 86, 83, 89, 81], inf) - 41),
	\dur, Pseq([Pshuf([1/16], 16)]),
	\amp, 0.6,
	\tempo, Pseg(Pseq([Pwhite(0.4, 1, 16)]),1),
);



q[\zufallsprozess_18] = Pbindf(v,
	\midinote, Pclump(1, Pseq([87, 86, 83, 89, 81], inf) - 45),
	\dur, Pseq([Pshuf([1/16], 16)]),
	\amp, 0.7,
	\tempo, Pseg(Pseq([Pwhite(0.4, 1, 16)]),1),
);



q[\zufallsprozess_10] = Pbindf(v,
	\midinote, Pclump(8, Pseq([87, 86, 83, 89, 81], inf) + Pseq([Pwhite(12, 24, inf)], inf)),
	\dur, Pseq([0.1], 3),
	\amp, 0.4,
	\tempo, Pseg(Pseq([Pwhite(0.1, 1, 16)]),1),
);

q[\zufallsprozess_10_b] = Pbindf(v,
	\midinote, Pclump(2, Pseq([72, 75, 76, 78], inf) + Pseq([Pwhite(12, 24, inf)], inf)),
	\dur, Pseq([0.1], 3),
	\amp, 0.4,
	\tempo, Pseg(Pseq([Pwhite(0.1, 1, 16)]),1),
);

q[\zufallsprozess_10_c] = Pbindf(v,
	\midinote, Pclump(1, Pseq([72, 75, 76, 78], inf) + Pseq([Pwhite(0, 0, inf)], inf)),
	\dur, Pseq([0.3], 3),
	\amp, 0.4,
	\tempo, Pseg(Pseq([Pwhite(1, 2, 16)]),1),
);

q[\zufallsprozess_10_d] = Pbindf(v,
	\midinote, Pclump(1, Pxrand([72, 75, 76, 78], inf) + Pseq([Pwhite(-12, 2, inf)], inf)),
	\dur, Pseq([0.5], 3),
	\amp, 0.4,
	\tempo, Pseg(Pseq([Pwhite(0.1, 1, 16)]),1),
);


//kurze Motive:
~kurz_tief_1 = Pfindur(0.2, q[\zufallsprozess_16]);
~kurz_tief_3 = Pfindur(0.1, q[\zufallsprozess_18]);
~kurz_tief_4 = Pfindur(0.1, q[\zufallsprozess_19]);
~kurz_tief_5 = Pfindur(0.1, q[\zufallsprozess_20]);
~kurz_hoch_6 = Pfindur(0.1, q[\zufallsprozess_10]);
~kurz_hoch_7 = Pfindur(0.3, q[\zufallsprozess_10_b]);
~kurz_hoch_8 = Pfindur(0.6, q[\zufallsprozess_10]);
~kurz_hoch_9 = Pfindur(0.1, q[\zufallsprozess_10_c]);
~kurz_hoch_10 = Pfindur(3, q[\zufallsprozess_10_d]);
~kurz_nisel = Pfindur(0.15, ~nisel);

Ppar([~kurz_nisel, ~kurz_hoch_9]);
Pseq([~kurz_nisel, ~kurz_hoch_9]);
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Kombinationen:
(

q[\zufallsprozess_12_fast] = Pbindf(v,
	\midinote, Pclump(Pseq([1, 2, 3], inf), Pseq([70, 63, 83, 89, 81, 50], inf) + Pseq([Pwhite(12, 24 , inf), Pwhite(9, 0, 3)], inf)) * - 2 ,
	\dur, Pseq([Pseq([0.1, 0.1], 1), Prand([0.1, 0.4]), Prand([0.2, 0.3]), Prand([0.1, 0.3]), Prand([0.1, 2])], inf),
	\amp, Pwhite(0.3, 0.6),
	\tempo, Pfunc({d[\zufall11_fast]}),
);

q[\zufallsprozess_12_slow] = Pbindf(v,
	\midinote, Pclump(Pseq([3, 1, 2], inf), Pseq([70, 63, 83, 89, 81, 50], inf) + Pseq([Pwhite(12, 24 , inf), Pwhite(9, 0, 3)], inf)) * - 2 ,
	\dur,Pseq([Pseq([0.4, 0.4], 1), Prand([0.1, 0.4]), Prand([0.2, 0.3]), Prand([0.1, 0.3]), Prand([0.1, 2])], inf),
	\amp, Pwhite(0.2, 0.3),
	\tempo, Pfunc({d[\zufall11_slow]}),
);

q[\zufallsprozess_11_fast] = Pbindf(v,
	\midinote, Pclump(Pseq([4, 5], inf), Pseq([87, 86, 83, 89, 81], inf) + Pseq([Pwhite(-12, 0 , inf), Pwhite(-6, 0, 3)], inf)),
	\dur, Pseq([2], inf),
	\amp, 0.4,
	\tempo, Pseg(Pseq([Pwhite(0.4, 0.6, 16)]),1),
	\cool2020, Pfunc({|x| d[\zufall11_fast] = x[\tempo]})
);


q[\zufallsprozess_11_slow] = Pbindf(v,
	\midinote, Pclump(Pseq([4, 5], inf), Pseq([87, 86, 83, 89, 81], inf) + Pseq([Pwhite(-12, 0 , inf), Pwhite(-6, 0, 3)], inf)),
	\dur, Pseq([2], inf),
	\amp, 0.2,
	\tempo, Pseg(Pseq([Pwhite(0.1, 0.2, 16)]),1),
	\cool2020, Pfunc({|x| d[\zufall11_slow] = x[\tempo]})
);


~link_1 = Pfindur(8, Ppar([q[\zufallsprozess_12_fast], q[\zufallsprozess_11_fast]]));

~link_2 = Pfindur(8, Ppar([q[\zufallsprozess_12_slow], q[\zufallsprozess_11_slow]]));


~link_slow = Pfindur(4, ~link_2);


)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//SEQUENCING _ überblick an abbspielbarem material

Grundmotive                     Größere Kombinationen

~rain_dance.play                     ~link_1.play
~rain_dance_2.play                   ~little_drops
~rain_dance_1.play
~rain_arp.play
~nisel.play
~hund
~cloud_1.play
~cloud_2.play
~cloud_3.pla
~cloud_4.play
~cloud_1_other.play
~cloud_2_high.play
~cloudseq1.play
~cloudseq2.play



~kurz_tief_1.play
~kurz_tief_2.play
~kurz_tief_3.play
~kurz_tief_4.play
~kurz_hoch_6.play
~kurz_hoch_7.play
~kurz_hoch_8.play
~kurz_hoch_9.play
~kurz_nisel.

 Sequencen / Finite State Machines aus den kleineren Teilen
~intro_1,
~intro_2,
~cloud_scpaces
~cloud_accellerando



///////////////////////////////////////////////////////////////////////////////
//1. Beginning Sequence


~calling_the_rain = Pseq([~rain_dance, Ptpar([0, ~rain_arp], 1)]);

Pfindur(0.5, ~calling_the_rain);

Pfindur(1, ~rain_arp);

Pfindur(4, ~nisel);



///////////////////////////////////////////////////////////////////////////
//finite state Machine (Only with 1 pattern at a time) -->all patterns


~one = Ppar([~kurz_hoch_6, ~kurz_hoch_7]);
~two = Ppar([~kurz_hoch_9, ~kurz_nisel]);


(
~littledrops = Pfsm([
	[0],
	~kurz_tief_2, [1, 3],
	~kurz_tief_1, [3, 5],
	~rain_dance_1, [0, 3],
	~one, [0, 2, 3, 4],
	~two, [4, 5],
	nil, nil
]
));



~littledrops.play

//space for improvisation--->1 softer moments

(
~cloud_spaces = Pfsm([
	[0],
	q[\silence_long], [1],
	~cloud_1, [1, 3],
	~cloud_2, [ 2, 3],
	~cloud_3, [3, 4, 5],
	~cloud_other, [3, 4, 5],
	nil, nil
])
)



////////////////////////////////////////////// Player

~deep = Pseq([~kurz_tief_1, q[\silence_short], ~kurz_tief_2, ~kurz_tief_2, ~kurz_tief_1, q[\silence_short], ~kurz_tief_2, q[\silence_long ]]);

~next_2 = Pseq([~link_slow, Pfindur(1, ~cloud_spaces), Pfindur(2, ~link_1), Pfindur(2, ~cloud_spaces)], 2);

~next_3 = Pseq([~kurz_hoch_7, Pseq([Pfindur(0.4, ~hund),~kurz_hoch_6, Pfindur(0.5, ~nisel), ~kurz_hoch_8], 1), Pfindur(~nisel)],3); //likt this

~intro2 = Pseq([Pfindur(1, ~littledrops), Pseq([q[\silence_short], Pfindur(0.1, ~nisel), Pfindur(1, ~rain_arp_high) , Pfindur(0.1, ~nisel), Pfindur(1, ~rain_arp_high_2)], 2),
	q[\silence_short], Pfindur(0.5, ~more_rain_fast), ~nisel, ~nisel]);

//working on the intro:

(
~more_rain = Ppar([~more_rain_slow_2 , ~more_rain_slow]);
~intro1 = Pseq([~rain_dance]);

~intro2 = Pseq([Pseq([q[\silence_long], Pfindur(0.1, ~nisel), Pfindur(1, ~rain_arp_high) , Pfindur(0.1, ~nisel), Pfindur(1, ~rain_arp_high_2)], 2)]);


~next = Pseq([~cloud_accellerando, ~hund, q[\silence_long]]);
~next_3 = Pseq([~kurz_hoch_7, Pseq([Pfindur(0.4, ~hund),~kurz_hoch_6, Pfindur(0.5, ~nisel), ~kurz_hoch_8], 1), Pfindur(~nisel)],3); //likt this

~all = Pseq([~nisel, ~nisel_rit, q[\silence_long], Pfindur(3, ~link_slow), q[\silence_long], Pfindur(6, ~link_slow), ~cloud_spaces, ~next, ~next_3, ~nisel]);

~arps1;

~raining_men = Pseq([q[\silence_short], Pfindur(0.5, ~more_rain_fast), ~nisel, ~nisel]);

Pseq([~intro1, ~arps1, ~more_rain, ~intro2, ~raining_men, ~all, ~ending]).play;

)

(
~splats = Pbindf(v,
	\midinote, (Pseq([60, 59, 63, 62, 63, 62, 63, 62], 2)) ,
	\dur, Pseq([0.01, 0.4, 0.01, 0.25,0.01, 0.25, 0.01, 0.25]),
	\amp, 0.4,
	\tempo, 1,
).play;)


(
~splats = Pbindf(v,
	\midinote, (Pseq([60, 59, 63, 62, 63, 62, 63, 62], 2)) - 24,
	\dur, Pseq([0.01, 0.4, 0.01, 0.25,0.01, 0.25, 0.01, 0.25]),
	\amp, 0.4,
	\tempo, 1,
).play;)

(
~splats = Pbindf(v,
	\midinote, 5 + (Pseq([60, 59, 63, 62, 63, 62, 63, 62], 2)) ,
	\dur, Pseq([0.01, 0.4, 0.01, 0.25,0.01, 0.25, 0.01, 0.25]),
	\amp, 0.5,
	\tempo, 0.2,
).play;)

(
~splats = Pbindf(v,
	\midinote, - 12 + (Pseq([60, 59, 63, 62, 63, 62, 63, 62], 2)) ,
	\dur, Pseq([0.01, 0.4, 0.01, 0.25,0.01, 0.25, 0.01, 0.25]),
	\amp, 0.2,
	\tempo, 0.2,
).play;)


(
~splats = Pbindf(v,
	\midinote, 35 + (Pseq([60, 59, 63, 62, 63, 62, 63, 62], 2)) ,
	\dur, Pseq([0.01, 0.4, 0.01, 0.25,0.01, 0.25, 0.01, 0.25]),
	\amp, 0.6,
	\tempo, 1.2,
).play;)
