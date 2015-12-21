uses
  'confirm.cfm';

begin
  ShowTitle('Допуск ' + Params.Item('AccessType').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('AccessType_KEY').Value);
end.
