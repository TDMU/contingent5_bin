uses
  'confirm.cfm';

begin
  ShowTitle('³���������� � ��''���� � ���������� ������ ��������.');

    ShowInfo('������ = ''���������''');
    ShowInfo(#13#10);

  AddReason(1501);

  PartConfirm('Date=?FromDate'#13#10 +
              'Status=''�''')

{  if Params.Item('FromDate_Enabled').Value then
    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''�''')
  else
    PartConfirm('Date=?OrderDate'#13#10 +
                'Status=''�''');
}
end.
