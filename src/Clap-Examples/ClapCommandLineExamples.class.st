"
Examples and demos of Clap commands (see class side, protocol commandline). Each of those methods builds and returns a command specification, which you can then run or just match against an actual invocation (an array of strings, as would be passed by a shell).

Arbitrary command instances can be run as do-its, e.g.:
	ClapCommandLineExamples hello runWith: #('hello' 'Pharo').
	ClapCommandLineExamples git runWith: #('git' 'help' 'remote').
	
To inspect the matches without activating the commands, replace #runWith: with #match:
	ClapCommandLineExamples hello match: #('hello' 'Pharo').
	ClapCommandLineExamples git match: #('git' 'help' 'remote').

Commands registered in the system (returned from a class-side method with the <commandline> pragma) can also be invoked from the host system's command line:
	$PHARO_VM $IMAGE clap hello Pharo

"
Class {
	#name : #ClapCommandLineExamples,
	#superclass : #Object,
	#instVars : [
		'arguments'
	],
	#category : #'Clap-Examples'
}

{ #category : #'command line' }
ClapCommandLineExamples class >> git [
	"A dummy command (no behavior besides help) to demonstrate nested subcommand and as a test subject for the documenter.
	<commandline> pragma omitted, because doesn't really make sense to make it available outside the image."
	^ (ClapCommand withName: 'git')
		description: 'The stupid content tracker';
		add: ClapCommand forHelp;
		add: ((ClapCommand withName: 'add')
			description: 'Add file contents to the index');
		add: ((ClapCommand withName: 'branch')
			description: 'List, create, or delete branches');
		add: ((ClapCommand withName: 'clone')
			description: 'Clone a repository into a new directory');
		add: ((ClapCommand withName: 'commit')
			description: 'Record changes to the repository');
		add: ((ClapCommand withName: 'init')
			description: 'Create an empty Git repository or reinitialize an existing one');
		add: ((ClapCommand withName: 'remote')
			description: 'Manage set of tracked repositories';
			add: (ClapCommand withName: 'add');
			add: (ClapCommand withName: 'remove');
			add: (ClapCommand withName: 'set-url');
			yourself);
		add: ((ClapCommand withName: 'status')
			description: 'Show the working tree status');
		yourself
]

{ #category : #'command line' }
ClapCommandLineExamples class >> hello [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."
	<commandline>
	
	^ (ClapCommand withName: 'hello')
		description: 'Provides greetings';
		add: ClapFlag forHelp;
		add: ((ClapFlag withName: 'shout')
			description: 'Greet loudly');
		add: ((ClapPositional withName: 'who')
			description: 'Recipient of the greetings';
			defaultMeaning: [ 'world' ]);
		meaning: [ :args |
			args atName: 'help' ifFound: [ :help |
				help value; exitSuccess ].
			
			(self with: args) sayHello ]
]

{ #category : #'instance creation' }
ClapCommandLineExamples class >> with: arguments [
	^ self new
		setArguments: arguments;
		yourself
]

{ #category : #running }
ClapCommandLineExamples >> sayHello [
	self
		sayHelloOn: (VTermOutputDriver on: arguments context stdout)
		recipient: (arguments atName: 'who') value
		shouting: (arguments atName: 'shout') value
]

{ #category : #running }
ClapCommandLineExamples >> sayHelloOn: aStream recipient: who shouting: shouting [
	| message |
	message := 'hello, ' , who.
	
	aStream
		<< (shouting
			ifTrue: [ message asUppercase , '!' ]
			ifFalse: [ message , '.' ]);
		lf
]

{ #category : #initialization }
ClapCommandLineExamples >> setArguments: args [
	arguments := args
]
