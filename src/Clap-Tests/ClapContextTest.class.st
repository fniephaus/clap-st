Class {
	#name : #ClapContextTest,
	#superclass : #TestCase,
	#instVars : [
		'subject',
		'argv',
		'okMatch'
	],
	#category : 'Clap-Tests-Unit'
}

{ #category : #running }
ClapContextTest >> setUp [
	argv := Mock named: 'argv'.
	okMatch := Mock named: 'match'.
	okMatch stub isMismatch willReturn: false.
	okMatch stub ifMismatch: Any.
	
	subject := ClapContext on: argv
]

{ #category : #tests }
ClapContextTest >> testEmptyContext [
	subject matchDeferred should be isMismatch.
	argv should not receive next
]

{ #category : #tests }
ClapContextTest >> testPositionalContext [
	| arg parent |
	arg := ClapPositional withName: 'foo'.
	(arg stub matchOn: argv) willReturn: okMatch.
	parent := Mock named: 'parent'.
	
	subject defer: arg for: parent.
	subject matchDeferred.

	arg should receive matchOn: argv.
	okMatch should receive addTo: parent
]