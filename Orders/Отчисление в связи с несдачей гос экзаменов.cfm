uses
  'confirm.cfm';

begin
  ShowTitle('³���������� � ��''���� � ������������ ����. ��������. ');

  ShowInfo('������ = ''³����������''');
  ShowInfo(#13#10);

  AddReason(1002);

  PartConfirm('Date=?FromDate'#13#10 +
              'Status=''�''');
end.
