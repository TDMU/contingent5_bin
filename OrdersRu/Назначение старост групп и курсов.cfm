uses
  'confirm.cfm';

begin
  ShowTitle('���������� �������� ' + Params.Item('AssignmentType').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('AssignmentType_KEY').Value);
end.
