uses
  'confirm.cfm';

begin
  ShowTitle('Предоставление разрешения ' + Params.Item('OrderReason').Value + ' по индивидуальному графику');

  ShowNotChangeInfo;

  AddReason(Params.Item('OrderReason_KEY').Value);
end.
