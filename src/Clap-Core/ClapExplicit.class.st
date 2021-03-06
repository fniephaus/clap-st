"
I am an abstract class that represents the successful match of a parameter with part of the input.

I link back to my specification and store the word of input that starts the match.
"
Class {
	#name : #ClapExplicit,
	#superclass : #ClapSubExpression,
	#instVars : [
		'word'
	],
	#category : #'Clap-Core-Activation'
}

{ #category : #testing }
ClapExplicit class >> isAbstract [
	^ self == ClapExplicit
]

{ #category : #matching }
ClapExplicit >> completeMatchOn: aStream [
	specification
		with: self
		matchWordOn: aStream
]

{ #category : #evaluating }
ClapExplicit >> evaluateMeaning: arg [
	^ specification meaning cull: self cull: arg
]

{ #category : #testing }
ClapExplicit >> isExplicit [
	^ true
]

{ #category : #printing }
ClapExplicit >> printDetailsOn: aStream [
	| needsSeparator |
	needsSeparator := false.
	self wordsDo: [ :each |
		needsSeparator ifTrue: [ aStream space ].
		aStream nextPutAll: each.
		needsSeparator := true ]

]

{ #category : #printing }
ClapExplicit >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #adding }
ClapExplicit >> recordIn: parentMatch [
	self parent: parentMatch.
	self parent recordParameterMatch: self
]

{ #category : #accessing }
ClapExplicit >> word [
	^ word
]

{ #category : #initialization }
ClapExplicit >> word: aString [
	word := aString
]

{ #category : #enumerating }
ClapExplicit >> wordsDo: aBlock [
	aBlock value: self word
]
