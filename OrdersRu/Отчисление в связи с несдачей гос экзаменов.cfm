uses
  'confirm.cfm';

begin
  ShowTitle('���������� � ����� � �������� ��������������� ���������. ');

  ShowInfo('������ = ''��������''');
  ShowInfo(#13#10);

  AddReason(1002);

  PartConfirm('Date=?FromDate'#13#10 +
              'Status=''�''');
end.
