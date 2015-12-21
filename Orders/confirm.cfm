procedure AddReason(ReasonID: integer);
begin
  Utils.ExecSQL('insert into STUDENTTOORDER (STUDENTID, ORDERID, REASONID) ' +
                'select STUDENTID, @@ORDERID@ , ' + IntToStr(ReasonID) + ' ' +
                'from PARTITIONSTOSTUDENTS ' +
                'where PARTITIONID = ?PARTITIONID');
end;

procedure ExecSQL(SQL: string);
begin
  Utils.ExecSQL(SQL);
end;

procedure ShowTitle(Title: string);
begin
  Utils.MsgOut(#13#10'    ' + Title + #13#10, 10, 0);
  Utils.MsgOut('----------------------------------------------------------------'#13#10, 10, 0);
end;

procedure ShowInfo(Str: string);
begin
  Utils.MsgOut('      ' + Str + #13#10, 8, 0);
end;

procedure ShowNotChangeInfo;
begin
 ShowInfo('Розділ дані не змінює'#13#10);
end;

procedure PartConfirm(Params: string);
var
  d: TStringList;
  i, fi: integer;
  s: string;
  Names: array[0..11] of string =
     ['Date', 'SpecialityID', 'DepartmentID', 'EduBasis', 'EduForm',
      'EduTerm', 'Semester', 'EduYear', 'Status', 'GroupNum', 'CountryID', 'ToDate'];
begin

  d := TStringList.Create;
  try
    d.Text := Params;

    s := '';
    for i := 0 to 11 do
    begin
      fi := d.IndexOfName(Names[i]);
      if fi <> -1 then
        s := s + ', ' + d.Values(Names[i])
      else
        s := s + ', null';
    end;
  finally
    d.Free;
  end;

  Utils.ExecSQL('execute procedure SP_PARTITION_CONFIRM ' +
                '(?ORDERID, ?PARTITIONID' + s + ')');

                
end;


begin
end.
