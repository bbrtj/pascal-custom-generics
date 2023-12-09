unit GContainers;

{$mode objfpc}{$H+}{$J-}

interface

type
	generic TCustomList<T> = class
	private
		type
			TRangeArray = array of T;

			TCustomListEnumerator = class
			private
				FList: TCustomList;
				FCurrent: Integer;

			public
				constructor Create(List: TCustomList);

				function GetCurrent(): T; inline;
				function MoveNext(): Boolean; inline;
				procedure Reset();

				property Current: T read GetCurrent;
			end;

	private
		FLength: Integer;

		function GetItem(Index: Integer): T; inline;
		procedure SetItem(Index: Integer; Value: T); inline;
		procedure Expand(); inline;

	protected
		FCount: Integer;
		FItems: TRangeArray;

	public
		constructor Create();
		destructor Destroy; override;

		procedure Add(Item: T); inline;
		procedure AddList(Other: TCustomList); inline;
		procedure Insert(Item: T; Index: Integer); inline;

		procedure Delete(Index: Integer); virtual;
		function Extract(Index: Integer): T; virtual;
		procedure Exchange(Index1, Index2: Integer);

		procedure Assign(Other: TCustomList); inline;
		procedure Clear(); virtual;

		function GetEnumerator(): TCustomListEnumerator;

		property Count: Integer read FCount;
		property Items[Index: Integer]: T read GetItem write SetItem; default;
	end;

	generic TCustomObjectList<T: TObject> = class(specialize TCustomList<T>)
	private
		FFreeObjects: Boolean;

	public
		constructor Create(aFreeObjects: Boolean = True);

		procedure Delete(Index: Integer); override;
		function Extract(Index: Integer): T; override;

		procedure Clear(); override;

		property FreeObjects: Boolean read FFreeObjects write FFreeObjects;
	end;


implementation

{ TCustomList }

constructor TCustomList.Create();
begin
	FLength := 2;
	self.Expand;
	FCount := 0;
end;

destructor TCustomList.Destroy;
begin
	self.Clear;
	inherited;
end;

function TCustomList.GetItem(Index: Integer): T;
begin
	if Index < 0 then
		Index := FCount + Index;

	result := FItems[Index];
end;

procedure TCustomList.SetItem(Index: Integer; Value: T);
begin
	if Index < 0 then
		Index := FCount + Index;

	FItems[Index] := Value;
end;

procedure TCustomList.Expand(); inline;
begin
	FLength := FLength * 2;
	SetLength(FItems, FLength);
end;

procedure TCustomList.Add(Item: T);
begin
	self.Insert(Item, FCount);
end;

procedure TCustomList.AddList(Other: TCustomList);
var
	i: Integer;
begin
	for i := 0 to Other.Count - 1 do
		self.Add(Other[i]);
end;

procedure TCustomList.Insert(Item: T; Index: Integer);
var
	i: Integer;
begin
	for i := FCount downto Index + 1 do
		FItems[i] := FItems[i - 1];

	FItems[Index] := Item;

	Inc(FCount);
	if FCount = FLength then
		self.Expand;
end;

procedure TCustomList.Delete(Index: Integer);
var
	i: Integer;
begin
	for i := Index to FCount - 2 do
		FItems[i] := FItems[i + 1];

	Dec(FCount);
end;

function TCustomList.Extract(Index: Integer): T;
begin
	result := FItems[Index];
	self.Delete(Index);
end;

procedure TCustomList.Exchange(Index1, Index2: Integer);
begin
	FItems[FCount] := FItems[Index1];
	FItems[Index1] := FItems[Index2];
	FItems[Index2] := FItems[FCount];
end;

procedure TCustomList.Assign(Other: TCustomList);
begin
	self.Clear;
	self.AddList(Other);
end;

procedure TCustomList.Clear();
begin
	FCount := 0;
end;

function TCustomList.GetEnumerator(): TCustomListEnumerator;
begin
	result := TCustomListEnumerator.Create(self);
end;

{ TCustomObjectList }

constructor TCustomObjectList.Create(aFreeObjects: Boolean = True);
begin
	inherited Create;
	FFreeObjects := aFreeObjects;
end;

procedure TCustomObjectList.Delete(Index: Integer);
var
	i: Integer;
begin
	if FFreeObjects then
		FItems[Index].Free;

	inherited Delete(Index);
end;

function TCustomObjectList.Extract(Index: Integer): T;
begin
	result := FItems[Index];
	inherited Delete(Index);
end;

procedure TCustomObjectList.Clear();
var
	i: Integer;
begin
	if FFreeObjects then begin
		for i := 0 to FCount - 1 do
			FItems[i].Free;
	end;

	FCount := 0;
end;

{ TCustomList.TCustomListEnumerator }
constructor TCustomList.TCustomListEnumerator.Create(List: TCustomList);
begin
	FList := List;
	self.Reset;
end;

function TCustomList.TCustomListEnumerator.GetCurrent(): T;
begin
	result := FList[FCurrent];
end;

function TCustomList.TCustomListEnumerator.MoveNext(): Boolean;
begin
	Inc(FCurrent);
	result := FCurrent < FList.Count;
end;

procedure TCustomList.TCustomListEnumerator.Reset();
begin
	FCurrent := -1;
end;

end.

