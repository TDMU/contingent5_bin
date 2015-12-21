uses
  'confirm.cfm';

begin
  ShowTitle('Присвоение квалификации и выдача дипломов ' + Params.Item('DiplomaType').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('DiplomaType_KEY').Value);
end.
