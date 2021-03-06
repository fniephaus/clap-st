"
I represent a command or subcommand.

Commands are recognized by a keyword, possibly with aliases for convenience. Besides positionals, commands can have flags, as well as nested (sub)commands.

Subcommands work like a trie, to organize and select the various behaviors of a complex program. At each level in a given invocation, at most one subcommand will be recognized, most often as the last parameter of its parent command.


To create a new instance of this class, you must write this:
	ClapCommand withName: <CommandName>
	
And after, if you want to add a flag:
	addFlag: ClapFlag withName: <FlagName>
	
If you want to add a positional:
	addPositional: ClapPositional withName: <PositionalName>
	
If you want to add a subcommand:
	addSubCommand: <subCommand>
	
Example for the eval command: 
	(ClapCommand withName: 'eval')
		addFlag: ClapFlag withName: 'help';
		addPositional: ClapPositionnal withName: 'smalltalk 		expression'.
"
Class {
	#name : #ClapCommand,
	#superclass : #ClapParameterized,
	#instVars : [
		'flags',
		'subcommands'
	],
	#category : #'Clap-Core-Specifications'
}

{ #category : #'predefined commands' }
ClapCommand class >> forHelp [
	^ (self withName: 'help')
		description: 'Prints command documentation';

		addPositional: ((ClapPositional withName: 'topic')
			description: 'The subcommand to document (defaults to the current one)';
			meaning: [ :pos :cmd | cmd atName: pos word ];
			defaultMeaning: [ :pos :cmd | cmd ]);

		meaning: [ :match | | doc parent query topic |
			doc := ClapDocumenter on: (ZnCharacterWriteStream on: match context stdout).
			parent := match parent specification.
			query := match atName: 'topic'.
			topic := query value: parent.
			topic
				ifNotNil: [ doc explain: topic ]
				ifNil: [ doc noSuchSubcommand: query word of: parent ] ]

]

{ #category : #adding }
ClapCommand >> addFlag: aFlag [
	flags add: aFlag
]

{ #category : #adding }
ClapCommand >> addSubcommand: aCommand [
	subcommands add: aCommand
]

{ #category : #adding }
ClapCommand >> addTo: parentParameter [
	^ parentParameter addSubcommand: self
]

{ #category : #accessing }
ClapCommand >> atName: specName [
	^ self subcommandNamed: specName ifNone:
		[ self flagNamed: specName ifNone:
			[ super atName: specName ] ]
]

{ #category : #'matching - testing' }
ClapCommand >> canMatchWith: word [
	^ word = self canonicalName
	
]

{ #category : #accessing }
ClapCommand >> flagNamed: specName ifNone: aBlock [
	^ flags
		detect: [ :flag | flag canonicalName = specName ]
		ifNone: aBlock
]

{ #category : #accessing }
ClapCommand >> flags [
	^ flags
]

{ #category : #initialization }
ClapCommand >> initialize [
	super initialize.
	subcommands := OrderedCollection new.
	flags := OrderedCollection new.
]

{ #category : #accessing }
ClapCommand >> matchClass [
	^ ClapCommandMatch
]

{ #category : #enumerating }
ClapCommand >> parametersDo: aBlock [
	super parametersDo: aBlock.
	self flags do: aBlock.
	self subcommands do: aBlock
]

{ #category : #running }
ClapCommand >> runWith: arguments [
	"Convenience method for running a command in an interactive context"
	^ (ClapContext specification: self)
		activateWith: arguments
]

{ #category : #accessing }
ClapCommand >> subcommandNamed: specName ifNone: aBlock [
	^ subcommands
		detect: [ :cmd | cmd canonicalName = specName ]
		ifNone: aBlock
]

{ #category : #accessing }
ClapCommand >> subcommands [
	^ subcommands
]

{ #category : #documenting }
ClapCommand >> synopsisOn: aStream [
	aStream nextPutAll: self canonicalName
]
