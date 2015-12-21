uses
  'confirm.cfm';

begin
  ShowTitle('Винесення ' + Params.Item('Reason').Value);

  ShowNotChangeInfo;

  AddReason(StrToInt(Params.Item('Reason_KEY').Value));
end.
