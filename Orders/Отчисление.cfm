uses
  'confirm.cfm';

begin
  ShowTitle('Відрахування ' + Params.Item('Reason_REASON').Value);

  ShowInfo('Статус = ''Відрахований''');
  ShowInfo(#13#10);

  AddReason(Params.Item('Reason_REASONID').Value);

  if Params.Item('OutDate_Enabled').Value then
    PartConfirm('Date=?OutDate'#13#10 +
                'Status=''О''')
  else
    PartConfirm('Date=?OrderDate'#13#10 +
                'Status=''О''');
end.
