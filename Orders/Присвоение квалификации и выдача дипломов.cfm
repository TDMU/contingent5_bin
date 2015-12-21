uses
  'confirm.cfm';

begin
  ShowTitle('Присвоєння кваліфікації та видача диплома ' + Params.Item('DiplomaType').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('DiplomaType_KEY').Value);
end.
