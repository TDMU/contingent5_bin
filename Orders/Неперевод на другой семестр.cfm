uses
  'confirm.cfm';

begin
  ShowTitle('������������� �� ����� �������');

  ShowNotChangeInfo;
  ShowInfo(#13#10);

  AddReason(5000 + Params.Item('NewSemester').Value - 1);
end.
