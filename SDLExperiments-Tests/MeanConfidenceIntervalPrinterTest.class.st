"
A DataSeriesStatisticsPrinterTest is a test class for testing the behavior of DataSeriesStatisticsPrinter
"
Class {
	#name : 'MeanConfidenceIntervalPrinterTest',
	#superclass : 'TestCase',
	#category : 'SDLExperiments-Tests',
	#package : 'SDLExperiments-Tests'
}

{ #category : 'tests' }
MeanConfidenceIntervalPrinterTest >> testPrintMultipleExamples [

	| printer |
	printer := MeanConfidenceIntervalPrinter new.
	
	self assert: (printer print: (Array new: 1 withAll: 5)) equals: '5.00 ±0.00'.
	self assert: (printer print: (Array new: 10 withAll: 5)) equals: '5.00 ±0.00'.
	self assert: (printer print: (Array new: 30 withAll: 5)) equals: '5.00 ±0.00'.
	self assert: (printer print: (Array new: 100 withAll: 5)) equals: '5.00 ±0.00'.

	"size >= 30 => Gaussian distribution"
	self assert: (printer print: (1 to: 30)) equals: '15.5 ±2.6'.
	
	"size < 30 => Student T distribution"
	self assert: (printer print: (1 to: 10)) equals: '5.5 ±1.7'.
	printer fixedDecimalPlaces: 3.
	self assert: (printer print: (1 to: 10)) equals:  '5.500 ±1.735'.

]

{ #category : 'tests' }
MeanConfidenceIntervalPrinterTest >> testPrintWithUnit [

	| printer |
	printer := MeanConfidenceIntervalPrinter new.

	printer
		unitString: 'ms';
		fixedDecimalPlaces: 1.
	
	self assert: (printer print: (1 to: 30)) equals: '15.5ms ±2.6'.

]
