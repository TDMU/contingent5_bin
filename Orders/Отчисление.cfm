uses
  'confirm.cfm';

begin
  ShowTitle('³���������� ' + Params.Item('Reason_REASON').Value);

  ShowInfo('������ = ''³����������''');
  ShowInfo(#13#10);

  AddReason(Params.Item('Reason_REASONID').Value);

  if Params.Item('OutDate_Enabled').Value then
    PartConfirm('Date=?OutDate'#13#10 +
                'Status=''�''')
  else
    PartConfirm('Date=?OrderDate'#13#10 +
                'Status=''�''');
end.
