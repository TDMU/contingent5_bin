uses
  'confirm.cfm';

begin
  ShowTitle('Объявление ' + Params.Item('Reason').Value);

  ShowNotChangeInfo;

  AddReason(StrToInt(Params.Item('Reason_KEY').Value));
end.
