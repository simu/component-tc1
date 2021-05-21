// main template for tc1
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.tc1;

local appName = 'fortune-app';
local portName = 'fortune-port';
local containerName = params.images.fortune;
local labelSelector = {
  app: appName,
};

// Define outputs below
{
  '00_namespace': kube.Namespace(params.namespace),

  service: kube.Service('fortune-service') {
    metadata: {
      name: 'fortune-service',
      labels: labelSelector,
      namespace: params.namespace,
    },
    spec: {
      ports: [
        {
          port: params.fortunePort,
          targetPort: portName,
        },
      ],
      selector: labelSelector,
      type: 'LoadBalancer',
    },
  },

  deployment: kube.Deployment('fortune-deployment') {
    metadata: {
      name: 'fortune-deployment',
      labels: labelSelector,
      namespace: params.namespace,
    },
    spec: {
      replicas: 2,
      template: {
        spec: {
          containers: [
            {
              image: containerName,
              name: 'fortune-container',
              ports: [
                {
                  containerPort: 9090,
                  name: portName,
                },
              ],
            },
          ],
        },
        metadata: {
          labels: labelSelector,
        },
      },
      selector: {
        matchLabels: labelSelector,
      },
      strategy: {
        type: 'Recreate',
      },
    },
  },
}
