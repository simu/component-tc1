local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.tc1;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('tc1', params.namespace);

{
  tc1: app,
}
