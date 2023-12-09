program Tests;

uses TAPSuite,
	ListTests, ObjectListTests;

begin
	Suite(TListSuite);
	Suite(TObjectListSuite);

	RunAllSuites;
end.

