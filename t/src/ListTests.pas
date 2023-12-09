unit ListTests;

{$mode objfpc}{$H+}{$J-}

interface

uses TAPSuite, TAP, TAPCore, GContainers;

type
	TListSuite = class(TTAPSuite)
		constructor Create(); override;

		procedure AddDeleteTest();
		procedure AddListTest();
		procedure ExpandTest();
	end;

implementation

type
	TTestRecord = record
		X: Integer;
	end;

	TTestList = specialize TCustomList<TTestRecord>;

constructor TListSuite.Create();
begin
	inherited;
	Scenario(@self.AddDeleteTest, 'Test list creation, Add() and Delete()');
	Scenario(@self.AddListTest, 'Test AddList() and Assign()');
	Scenario(@self.ExpandTest, 'Test whether the list can expand and enumerate');
end;

procedure TListSuite.AddDeleteTest();
var
	lList: TTestList;
	lValue: TTestRecord;
begin
	lList := TTestList.Create;
	Fatal; TestIs(lList.Count, 0, 'uninitialized Count is zero');

	lValue.X := 42;
	lList.Add(lValue);
	TestIs(lList.Count, 1, 'count is one after adding');
	TestIs(lList[0].X, 42, 'first value ok');

	lValue.X := 21;
	lList.Add(lValue);
	TestIs(lList.Count, 2, 'count is two after adding again');
	TestIs(lList[1].X, 21, 'second value ok');

	lValue.X := 37;
	lList.Insert(lValue, 1);
	TestIs(lList.Count, 3, 'count is three after inserting');
	TestIs(lList[1].X, 37, 'second value ok');
	TestIs(lList[2].X, 21, 'third value ok');

	lList.Exchange(2, 1);
	TestIs(lList[2].X, 37, 'last value ok after exchanging');

	lValue := lList.Extract(1);
	TestIs(lList.Count, 2, 'count is two after extracting');
	TestIs(lValue.X, 21, 'extracted value ok');
	TestIs(lList[1].X, 37, 'third value moved down, now is the second one');

	lList.Delete(0);
	TestIs(lList.Count, 1, 'count is one after deleting');
	TestIs(lList[0].X, 37, 'second value moved down, now is the first one');

	lList.Clear;
	TestIs(lList.Count, 0, 'list is empty after clearing');

	lList.Free;
end;

procedure TListSuite.AddListTest();
var
	lList, lOtherList: TTestList;
	lValue: TTestRecord;
	i: Integer;
begin
	lList := TTestList.Create;
	lOtherList := TTestList.Create;

	for i := 0 to 2 do begin
		lValue.X := i;
		lList.Add(lValue);

		lValue.X := i + 10;
		lOtherList.Add(lValue);
	end;

	lList.AddList(lOtherList);
	TestIs(lList.Count, 6, 'count is six after merging lists');
	TestIs(lList[4].X, 11, 'value from second list ok');

	lList.Assign(lOtherList);
	TestIs(lList.Count, 3, 'count is three after assigning lists');
	TestIs(lList[1].X, 11, 'value from second list ok');

	lList.Free;
	lOtherList.Free;
end;

procedure TListSuite.ExpandTest();
const
	cUpTo = 10000;
var
	lList: TTestList;
	lValue: TTestRecord;
	i: Integer;
begin
	lList := TTestList.Create;

	for i := 1 to cUpTo do begin
		lValue.X := i;
		lList.Add(lValue);
	end;

	TestIs(lList.Count, cUpTo, 'count ok');

	i := 0;
	for lValue in lList do begin
		TestIs(lValue.X, i + 1, 'value ok');
		Inc(i);
	end;

	TestIs(i, cUpTo, 'loop finished ok');

	lList.Free;
end;

end.

