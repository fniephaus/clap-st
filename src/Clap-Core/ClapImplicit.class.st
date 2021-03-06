Class {
	#name : #ClapImplicit,
	#superclass : #ClapSubExpression,
	#category : #'Clap-Core-Activation'
}

{ #category : #'instance creation' }
ClapImplicit class >> of: aParameter in: parentMatch [
	^ (self specification: aParameter)
		parent: parentMatch;
		yourself
]

{ #category : #testing }
ClapImplicit >> isExplicit [
	^ false
]

{ #category : #testing }
ClapImplicit >> isValid [
	self flag: 'could be false if resulted from wrong access...'.
	^ true
]
