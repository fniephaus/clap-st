tests
testAt
	[ :name1 :arg1 :name2 :arg2 |
		subject at: name1 put: arg1.
		subject at: name2 put: arg2.
		(subject at: name1) should be: arg1.
		(subject at: name2) should be: arg2.
	] runWithMocks
	