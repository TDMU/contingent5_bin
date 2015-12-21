uses
  'confirm.cfm';

begin
  ShowTitle('Отчисление в связи с несдачей государственных экзаменов. ');

  ShowInfo('Статус = ''Отчислен''');
  ShowInfo(#13#10);

  AddReason(1002);

  PartConfirm('Date=?FromDate'#13#10 +
              'Status=''О''');
end.
