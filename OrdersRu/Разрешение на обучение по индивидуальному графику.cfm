uses
  'confirm.cfm';

begin
  ShowTitle('�������������� ���������� ' + Params.Item('OrderReason').Value + ' �� ��������������� �������');

  ShowNotChangeInfo;

  AddReason(Params.Item('OrderReason_KEY').Value);
end.
