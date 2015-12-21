uses
  'confirm.cfm';

begin
  ShowTitle('Недопуск ' + Params.Item('AccessType').Value);

  ShowNotChangeInfo;

  AddReason(StrToInt(Params.Item('AccessType_KEY').Value) + 1);
end.
