uses
  'confirm.cfm';

begin
  ShowTitle('Відрахування у зв''язку з закінченням терміну навчання.');

    ShowInfo('Статус = ''Випускник''');
    ShowInfo(#13#10);

  AddReason(1501);

  PartConfirm('Date=?FromDate'#13#10 +
              'Status=''В''')

{  if Params.Item('FromDate_Enabled').Value then
    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''В''')
  else
    PartConfirm('Date=?OrderDate'#13#10 +
                'Status=''В''');
}
end.
