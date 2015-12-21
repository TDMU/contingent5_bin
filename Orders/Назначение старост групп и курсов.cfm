uses
  'confirm.cfm';

begin
  ShowTitle('призначення старостою ' + Params.Item('AssignmentType').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('AssignmentType_KEY').Value);
end.
