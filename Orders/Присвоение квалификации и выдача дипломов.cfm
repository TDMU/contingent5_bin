uses
  'confirm.cfm';

begin
  ShowTitle('��������� ����������� �� ������ ������� ' + Params.Item('DiplomaType').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('DiplomaType_KEY').Value);
end.
