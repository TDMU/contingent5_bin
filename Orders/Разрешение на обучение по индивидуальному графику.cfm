uses
  'confirm.cfm';

begin
  ShowTitle('Надання дозволу ' + Params.Item('OrderReason').Value + ' за індивідуальним графіком');

  ShowNotChangeInfo;

  AddReason(Params.Item('OrderReason_KEY').Value);
end.
