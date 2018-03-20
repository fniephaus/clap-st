Class {
	#name : #ClapCommandLineExamples,
	#superclass : #Object,
	#category : #'Clap-Examples'
}

{ #category : #commandline }
ClapCommandLineExamples class >> hello [
	<commandline>
	^ (ClapCommand withName: 'hello')
		description: 'Provides greetings.';
		addFlag: ((ClapFlag withName: 'shout')
			description: 'Greet loudly');
		addPositional: ((ClapPositional withName: 'who')
			description: 'Recipient of the greetings';
			defaultMeaning: [ 'world' ]);
		meaning: [ :args |
			self new
				doHelloRecipient: (args atName: 'who') value
				shouting: (args atName: 'shout') value ]
]

{ #category : #running }
ClapCommandLineExamples >> doHelloRecipient: who shouting: shouting [
	| message |
	message := 'hello, ' , who.
	
	VTermOutputDriver stdout
		<< (shouting
			ifTrue: [ message asUppercase , '!' ]
			ifFalse: [ message , '.' ]);
		lf
]