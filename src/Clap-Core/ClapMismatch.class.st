"
I represent a class which represents a failed match.
"
Class {
	#name : #ClapMismatch,
	#superclass : #ClapExplicit,
	#category : #'Clap-Core-Activation'
}

{ #category : #accessing }
ClapMismatch >> at: aSpec [
	^ ClapImplicit of: aSpec in: self
]

{ #category : #matching }
ClapMismatch >> completeMatchOn: aStream [
	self word: aStream peek
]

{ #category : #testing }
ClapMismatch >> ifMatch: matchingBlock ifMismatch: mismatchBlock [
	^ mismatchBlock cull: self
]

{ #category : #testing }
ClapMismatch >> isValid [
	^ false
]

{ #category : #printing }
ClapMismatch >> printDetailsOn: aStream [
	aStream
		nextPutAll: word;
		nextPutAll: ' ≠ ';
		print: specification
]

{ #category : #adding }
ClapMismatch >> recordIn: parentMatch [ 
	"this match failed, so do nothing"
]
