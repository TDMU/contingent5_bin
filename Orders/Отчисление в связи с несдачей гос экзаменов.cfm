uses
  'confirm.cfm';

begin
  ShowTitle('Відрахування у зв''язку з нескладанням держ. екзаменів. ');

  ShowInfo('Статус = ''Відрахований''');
  ShowInfo(#13#10);

  AddReason(1002);

  PartConfirm('Date=?FromDate'#13#10 +
              'Status=''О''');
end.
