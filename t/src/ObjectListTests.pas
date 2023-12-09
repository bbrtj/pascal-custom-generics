unit ObjectListTests;

{$mode objfpc}{$H+}{$J-}

interface

uses TAPSuite, TAP, TAPCore, GContainers;

type
	TObjectListSuite = class(TTAPSuite)
		constructor Create(); override;

		procedure AffiliationTest();
	end;

implementation

var
	GlobalFreed: Integer;

type
	TTestClass = class
		destructor Destroy; override;
	end;

	TTestList = specialize TCustomObjectList<TTestClass>;

destructor TTestClass.Destroy;
begin
	GlobalFreed += 1;
	inherited;
end;

constructor TObjectListSuite.Create();
begin
	inherited;
	Scenario(@self.AffiliationTest, 'Test whether list owns its objects');
end;

procedure TObjectListSuite.AffiliationTest();
var
	lList: TTestList;
begin
	GlobalFreed := 0;
	lList := TTestList.Create;

	lList.Add(TTestClass.Create);
	lList.Delete(0);
	TestIs(GlobalFreed, 1, 'object appears to be freed when deleting');

	lList.Add(TTestClass.Create);
	lList.Extract(0);
	TestIs(GlobalFreed, 1, 'object appears to be extracted');

	lList.Add(TTestClass.Create);
	lList.Clear;
	TestIs(GlobalFreed, 2, 'object appears to be freed when clearing');

	lList.Add(TTestClass.Create);
	lList.FreeObjects := False;
	lList.Delete(0);
	TestIs(GlobalFreed, 2, 'object appears not to be freed when FreeObjects is False');

	lList.FreeObjects := True;
	lList.Add(TTestClass.Create);
	lList.Add(TTestClass.Create);
	lList.Free;
	TestIs(GlobalFreed, 4, 'object appears to be freed when freeing');
end;

end.

