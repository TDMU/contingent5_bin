uses
  'confirm.cfm';

begin
  ShowTitle('Утверждение состава групп');

  ShowInfo('Группа = ''' + Params.Item('GroupNum').Value + '''');
  ShowInfo(#13#10);

  AddReason(10000);

  PartConfirm('Date=?OrderDate'#13#10 +
              'GroupNum=?GroupNum');
end.
