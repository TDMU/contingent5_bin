uses
  'confirm.cfm';
	
begin
  ShowTitle('Змінення прізвища');

  ShowInfo(Params.Item('FIO').Value + ' => ' + Params.Item('NewFIO').Value);
  ShowInfo(#13#10);

  AddReason(11001);

  ExecSQL('insert into HS_FIO(STUDENTID, BEGINDATE, FIO, ORDERID) ' +
          'select STUDENTID, @@BeginDate%#@, ?NewFIO, @@ORDERID@ '+
          'from PARTITIONSTOSTUDENTS '+
          'where PARTITIONID = ?PARTITIONID');
	Params.Item('new_status').Value := '';
	if Params.Item('Reason_REASONID').Value = 11019 then Params.Item('new_status').Value := 'Р';
	if Params.Item('Reason_REASONID').Value = 11020 then Params.Item('new_status').Value := 'О';
	if Params.Item('new_status').Value <> '' then
  ExecSQL('insert into HS_FAMILYSTATUS(STUDENTID, BEGINDATE, FAMILYSTATUS, ORDERID) ' +
          'select STUDENTID, @@BeginDate%#@, ?new_status, @@ORDERID@ ' +
          ' from PARTITIONSTOSTUDENTS '+
          'where PARTITIONID = ?PARTITIONID');	
end.
