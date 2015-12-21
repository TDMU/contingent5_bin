uses
  'confirm.cfm';

begin
  ShowTitle('назначение старосты ' + Params.Item('AssignmentType').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('AssignmentType_KEY').Value);
end.
