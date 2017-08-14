SynthDef(\formlet, {
	arg t_tr = 1, pitch = 60, amp=0.2, gate=1, dur=0.1, atk = 0.01;
	var sig, freq, env;
	env = EnvGen.ar(Env.linen(0.1, 0, dur+atk),gate,doneAction:2);
	freq = pitch.midicps;
	sig = Formlet.ar(K2A.ar(t_tr), freq, atk, dur);
	Out.ar(0, sig*amp);
}).add;

OSCdef(\formlet, { |msg|
	var pitch = msg[1].asFloat;
	Synth(\formlet,[\pitch, pitch]);
}, "/formlet");

OSCdef(\formlet, { |msg|
	var pitch = msg[1].asFloat;
	var atk = msg[2].asFloat;
	var dur = msg[3].asFloat;
	Synth(\formlet,[\pitch, pitch, \atk, atk, \dur, dur]);
}, "/formlet");

n = NetAddr("127.0.0.1", 57120);

n.sendMsg("/formlet", 80);

n.sendMsg("/formlet", 60, 1.8, 0.01);




SynthDef(\ssyn, {
	arg pitch=60, amp=0.5, ffreq=500, gate=0;
	var freq, sig, env;
	freq = pitch.midicps;
	env = EnvGen.ar(Env.asr(releaseTime:0.5),gate);
	sig = Saw.ar(freq);
	sig = RLPF.ar(sig, ffreq);
	Out.ar(0, sig*env);
}).add;

~ssyn = Synth(\ssyn);
OSCdef(\ssynon,{|msg|
	var on = msg[1].asInteger;
	~ssyn.set(\gate, on);
}, "/ssynon");
OSCdef(\ssynpitch,{|msg|
	var pitch = msg[1].asInteger;
	~ssyn.set(\pitch, pitch);
}, "/ssynpitch");
OSCdef(\ssynffreq,{|msg|
	var ffreq = msg[1].asInteger;
	~ssyn.set(\ffreq, ffreq);
}, "/ssynffreq");

n.sendMsg("/ssynon", 1);
n.sendMsg("/ssynon", 0);
n.sendMsg("/ssynpitch", 63);
n.sendMsg("/ssynffreq", 4000);

